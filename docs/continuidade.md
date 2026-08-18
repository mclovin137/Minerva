# Continuidade operacional

## Identificação

- Task operacional: migração da continuidade e ajuste documental dos playbooks na PR #1.
- Classificação: via rápida de governança. O usuário decidiu explicitamente não criar ADR para esta migração, resolvendo pela regra 10 a exigência anterior de ADR.
- Responsabilidade atual: implementação delimitada por Severino; revisão independente permanece pendente.

## Objetivo e limites

Unificar planejamento e estado observado em um único artefato, atualizar os adaptadores de continuidade, introduzir opt-in de recursos e alinhar os índices aos três playbooks fornecidos pelo usuário.

- Não criar produto, stack, dependência, diagrama ou infraestrutura de aplicação.
- Não alterar o conteúdo de `playbook-backend.md`, `playbook-database.md` ou `playbook-security.md`.
- Não sincronizar as alterações novas na base Obsidian nesta mudança: as pendências verificáveis abaixo são a fonte operacional temporária até a sincronização. A única ação externa executada foi a remoção autorizada da cópia canônica da decisão arquitetural anterior.

## Plano

1. Criar `docs/continuidade.md` e remover os arquivos de continuidade substituídos.
2. Ajustar regras, skills, roles, agentes, adaptadores e workflow ao novo contrato, sem ADR por decisão explícita do usuário.
3. Criar onboarding de opt-in para documentos, agentes, skills e hooks, mantendo somente esse hook ativo por padrão.
4. Remover referências aos nomes antigos dos playbooks, sem restaurar seu conteúdo.
5. Executar validações documentais e dos hooks, enviar commit na branch atual e atualizar a PR #1.
6. Sincronizar as notas pendentes na base Obsidian até o prazo ou antes, se o usuário solicitar; conferir cada caminho antes de declará-lo sincronizado.

## Estado observado

- O repositório continua sendo template agnóstico de tecnologia; Git, GitHub e Docker são as únicas fundações vigentes.
- A branch atual é `chore/registrar-publicacao-bootstrap`; a PR #1 permanece aberta e não será mesclada nesta task.
- Os playbooks corretos são `docs/playbooks/playbook-backend.md`, `docs/playbooks/playbook-database.md` e `docs/playbooks/playbook-security.md`; os nomes anteriores estão em remoção documental.
- O roadmap de produto não possui conteúdo aprovado; esta é uma lacuna explícita, não um backlog inferido.

## Resumo decisório

- **Objetivo:** trocar os artefatos duplicados de continuidade por uma fonte operacional única e rastrear a sincronização documental diferida.
- **Decisão:** o usuário autorizou expressamente a migração sem ADR, resolvendo o conflito material entre a natureza estrutural da mudança e a dispensa solicitada (regra 10). `docs/continuidade.md` é a fonte operacional temporária rastreada no repositório. A regra 11 torna documentos, agentes, skills e hooks opcionais por sessão; apenas o onboarding mínimo é ativo por padrão, e resposta conversacional não reconfigura hooks. Todo gatilho documental vira pendência imediata com origem, destino, responsável e prazo máximo de 24 horas; a base Obsidian só é declarada atualizada após conferência.
- **Evidências:** `jq` confirmou que apenas onboarding está registrado e que não há `PreToolUse`/`PostToolUse` ativo; `bash -n`, paridade de skills/agentes e rejeição de cache passaram. Smoke dos hooks com payload seguro validou onboarding e os adaptadores inativos; em clone temporário, a continuidade preservou idempotência e alterou apenas a região gerada. Busca de referências legadas, links Markdown, `git diff --check` e varredura de padrões de credenciais passaram. A cópia canônica conhecida da decisão anterior foi conferida antes e confirmada ausente após sua remoção autorizada. Commit `2677a4ba449e195cb672b10e8ed749bb4e2cc6b3` foi enviado sem força para a PR #1; o workflow `Validar template` concluiu com sucesso em https://github.com/mclovin137/Minerva/actions/runs/32169498343.
- **Riscos e lacunas:** a base Obsidian pode ficar temporariamente defasada dentro do prazo. Divergência não é reconciliada silenciosamente e pendência vencida bloqueia conclusão ou trabalho dependente.
- **Próximo passo:** aguardar revisão independente da PR #1; depois, sincronizar as pendências listadas dentro do prazo e conferir cada destino antes de declará-lo atualizado.

### Decisões explícitas do usuário

- 2026-08-18 — Pela regra 10, o usuário resolveu o conflito material desta migração autorizando-a sem decisão arquitetural registrada; não há artefato substituto.
- 2026-08-18 — O usuário solicitou a remoção da decisão arquitetural anterior e de sua cópia canônica conhecida, sem substituta. As decisões vigentes de template permanecem declaradas em `docs/rules.md`.

## Histórico concluído

- 2026-08-18 — Bootstrap publicado excepcionalmente em `main` por autorização explícita do usuário para remoto vazio: commit `3553497ac1a82f7bded87c73978831e5c58fdb48`; workflow `Validar template` concluído com sucesso em https://github.com/mclovin137/Minerva/actions/runs/32166131075.
- 2026-08-18 — Registros pós-publicação foram abertos na branch `chore/registrar-publicacao-bootstrap`: commit `89024c6f9f7fb0d91b91e0b08d343f8b3f037dde`; PR #1 https://github.com/mclovin137/Minerva/pull/1.

## Sincronização Obsidian

Pendências criadas em `2026-08-18`, com prazo máximo em `2026-08-19T23:59:59-03:00`. A coluna de destino não comprova escrita nem conferência; nenhuma das notas abaixo é declarada sincronizada nesta mudança.

| Origem no repositório | Destino na base Minerva | Responsável | Prazo | Situação |
|---|---|---|---|---|
| `docs/rules.md`, `docs/recursos-template.md` | `regras-de-ferro.md`, nota de governança para onboarding | Homem de Ferro | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/agentes/homem-de-ferro.md`, `docs/agentes/severino.md`, `docs/agentes/yoda.md`, `docs/agentes/README.md` | `agentes/homem-de-ferro.md`, `agentes/severino.md`, `agentes/yoda.md`, `agentes/index.md` | Homem de Ferro | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/roles/implementar.md`, `docs/roles/orquestrar.md` | `roles/implementar.md`, `roles/orquestrar.md` | Homem de Ferro | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/skills/atualizar-obsidian.md`, `docs/skills/auditar-dependencias.md`, `docs/skills/auditoria.md`, `docs/skills/criar-task.md`, `docs/skills/deep-research.md`, `docs/skills/gerar-adr.md`, `docs/skills/gerar-fdd.md`, `docs/skills/gerar-hld.md`, `docs/skills/gerar-prd.md`, `docs/skills/mapear-codebase.md`, `docs/skills/refinar-task.md` | notas homônimas em `skills/` | Yoda | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/hlds/README.md`, `docs/fdds/README.md` | `hlds/README.md`, `fdds/README.md` | Yoda | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| Escopo e estado desta task | `tasks/t-002-governanca-controles-e-c4.md` | Homem de Ferro | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |

## Região gerada

<!-- minerva-continuity:generated:start -->
Última sincronização: `2026-08-18T18:12:33Z`

### Criados
- `docs/fdds/README.md`
- `docs/hlds/README.md`

### Alterados
- `README.md`
- `docs/rules.md`

### Removidos
- Nenhum.

Este registro não altera nem conclui a checklist da task.
<!-- minerva-continuity:generated:end -->
