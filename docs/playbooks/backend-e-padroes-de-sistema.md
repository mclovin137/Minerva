# Playbook: Backend e padrões de sistema

> Consulta seletiva. Use o índice gatilho para abrir somente a seção necessária. Este playbook é diagnóstico e decisório. As ADRs e o HLD são prescritivos. Anti-overengineering é o critério dominante.

## Índice gatilho

| Situação | Seção |
|---|---|
| endpoint altera dado | §1 Idempotência |
| importação | §1, §2, §6 |
| PDF, e-mail ou trabalho assíncrono | §2 Fila |
| comunicação entre contextos | §3 Evento e contrato |
| serviço externo | §4 Resiliência |
| cache | §5 Cache |
| lote grande | §6 Lote |
| erro de domínio/HTTP | §7 Erro |
| abstração ou padrão novo | §8 Não usar |

## 1. Idempotência

Obrigatória na importação, lançamento de nota e jobs reprocessáveis.

1. Prefira constraint única de negócio. Exemplo: `UNIQUE(matricula_id, turma_componente_id, bimestre)`.
2. Use `upsert` quando a semântica for deixar o recurso no estado solicitado.
3. Chave de idempotência só entra quando existir cliente externo que repete requisição e um FDD a exigir.

Teste mínimo: rode a operação duas vezes com a mesma entrada. O estado final precisa ser igual e a segunda execução precisa ter semântica declarada.

## 2. Fila e cache

Fila e cache são capacidades a decidir por ADR da aplicação. A decisão deve cobrir provedor, persistência, worker, recuperação e limites.

Use fila para PDF em lote, e-mail e importação que exceda o tempo aceitável da requisição. Antes de enfileirar, comprove:

- worker ou executor equivalente realmente executa sem usuário presente;
- job é idempotente;
- retry é limitado e observável;
- falha definitiva vai para estado reconciliável;
- job crítico não se perde no free tier.

Até a topologia de execução assíncrona ser aceita, nada que precise acontecer sem nova requisição pode depender de fila. A aplicação consumidora deve registrar em ADR como garante entrega, execução e recuperação.

## 3. Evento de domínio e fronteira de contexto

O monólito tem oito bounded contexts (ADR 006). Comunicação não acessa entidade interna alheia. Use id, evento ou contrato explícito definido no HLD/FDD.

Exemplo conceitual: uma mudança de nota pode publicar um evento com o identificador da matrícula, do componente e do período, sem expor entidades internas.

- evento carrega ids e valores imutáveis, não entidade Eloquent;
- listener síncrono participa da falha da operação;
- listener assíncrono só é aceito quando a fila estiver operacionalmente comprovada;
- dado necessário imediatamente pede contrato/chamada explícita, não evento;
- outbox não entra sem broker externo e problema transacional comprovado.

## 4. Resiliência com serviço externo

Aplica-se a storage, e-mail e futuras integrações.

- timeout explícito sempre;
- retry somente para erro transitório e operação idempotente;
- backoff exponencial com jitter;
- nunca fazer HTTP dentro de transação de banco;
- circuit breaker somente com volume e falha que o justifiquem.

## 5. Cache

Um cache aprovado pode armazenar dado muito lido e pouco alterado, como disciplinas, unidades, períodos e grade publicada. Não cacheie nota, frequência ou mensagem sem FDD de consistência e invalidação.

Prefira TTL curto e mensure hit rate. Cache nunca é fonte de verdade e indisponibilidade dele não pode corromper nota, atividade ou matrícula.

## 6. Processamento em lote

- `chunkById`, nunca `chunk` quando a iteração altera o conjunto filtrado;
- lotes de 1 mil a 10 mil, ajustados por medição;
- transação por lote, não uma transação para todo o arquivo;
- checkpoint persistido;
- contadores de lidos, gravados, rejeitados e motivos;
- `--dry-run` obrigatório;
- erro e log não acumulam dado pessoal ou array ilimitado.

Use também o playbook [Banco de dados e SQL](banco-de-dados-e-sql.md).

## 7. Modelagem de erro

Exceções de domínio devem ser tipadas e nomeadas pela regra violada, em convenção compatível com a linguagem escolhida.

| Situação | HTTP |
|---|---|
| entrada malformada ou regra violada | 422 |
| não autenticado | 401 |
| sem permissão | 403 |
| inexistente ou de outro dono | 404 |
| conflito de estado | 409 |

Nunca vaze `QueryException`, SQL, caminho, versão ou binding ao cliente.

## 8. Quando não usar padrão

| Padrão | Não usar sem evidência porque |
|---|---|
| CQRS com banco separado | read-model no mesmo monólito evita sincronização distribuída |
| event sourcing | auditoria transacional atende o histórico sem reconstrução total |
| microsserviços | os oito contextos já isolam domínio em uma unidade de deploy |
| camada que só repassa chamada | aumenta navegação sem proteger regra |
| interface com uma implementação | abstração especulativa, exceto contrato de fronteira |
| outbox, saga, circuit breaker | exigem problema distribuído real |
| cache universal | invalidação incorreta serve dado escolar velho |

O padrão precisa resolver um problema atual comprovado. Uma decisão que diverge do HLD exige ADR antes do código.

## Checklist

- [ ] operação idempotente ou duplicidade detectável por constraint
- [ ] fila e worker comprovados, quando aplicável
- [ ] comunicação entre contextos por contrato/id/evento
- [ ] chamada externa com timeout e fora da transação
- [ ] erro tipado e mapeado
- [ ] recurso de outro dono devolve 404
- [ ] nenhum padrão da §8 sem problema correspondente
