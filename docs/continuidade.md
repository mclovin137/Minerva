# Continuidade operacional

**Autor:** Cristóvão Augusto

## Estado atual

- Task: 0064 — auditoria semanal de dependências e higiene do repositório; desativação dos hooks de onboarding.
- Classificação: automação de CI e adaptadores de ferramenta; não há mudança de dependência de aplicação.
- Situação: implementação concluída; validação e revisão independente pendentes.
- Branch observada: `main`.

## Decisões vigentes

- O onboarding apresenta documentos e skills individualmente; agentes e hooks seguem seus contratos e configurações, sem escolha conversacional.
- Neo e Severino consultam os playbooks aplicáveis e registram as seções utilizadas.
- A criação de documentos segue a taxonomia e o encadeamento proporcional entre PRD, HLD, FDD, LLD, RFC e ADR.
- ADR registra uma decisão arquitetural por vez, com motivo, ciclo de vida, links bidirecionais e confirmação humana das relações propostas por IA.

## Evidências

- `git diff --check`, `bash -n` dos hooks, `jq empty .codex/hooks.json` e smoke dos hooks de onboarding passaram.
- O playbook de backend preserva as seções A, A.1, B, C, D e E; suas referências diretas a Go foram removidas.
- O workflow de validação foi alinhado ao contrato atual do onboarding e verifica pergunta, lista de documentos, lista de skills e exclusão de agentes e hooks como opções.
- O workflow `dependency-audit` é semanal, silencioso quando limpo e mantém uma única issue aberta quando há achados; ele só executa as verificações Go e npm se os manifestos previstos existirem.
- Os adaptadores de onboarding para Claude Code e Codex permanecem versionados, mas não são registrados em `SessionStart`.
- O hook versionado `.githooks/pre-push` delega os gates locais a `.github/scripts/validar-pipeline-local.sh`; `core.hooksPath` não foi configurado nesta sessão.

## Pendências de sincronização Obsidian

As alterações de governança, agentes, hooks, playbook e task continuam pendentes de sincronização e conferência na base Minerva. Esta tabela é o registro operacional até a sincronização; nenhuma nota é declarada atualizada antes da conferência.

| Origem no repositório | Destino na base Minerva | Responsável | Prazo | Situação |
|---|---|---|---|---|
| `docs/rules.md`, `docs/recursos-template.md`, `AGENTS.md`, `CLAUDE.md`, hooks, configuração do Codex/Claude e workflow de validação | `regras-de-ferro.md`, nota de governança para onboarding | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/agentes/neo.md`, `docs/agentes/severino.md` | `agentes/neo.md`, `agentes/severino.md` | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/playbooks/playbook-backend.md` | `playbooks/playbook-backend.md` | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| Escopo e estado desta task | `tasks/t-002-governanca-controles-e-c4.md` | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `.github/workflows/dependency-audit.yml`, `.github/scripts/guard-lib-md.sh` e escopo da task 0064 | `tasks/t-0064-auditoria-semanal-de-dependencias-e-higiene.md` | Severino | 2026-08-18T23:59:59-03:00 | sincronizada e conferida em 2026-08-18 |
| `.claude/settings.json`, `.codex/hooks.json`, `docs/rules.md` e `validar-template.yml` | `governanca/hooks-onboarding-inativos.md` | Severino | 2026-08-18T23:59:59-03:00 | sincronizada e conferida em 2026-08-18 |
| Autoria declarada, agentes e skills renomeados nesta sessão | notas correspondentes de agentes e skills na base Minerva | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `.githooks/pre-push` e `.github/scripts/validar-pipeline-local.sh` | `tasks/t-0064-auditoria-semanal-de-dependencias-e-higiene.md` | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |

## Próximo passo

Executar as validações da task 0064, realizar revisão independente e sincronizar as pendências acima antes do prazo.

## Região gerada

<!-- minerva-continuity:generated:start -->
<!-- minerva-continuity:generated:end -->
