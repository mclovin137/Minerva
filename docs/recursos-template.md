# Recursos opcionais do template

**Autor:** Cristóvão Augusto

## Onboarding mínimo da sessão

Este é o único recurso inevitável do template. Na primeira resposta da sessão, antes de usar
documentos ou skills do projeto, apresente os itens disponíveis de cada uma dessas categorias e
pergunte exatamente:

> Quais documentos e skills do template você quer habilitar nesta sessão? Escolha os itens pelo nome, todos ou nenhum.

Até a resposta, não leia, crie, altere ou execute documentos ou skills além desta instrução mínima.
Não persista nem deduza a escolha: a resposta do usuário governa somente a sessão atual e pode ser
alterada a qualquer momento.

## Aplicação da escolha

- **Nenhum:** não use documentos nem skills opcionais do template, respeitando instruções superiores da ferramenta.
- **Seleção parcial:** use somente os documentos e as skills nomeados pelo usuário.
- **Todos:** use os documentos e as skills necessários à atividade, conforme seus contratos.

Antes de usar um documento ou uma skill, explique dependências necessárias. Por exemplo, uma skill
pode exigir ler sua definição canônica e o contrato aplicável. Nada é habilitado silenciosamente.

Agentes e hooks não são itens de escolha no onboarding. Agentes são acionados conforme a
responsabilidade e os gatilhos canônicos; hooks obedecem à configuração versionada e ao suporte
comprovado da ferramenta. A resposta conversacional não reconfigura hooks automaticamente; não há
persistência oculta, `UserPromptSubmit` nem escrita automática de configuração. Hooks não ativos
continuam versionados e podem ser validados sem serem executados pela sessão.

Depois do opt-in, cada documento e skill escolhido mantém integralmente seu contrato.
`docs/rules.md` continua sendo a fonte canônica das regras quando documentos de governança forem habilitados.

## Itens apresentados pelo hook

O hook monta a lista a partir dos índices versionados: documentos de governança em `docs/` e skills
em `docs/skills/`. Ele apresenta cada item pelo nome e caminho, sem carregar o conteúdo do item
antes da escolha. Agentes e hooks não aparecem nessa lista.
