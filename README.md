# Minerva

Minerva é um template para desenvolvimento assistido por IA, agnóstico de tecnologia. Ele não define aplicação, linguagem, framework, banco, provedor ou topologia: essas escolhas só existem após decisão documentada para uma aplicação consumidora.

## Comece por aqui

[docs/rules.md](docs/rules.md) é a fonte canônica de governança. Antes de retomar qualquer trabalho, leia também os quatro artefatos de continuidade:

- [rules](docs/rules.md): contrato, regras e fluxo.
- [plan](docs/plan.md): task operacional ativa.
- [state](docs/state.md): estado observado e lacunas.
- [lib](docs/lib.md): inventário de dependências e serviços.

As responsabilidades são separadas para evitar autoaprovação: orquestrar, planejar/revisar e implementar. O catálogo canônico está em [docs/agentes](docs/agentes/README.md), incluindo o `c4-diagram-generator`, que gera apenas diagramas C4 fundamentados em FDD aprovado. As skills canônicas estão em [docs/skills](docs/skills/README.md).

## Fluxo

Ajuste básico ou urgente sem gatilho documental e fora das exclusões da regra 9 só pode seguir a exceção enxuta após autorização explícita do usuário para aquela mudança: branch nova, PR, validação proporcional e revisão independente. A IA apenas apresenta a possibilidade, o escopo, os controles mantidos e a documentação dispensada; nunca inicia esse caminho por conta própria. Mudança documental, de governança, adaptador ou automação mecânica sem comportamento de produto segue a via rápida: task delimitada, validação proporcional e revisão independente. Feature ou mudança estrutural segue o fluxo completo: roadmap, épico, PRD, HLD quando estrutural, FDD quando aplicável, task, implementação, auditoria e merge. Conflito material entre regras para e volta ao usuário com alternativas e trade-offs. Os gates e gatilhos estão em [docs/rules.md](docs/rules.md).

## Documentação oficial

A base Obsidian Minerva é a documentação oficial. ADRs, PRDs, HLDs e roles têm cópia canônica na base e espelho de leitura no repositório; skills e agentes são canônicos no repositório e registrados na base. Toda mudança em artefato-gatilho atualiza a nota correspondente no mesmo turno, conforme [atualizar-obsidian](docs/skills/atualizar-obsidian.md).

## Validação

O workflow [validar-template.yml](.github/workflows/validar-template.yml) valida JSON, scripts de hook, smoke tests, paridade de adaptadores, referências Markdown e resíduos de cache. Localmente, reproduza apenas esses gates agnósticos disponíveis no repositório; comandos de build, teste ou análise da aplicação só podem ser definidos depois da ADR de stack.
