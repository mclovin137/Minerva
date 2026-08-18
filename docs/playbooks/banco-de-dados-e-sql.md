# Playbook: Banco de dados e SQL

> Consulta seletiva. Este playbook é diagnóstico. Para migration, aplique a skill [`criar-migration`](../skills/criar-migration.md). A persistência é uma decisão da aplicação consumidora; qualquer tecnologia citada em dossiê de legado é apenas fato histórico.

## Índice gatilho

| Situação | Seção |
|---|---|
| query em loop ou lazy loading | §1 N+1 |
| query lenta | §2 EXPLAIN |
| índice | §3 Índices |
| consulta antes de insert | §4 Check-then-act |
| conversão do legado | §5 Tipos |
| lentidão sob carga | §6 Locks |
| lista grande | §7 Paginação |
| importação | §5 e §8 |

## 1. N+1

Detecte com `Model::preventLazyLoading()` em dev/teste, contagem de queries e ferramenta de observabilidade aprovada. Para caminho crítico, teste limite de queries.

```
DB::enableQueryLog();
$this->getJson('/api/boletim/1')->assertOk();
expect(DB::getQueryLog())->toHaveCount(4);
```

Use eager loading explícito e monte o agregado no domínio. Pontos de risco: boletim, histórico, turma com notas e chat com não lidas.

## 2. Diagnóstico com EXPLAIN

```sql
EXPLAIN (ANALYZE, BUFFERS) SELECT ...;
```

| Sinal | Interpretação | Ação possível |
|---|---|---|
| `Seq Scan` em tabela grande | índice ausente/inútil | revisar predicado e índice |
| estimativa diverge do actual | estatística desatualizada | `ANALYZE` |
| `Nested Loop` interno enorme | plano ruim para volume | revisar join/índice |
| muitos buffers lidos | I/O alto | índice menor ou menos colunas |
| filtro remove quase tudo | baixa seletividade do acesso | índice parcial/composto |
| sort em disco | ordenação excede memória | índice que entregue a ordem |

Seq scan em tabela pequena pode ser correto. Sempre relacione o plano ao volume aprovado.

## 3. Índices

Índice ajuda `WHERE`, `JOIN` ou `ORDER BY` frequente e seletivo. Atrapalha escrita e manutenção quando redundante ou em coluna booleana isolada.

```sql
SELECT relname, indexrelname, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY relname;
```

Toda FK nova deve ter índice coerente com o acesso. Remoção de índice exige migration reversível e evidência.

## 4. Check-then-act

`SELECT` seguido de `INSERT` permite corrida. A constraint é a verdade; validação anterior é apenas mensagem amigável. Capture violação única e traduza para exceção de domínio.

CPF, e-mail, matrícula e nota por bimestre devem usar unicidade física quando o requisito a exigir.

## 5. Tipos e legado

Antes da importação, profile datas, números, nulos, strings vazias e charset. Política para valor inválido é decidida antes: rejeitar e relatar, corrigir por regra aprovada ou quarentenar. Nunca converter silenciosamente nota inválida para zero.

Armadilhas conhecidas da fonte legada Atena:

- `''` não é `NULL`;
- decimal com vírgula não pode usar cast ingênuo;
- `latin1` e `utf8` podem coexistir;
- campos redundantes de nota precisam de decisão de fonte da verdade;
- não use `float` para nota.

Esses achados são riscos a verificar na fonte legada real, não fatos automaticamente válidos para todo registro do legado.

## 6. Contenção e lock

```sql
SELECT pid, wait_event_type, wait_event, state, query
FROM pg_stat_activity
WHERE state <> 'idle' AND wait_event IS NOT NULL;

SELECT * FROM pg_locks WHERE NOT granted;
```

Riscos: fechamento de bimestre, hot row agregado, migration e importação em paralelo. Mantenha transações curtas e sem HTTP, PDF ou storage externo.

Cache, sessão e fila só são planejados após ADR da aplicação. Não presuma que uma tecnologia de persistência ou cache atende a esses papéis sem requisitos e evidências.

## 7. Paginação

Para listas crescentes, prefira keyset:

```sql
WHERE (created_at, id) < (?, ?)
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

Exige índice coerente. Em importação, use `chunkById()`.

## 8. Reconciliação da importação

Antes do cutover, compare:

1. contagem por entidade e escopo;
2. chaves naturais e relacionamentos;
3. amostras determinísticas;
4. agregados de negócio, como média e soma de notas por turma/bimestre;
5. rejeições e transformações aplicadas.

Contagem igual não prova valor correto. Divergência bloqueia cutover até decisão registrada.

## Checklist

- [ ] lazy loading não ocorreu
- [ ] `EXPLAIN (ANALYZE, BUFFERS)` coerente em fluxo crítico
- [ ] toda FK indexada de acordo com acesso
- [ ] unicidade por constraint
- [ ] predicado sargável
- [ ] keyset em lista crescente
- [ ] tipos corretos e nota sem `float`
- [ ] transação curta e sem I/O externo
- [ ] migration reversível conforme skill
- [ ] reconciliação de negócio definida
