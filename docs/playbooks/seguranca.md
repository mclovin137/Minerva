# Playbook: Segurança

> Consulta seletiva. Este playbook é diagnóstico. Para revisão prescritiva, aplique a skill [`security-review`](../skills/security-review.md). Cliente é hostil; validação apenas no frontend é inexistente.

## Índice gatilho

| Diff toca | Seção |
|---|---|
| rota/controller/middleware | §1 Autorização |
| SQL/string dinâmica | §2 Injection |
| login/senha/sessão | §3 Autenticação |
| upload | §4 Upload |
| HTML/Blade | §5 XSS |
| log/exceção | §6 PII |
| POST/formulário | §7 CSRF/headers |
| dependência | §8 Supply chain |
| importação | §9 Importação |
| dado de aluno | §6 e §10 LGPD |

## 1. Autorização

Identidade e papel vêm de `auth()->user()`, nunca do payload. Toda rota declara Policy/Gate e cada endpoint testa:

- sem credencial;
- credencial expirada;
- papel errado;
- acesso horizontal com id de outro usuário;
- acesso vertical a função administrativa.

Recurso de outro dono devolve 404 para não confirmar existência. Endpoint sem regra declarada é achado bloqueante.

## 2. Injection

Audite `whereRaw`, `havingRaw`, `orderByRaw`, `selectRaw`, `DB::raw`, `DB::select`, `DB::statement` e `DB::unprepared`. Valor usa binding; nome de coluna/direção usa allowlist.

Também cubra:

- path traversal em `Storage`;
- command injection em `Process`/`exec`;
- XSS armazenado/refletido/DOM;
- template, log, header e desserialização;
- CSV formula injection em exportação.

## 3. Autenticação

- Argon2id; pepper somente após decisão/configuração segura;
- segredo no Secret Manager, nunca no código;
- rate limit por credencial e IP;
- regenerar sessão no login e mudança de privilégio/impersonation;
- resposta não enumera usuário;
- comparação de token usa função constante apropriada;
- MFA para papéis críticos conforme requisito aprovado.

## 4. Upload

Antes de implementar upload, a aplicação deve definir por ADR o adapter, o destino, a identidade e a retenção. Não dependa de filesystem local sem a durabilidade e o isolamento requeridos.

Controles cumulativos:

1. validar assinatura real do arquivo;
2. allowlist de extensão e tamanho;
3. nome gerado no servidor;
4. storage privado fora do webroot;
5. autorização no upload e download;
6. URL assinada curta quando aplicável;
7. teste com conteúdo malicioso.

## 5. XSS e saída

Blade `{{ }}` escapa; `{!! !!}` com dado do usuário é achado. Escape ocorre no contexto de saída. Sanitização na entrada não substitui encoding em HTML, atributo, JavaScript, URL, CSV ou PDF.

## 6. PII em log e erro

Nunca logar nome, CPF, e-mail, endereço, telefone, nascimento, valor de nota, senha/hash, MFA ou token. Logue ids técnicos, contagens e códigos de rejeição.

`QueryException` pode conter bindings; `ValidationException` pode conter payload. Trate antes de serializar/logar. Produção usa debug desligado e saída estruturada sem stack trace.

## 7. CSRF e headers

Exclusão de CSRF exige justificativa no PRD/FDD. Headers mínimos:

- `Content-Security-Policy`;
- `Strict-Transport-Security`;
- `X-Frame-Options: DENY`;
- `X-Content-Type-Options: nosniff`;
- `Referrer-Policy`.

Force HTTPS em produção e registre onde o TLS termina na arquitetura aprovada.

## 8. Supply chain

Execute auditoria de dependências antes de adicionar pacote e nos pipelines. Registre versão em `docs/lib.md`. Um CVE só é afirmado com fonte verificável. Skill ou agente externo também é supply chain de instrução e passa por `security-scan`.

## 9. Importação

- unidade de destino vem da Policy, não da planilha;
- conexão com fonte legada é somente leitura e segredo fica fora do código;
- arquivo importado obedece todos os controles de upload;
- nenhum dump intermediário não criptografado;
- log contém contagens/ids, não linhas de aluno;
- relatório de rejeição é artefato autorizado separado;
- reexecução idempotente;
- exportação neutraliza célula iniciada por `=`, `+`, `-` ou `@`.

## 10. LGPD e menores

Nota, atividade e matrícula são críticas tanto para sigilo quanto integridade. Antes de dado real, PRD/FDD precisam definir:

- retenção após saída do aluno;
- anonimização versus histórico escolar legal;
- acesso nominal por papel;
- retenção de auditoria;
- transparência de impersonation;
- backup, restore e exclusão segura.

Desconhecido é `❓ LACUNA`; não invente política.

## Checklist

- [ ] id de dono não vem do request como autoridade
- [ ] toda rota tem Policy/Gate e matriz de autorização
- [ ] Testes de integração cobrem todos os papéis e acesso horizontal
- [ ] raw SQL parametrizado ou allowlist
- [ ] senha/sessão/rate limit corretos
- [ ] upload privado após adapter e identidade aprovados
- [ ] saída escapada por contexto
- [ ] zero PII e segredo em log
- [ ] headers e CSRF verificados
- [ ] dependências auditadas e registradas
- [ ] segredo apenas em Secret Manager/local não versionado
