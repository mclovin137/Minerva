# Recursos opcionais do template

## Onboarding mínimo da sessão

Este é o único recurso inevitável do template. Na primeira resposta da sessão, antes de usar documentos, agentes, skills ou hooks do projeto, pergunte exatamente:

> Quais recursos do template você quer usar nesta sessão? Você pode escolher documentos, agentes, skills e hooks — todos, alguns ou nenhum.

Até a resposta, não leia, crie, altere ou execute esses recursos além desta instrução mínima. Não persista nem deduza a escolha: a resposta do usuário governa somente a sessão atual e pode ser alterada a qualquer momento.

## Aplicação da escolha

- **Nenhum:** trabalhe sem a governança do template, respeitando instruções superiores da ferramenta.
- **Seleção parcial:** use apenas as categorias e itens escolhidos.
- **Todos:** os recursos necessários à atividade podem ser usados conforme seus contratos.

Antes de usar um recurso, explique dependências necessárias. Por exemplo, usar um agente ou uma skill pode exigir ler sua definição canônica e o contrato aplicável; usar um hook depende de suporte comprovado da ferramenta. Nada é habilitado silenciosamente.

A resposta conversacional orienta a sessão, mas não reconfigura hooks automaticamente. Para ativar automação real de ciclo de vida em sessão futura, o usuário deve pedir ou autorizar a configuração compatível; não há persistência oculta, `UserPromptSubmit` nem escrita automática de configuração. Hooks não ativos continuam versionados e podem ser validados sem serem executados pela sessão.

Depois do opt-in, cada recurso escolhido mantém integralmente seu contrato. `docs/rules.md` continua sendo a fonte canônica das regras quando documentos de governança forem habilitados.
