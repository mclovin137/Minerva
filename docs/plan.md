# Plano da task ativa

## Identificação

- Task operacional: bootstrap de publicação do template no GitHub.
- Classificação: exceção explícita do usuário, limitada ao primeiro commit em `main` de remoto confirmado vazio.
- Responsabilidade atual: implementação delimitada por Severino; o usuário autorizou excepcionalmente a ausência de PR e revisão independente somente neste bootstrap.

## Objetivo

Publicar o bootstrap de governança do template no repositório GitHub vazio `mclovin137/Minerva`, sem criar aplicação, stack ou infraestrutura de produto.

## Resumo decisório mínimo

- Objetivo: versionar e publicar o estado atual de governança em remoto vazio, com controles de segredo e permissões antes do commit.
- Decisão: o usuário confirmou que o remoto está vazio, que é titular do conteúdo originário de TGM2 e autorizou, exclusivamente para o bootstrap, commit direto em `main` sem PR e sem revisão independente. Próximos trabalhos retornam ao fluxo normal de branch e PR.
- Evidências: remoto vazio confirmado por `git ls-remote`; revisão de segurança aplicada a `.gitignore`, permissões e varredura de segredos; `git diff --cached --check` passou; commit raiz `3553497ac1a82f7bded87c73978831e5c58fdb48` foi enviado sem força para `origin/main`; HEAD, origem e estado limpo foram confirmados após o push; GitHub Actions concluiu com sucesso: `Validar template` — https://github.com/mclovin137/Minerva/actions/runs/32166131075.
- Riscos e lacunas: a exceção eliminou a revisão independente apenas porque não havia base para PR no remoto vazio. Essa exceção está encerrada; próximos trabalhos exigem branch e PR. Não há roadmap de produto aprovado.
- Próximo passo: criar toda mudança futura em branch própria, atualizar a documentação aplicável e abrir PR para revisão independente.

## Limites

- Não criar produto, stack, dependência, diagrama, pipeline de aplicação ou decisão estrutural.
- Níveis C4 só são gerados futuramente a partir de FDD aprovado e informação suficiente.
- O hook não altera esta checklist nem conclui a task.
- A exceção de publicação direta vale somente para este primeiro commit em remoto vazio; trabalhos posteriores exigem branch e PR.

## Arquivos observados automaticamente
<!-- atena-continuity:plan:start -->
Última sincronização: `2026-08-18T17:30:48Z`

- Criados desde o snapshot anterior: 0
- Alterados desde o snapshot anterior: 1
- Removidos desde o snapshot anterior: 0

Este registro não altera nem conclui a checklist da task.
<!-- atena-continuity:plan:end -->
