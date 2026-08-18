# Continuidade operacional

## Estado atual

- Task: ajustes de governança, playbook de backend, onboarding e documentação de design.
- Classificação: via rápida de governança; não há mudança de produto, dependência ou infraestrutura.
- Situação: implementação, validações, commit e push concluídos; revisão independente e sincronização Obsidian pendentes.
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

## Pendências de sincronização Obsidian

As alterações de governança, agentes, hooks, playbook e task continuam pendentes de sincronização e conferência na base Minerva. Esta tabela é o registro operacional até a sincronização; nenhuma nota é declarada atualizada antes da conferência.

| Origem no repositório | Destino na base Minerva | Responsável | Prazo | Situação |
|---|---|---|---|---|
| `docs/rules.md`, `docs/recursos-template.md`, `AGENTS.md`, `CLAUDE.md`, hooks, configuração do Codex/Claude e workflow de validação | `regras-de-ferro.md`, nota de governança para onboarding | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/agentes/neo.md`, `docs/agentes/severino.md` | `agentes/neo.md`, `agentes/severino.md` | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| `docs/playbooks/playbook-backend.md` | `playbooks/playbook-backend.md` | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |
| Escopo e estado desta task | `tasks/t-002-governanca-controles-e-c4.md` | Severino | 2026-08-19T23:59:59-03:00 | pendente de sincronização e conferência |

## Próximo passo

Realizar revisão independente e sincronizar as pendências acima antes do prazo.
