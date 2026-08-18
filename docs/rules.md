# Roles e regras do projeto Minerva

**Documento canônico e independente de ferramenta.** É a fonte da verdade sobre como este projeto é operado por qualquer IA (Claude Code, Codex, outras) e por qualquer pessoa. Arquivos como `CLAUDE.md` e `AGENTS.md` são adaptadores finos que apontam para cá e não contêm regras próprias.

Regra nova, mudança ou remoção de regra: **acontece aqui**, nunca em um adaptador.

---

## Idioma

**Todo output gerado por qualquer LM neste projeto deve ser em pt-BR.** Isso inclui: respostas ao usuário, mensagens de commit, descrições de PR, comentários de review, documentação, notas do Obsidian, ADRs, PRDs, nomes de tasks e mensagens de erro autorais. Identificadores de código (classes, funções, variáveis), termos técnicos consagrados e saídas de ferramentas de terceiros permanecem como estão.

## Estado e continuidade

Os três artefatos de continuidade vivem em `docs/`, ao lado deste documento: o contrato canônico é [`docs/rules.md`](rules.md); a continuidade operacional da task ativa vive em [`docs/continuidade.md`](continuidade.md); e o inventário de dependências vive em [`docs/lib.md`](lib.md). Após o opt-in para documentos de governança, leia os três antes de retomar uma task.

**A raiz do repositório não hospeda nenhum deles.** `docs/` é o caminho canônico. Caminho de raiz para esses arquivos é erro, não variante aceitável. A referência anterior a ADRs de continuidade pertence ao histórico externo e não é dependência deste template limpo.

Agentes autorizados atualizam semanticamente `docs/continuidade.md`. O hook de uma ferramenta pode atualizar somente a região delimitada como gerada, sem inferir conclusão, alterar checklist ou substituir julgamento. Ferramentas sem adaptador equivalente registram as mutações manualmente antes de entregar. `docs/lib.md` nunca é atualizado pelo hook: toda dependência exige versão e finalidade verificadas por um agente.

---

## Regras de ferro

Não negociáveis. Qualquer proposta que viole uma delas deve ser recusada e substituída por alternativa conforme.

1. **Multi-agente e independente de ferramenta.** O projeto é operado por múltiplas IAs (Claude Code, Codex e outras). Skills, agentes e roles são definidos em markdown neutro, sem depender de recursos exclusivos de um fornecedor. Arquivos específicos de ferramenta (`CLAUDE.md`, `AGENTS.md`, `.codex/`, etc.) são **adaptadores finos** que apontam para a definição canônica — nunca a fonte da verdade.
2. **Output em pt-BR.** Ver seção *Idioma*.
3. **Obsidian é a documentação oficial.** Ver seção *Documentação no Obsidian*.
4. **Três responsabilidades de agente:** orquestrar, planejar/revisar, implementar. Ver seção *Arquitetura de agentes*.
5. **Custo financeiro zero.** Nenhuma dependência, serviço, hospedagem, runner ou ferramenta paga. Só free tier permanente ou open source self-hosted sem custo. Se a única solução viável para um problema for paga, o problema volta para decisão do usuário — não se contrata nada. Ver seção *Escopo da regra 5*.
6. **Sistema no ar desde o primeiro commit.** O commit inicial já entrega aplicação publicada e acessível. Infraestrutura, pipeline e deploy fazem parte do primeiro entregável, não de uma fase posterior.
7. **DDD + teste de integração em todo endpoint.** Ver seção *Arquitetura e testes*.
8. **Dois pipelines de CI/CD:** um de review e um de execução dos casos de teste. Ver seção *CI/CD*.
9. **Exceção enxuta para ajuste básico ou urgente.** Só pode dispensar task e documentação formal com autorização explícita do usuário para aquela mudança e nas condições da seção *Fluxo de trabalho → Exceção enxuta*. Branch nova, PR, revisão independente e segurança continuam obrigatórios.
10. **Conflito material entre regras exige decisão do usuário.** Quando regras de ferro — ou seus efeitos — colidirem materialmente, o agente para e apresenta trade-offs, alternativas, impacto e a regra excepcional ao usuário; nunca escolhe silenciosamente.
11. **Documentos e skills exigem opt-in item a item.** Somente documentos e skills são selecionáveis na sessão; o onboarding mínimo de [`docs/recursos-template.md`](recursos-template.md) apresenta seus itens antes de qualquer uso. Agentes seguem a responsabilidade e os gatilhos canônicos; hooks seguem a configuração versionada e o suporte da ferramenta, sem escolha conversacional. A escolha de documentos e skills vale para a sessão, aceita seleção parcial e pode mudar a qualquer momento. Dependências são explicadas antes da ativação, e nada é habilitado silenciosamente.
---

## Escopo da regra 5

A regra 5 rege **o que o projeto contrata**: dependência, biblioteca, hospedagem, banco de dados, runner de CI, serviço externo, domínio, e qualquer coisa que o sistema precise para existir ou rodar. Tudo isso é free tier permanente ou open source self-hosted sem custo. Solução paga não é adotada por conta própria: volta como decisão do usuário.

A regra 5 **não rege as ferramentas de IA que operam o projeto**. As assinaturas do Claude Code e do Codex/ChatGPT são **custo previsto e aceito pelo usuário**, fora do escopo da regra: são ferramenta de trabalho dele, já existiam antes do projeto e continuariam existindo sem ele.

Consequência prática, para não haver dúvida em auditoria: escolher `opus`, `gpt-5.6-agua`, `gpt-5.6-luna` ou qualquer modelo dentro dessas assinaturas **não viola a regra 5**. Os modelos de cada agente estão em `docs/agentes/` e são escolha do usuário.

A fronteira é a pergunta: *quem paga a conta e por quê?* Se o custo nasce de uma escolha do projeto e entra na infraestrutura do sistema, a regra 5 vale. Se é a ferramenta com que o usuário trabalha, não vale — e continuar cobrando custo zero aí só levaria a operar pior sem economizar nada.

---

## Arquitetura de agentes

Toda atividade pertence a exatamente uma das três responsabilidades. A separação existe para que nenhum agente aprove o próprio trabalho.

Os agentes concretos estão definidos em `docs/agentes/`: **Homem de Ferro** (orquestrar), **Yoda** (arquitetura), **Severino** (todo o código da aplicação), **Ted Mosby** (QA), **Neo** (segurança), **Jarvis** (SRE) e **c4-diagram-generator** (diagramas C4).

**Orquestrador — quando o fluxo da sessão o exigir, é a sessão principal (Homem de Ferro)**
- Interpreta a demanda, localiza a posição dela no fluxo (ver *Fluxo de trabalho*) e delega ao agente certo.
- Mantém estado: o que está em andamento, o que está bloqueado, o que aguarda auditoria.
- **Não altera, não cria e não apaga nenhum arquivo** — inclusive por shell (`>`, `rm`, `mv`, `sed -i`, mutações de git). Toda escrita acontece dentro de um agente delegado; não existe mudança pequena demais para delegar.
- **Não escreve código de produção e não aprova PR.**

**Planejador / Revisor**
- Escreve roadmap, épicos, PRDs e a quebra em tasks.
- Faz a **auditoria** do PR: aderência ao PRD, às regras de ferro, cobertura de testes e evidências.
- **Não implementa a task que ele mesmo planejou** quando houver agente disponível para implementar.

**Implementador**
- Implementa a task, escreve os testes e produz as evidências.
- Abre o PR e responde ao review.
- **Não aprova nem faz merge do próprio PR.**

Definições de agentes, roles e skills são markdown neutro, versionado no repositório, consumível por qualquer ferramenta (regra 1). Skills exigem o opt-in da regra 11; agentes são acionados pelos gatilhos e responsabilidades desta regra. Toda criação/edição/remoção de agente, role ou skill exige atualização do Obsidian quando documentos de governança estiverem habilitados (regra 3).

### Catálogo de agentes

| Agente | Responsabilidade | Escopo principal |
|---|---|---|
| [Homem de Ferro](agentes/homem-de-ferro.md) | Orquestrar | Interpreta, localiza a etapa, delega e acompanha; não escreve arquivos |
| [Yoda](agentes/yoda.md) | Planejar/revisar | Arquitetura, HLD, ADR, trade-offs e conformidade arquitetural |
| [Severino](agentes/severino.md) | Implementar | Todo o código da aplicação, migrations, pipeline-as-code e documentação associada |
| [Ted Mosby](agentes/ted-mosby.md) | Planejar/revisar | Estratégia, casos e evidências de QA; não implementa a feature |
| [Neo](agentes/neo.md) | Planejar/revisar | Auditoria e testes de segurança; reporta e valida, não corrige feature |
| [Jarvis](agentes/jarvis.md) | Implementar operação | Ambientes, pós-pipeline, deploy, rollback, observabilidade, backup e incidente |
| [c4-diagram-generator](agentes/c4-diagram-generator.md) | Planejar/revisar | Diagramas C4 em PlantUML, fundamentados em FDD aprovado |

---

## Documentação no Obsidian

A documentação oficial vive na base **`Minerva`** do vault Obsidian do usuário, **fora deste repositório**:

```
Windows : C:\Users\mclov\OneDrive\Documentos\Obsidian Vault\mclov\Documents\SecondBrain\Bases\Minerva
WSL     : /mnt/c/Users/mclov/OneDrive/Documentos/Obsidian Vault/mclov/Documents/SecondBrain/Bases/Minerva
```

**Todo gatilho vira pendência documental imediata.** Como a base está fora do repositório, o diff do PR não prova sua atualização. Registre em `docs/continuidade.md` a origem, o destino, o responsável e o prazo máximo de 24 horas; sincronize antes se o usuário pedir. A nota só é declarada sincronizada depois de escrita e conferência. A base anterior não pode ser apresentada como atualizada enquanto houver pendência; divergência não é resolvida silenciosamente.

Procedimento obrigatório, com a tabela de gatilhos e o formato das notas: `docs/skills/atualizar-obsidian.md`.

Gatilhos obrigatórios (criação, edição **ou** remoção):

- Regra de negócio
- Dependência (adição, remoção ou upgrade relevante)
- Banco de dados: tabelas, índices, triggers e funções
- ADR
- PRD
- HLD
- FDD
- Roadmap
- Roles
- Skills
- Agentes
- Tasks

Decisões estruturais e escolhas de tecnologia entram como **ADR** — inclusive as pendências listadas no fim deste documento.

**ADR, PRD, HLD, FDD, LLD, RFC e as notas de responsabilidade têm cópia canônica na base e espelho no repositório** (`docs/adrs/`, `docs/prds/`, `docs/hlds/`, `docs/fdds/`, `docs/llds/`, `docs/rfcs/`, `docs/roles/`). O espelho e a pendência seguem o contrato em *Arquitetura e testes → Cópia canônica e espelho*. Pendência dentro do prazo é rastreável; pendência vencida bloqueia conclusão e trabalho dependente.

---

## Fluxo de trabalho

### Taxonomia de documentação

O sistema conhece categorias de documentos além dos artefatos usuais de desenvolvimento. A
taxonomia orienta descoberta, criação e revisão: não autoriza gerar documento por catálogo, nem
rebaixa contratos já exigidos por estas regras. Para cada mudança, cria-se somente o artefato que
responde uma pergunta real, tem dono e permanecerá útil depois da entrega.

| Categoria | Relevantes no fluxo de desenvolvimento | Contextuais ou emergentes | Legados ou de uso restrito |
|---|---|---|---|
| Produto | PRD | épico e user story, conforme a gestão de produto | FRD, quando houver acervo ou contrato herdado a preservar |
| Design e arquitetura | HLD, FDD, ADR e modelo C4 | RFC, LLD, AI Design Doc e Prompt Spec | TRD e LLD no formato RUP, salvo migração ou obrigação externa |
| Conhecimento e referência | engineering guidelines, playbooks e Security Design Doc | documento de avaliação de IA | plano e caso de teste formais isolados, salvo necessidade de auditoria ou contrato externo |
| Operação e infraestrutura | runbook, playbook e documentação de incidente | observabilidade, capacidade e telemetria | Design Doc de infraestrutura e CI/CD quando não forem escopo da task ou responsabilidade do time |

**Produto.** PRD é a referência de problema, valor e critério de aceite. Épicos e user stories
podem complementar a gestão de produto, mas não substituem critérios verificáveis. FRD é tratado
como nomenclatura ou legado: se existir, preserva-se a rastreabilidade e mapeia-se sua função para
o encadeamento vigente, sem criar um paralelo ritualístico.

**Design e arquitetura.** HLD, FDD, ADR e C4 são os artefatos centrais para organizar a solução.
RFC e LLD seguem o critério proporcional desta regra. AI Design Doc e Prompt Spec são usados quando
um comportamento, avaliação, contexto, limitação ou operação de IA fizer parte do sistema; devem
declarar objetivo, entradas, saídas, limites, avaliação e revisão humana. Não são exigidos por um
uso incidental de ferramenta de IA no desenvolvimento.

**Conhecimento e referência.** Engineering guidelines, skills e playbooks preservam práticas
reutilizáveis; Security Design Doc é criado quando o risco de segurança precisar de desenho próprio
além de PRD, HLD, FDD e parecer do Neo. Estratégia, casos e evidências de teste continuam
obrigatórios conforme as regras de QA; o que é contextual é o documento formal separado de plano
ou caso de teste. Documento de avaliação de IA descreve métricas, conjunto de avaliação, critérios
de aprovação, riscos e regressões quando a aplicação usar IA.

**Operação e infraestrutura.** Runbooks e playbooks orientam operação, incidente e recuperação.
Documentos de observabilidade, capacidade, infraestrutura e CI/CD são criados quando a mudança
tocar esses domínios ou quando Jarvis os exigir; não são dispensados por serem secundários à
codificação. Sua responsabilidade depende da task: Severino implementa pipeline-as-code atribuído,
e Jarvis define operação, garantias de liberação e pós-deploy.

**Uso prático.** Antes de criar documento, classifique sua categoria, declare a pergunta que ele
responde, conecte-o aos artefatos anteriores e defina o dono e o revisor. Ao revisar, confirme que
o conteúdo continua atual, que seus links são recíprocos quando houver decisão ou impacto
estrutural, e que não duplica outro artefato. Documento errado, contraditório ou obsoleto é risco
operacional para pessoas e IA: corrigir, substituir ou marcar explicitamente seu estado é
obrigatório.

### Encadeamento entre documentos

Documentos de produto, design e arquitetura formam uma cadeia de abstração: começam no problema
de produto, aproximam-se progressivamente da implementação e registram decisões. Cada artefato
responde uma pergunta própria; eles se complementam, sem competir entre si. A escolha é
proporcional ao porte da mudança, ao risco técnico e à necessidade de alinhamento — não é ritual.

| Documento | Pergunta principal | Nível de detalhe | Momento de uso |
|---|---|---|---|
| PRD | Qual problema de produto deve ser resolvido e qual valor se espera? | baixo detalhe técnico | antes do desenho técnico |
| HLD | Como a solução se organiza em alto nível? | alto nível técnico | após clareza de produto e antes do detalhamento estrutural |
| FDD / FRD | Como uma feature ou módulo será implementado? | detalhe intermediário | quando o escopo da feature estiver definido |
| LLD | Como a implementação concreta será estruturada? | alto detalhe técnico | próximo da implementação, quando reduzir ambiguidade for necessário |
| RFC | Quais alternativas ainda estão em discussão? | variável, orientado ao debate | antes de decisão técnica relevante |
| ADR | Qual decisão arquitetural foi tomada e por quê? | registro objetivo da decisão | depois da decisão |

**PRD** transforma a necessidade em problema, valor esperado, restrições e critérios de aceite.
**HLD** transforma esse contexto em visão técnica compartilhada de componentes,
responsabilidades, integrações e limites, sem entrar em detalhes finos. Em mudança pequena ou
isolada, o HLD pode ser condensado ou absorvido pelo FDD; quando a mudança cruza módulos ou exige
coordenação ampla, ele antecede o detalhamento.

**FDD** — também chamado de *Feature Design Doc*; **FRD** é nomenclatura legada de função
semelhante — detalha o escopo técnico, fluxo principal, impactos e escolhas de uma feature. Ele
fica entre o HLD e o LLD: pode bastar para feature isolada, mas não substitui o HLD quando houver
arquitetura mais ampla. **LLD** desce ao nível de contratos, pontos expostos, campos, padrões e
detalhes executáveis; só é criado quando esse grau de precisão reduzir ambiguidade antes do código.

**RFC** é deliberativa: reúne proposta, objeções e alternativas enquanto a decisão ainda está
aberta. **ADR** é memória técnica: registra a decisão vencedora, seu contexto e justificativa,
podendo ser substituído ou inativado quando deixar de valer. Nem toda decisão exige RFC e ADR, mas
uma decisão estrutural ou tecnológica tomada deve seguir o contrato de ADR desta regra.

No mesmo problema, a cadeia típica é: PRD define objetivo e restrições; HLD organiza a solução;
FDD detalha a feature; LLD fixa detalhes executáveis quando necessário; RFC antecede uma escolha
ainda disputada; ADR registra a escolha tomada. Ao criar qualquer desses documentos, o autor
declara qual pergunta ele responde, quais artefatos anteriores consultou e por que os níveis não
usados não são necessários.

### ADR — memória técnica, elegibilidade e governança

Um **Architecture Decision Record** registra uma decisão arquitetural relevante e, principalmente,
o porquê de ela ter sido tomada: contexto, restrições, alternativas, trade-offs e consequências.
O código mostra o que foi implementado, mas não preserva de forma confiável essas pressões. O ADR
é memória técnica explícita para pessoas e agentes de IA; reduz tradição oral, inferência frágil e
reabertura de decisões sem o contexto que as justificou.

**Uma ADR por decisão.** O documento não descreve o sistema inteiro nem mistura escolhas
independentes. Usa identificador estável e nomenclatura previsível para permitir ordenar, citar e
relacionar decisões. A escrita é objetiva e técnica: contexto suficiente para sustentar a decisão,
sem transformar o ADR em narrativa histórica extensa.

**Uma decisão exige ADR** quando tiver impacto arquitetural duradouro ou difícil de reverter, afetar
múltiplos módulos, equipes ou contratos públicos, ou quando esquecer seu motivo prejudicar
segurança, custo, desempenho, interoperabilidade, operação ou evolução. Exemplos incluem modelo
de modularização, fronteira entre componentes, persistência, autenticação e autorização,
observabilidade, deploy, estratégia de resiliência, versionamento de contrato público, dependência
crítica e lock-in técnico ou operacional.

**Não criar ADR automaticamente** para convenção local já institucionalizada, regra de domínio que
evolui dentro de uma feature, organização de arquivos sem efeito arquitetural, padrão de
implementação sem contrato público ou parâmetro de ajuste frequente. Esses itens pertencem a
README, HLD, FDD ou LLD, salvo quando representarem ruptura de paradigma, restrição sistêmica ou
decisão cuja reversão tenha impacto amplo. Na zona cinzenta, perguntar: “se o porquê se perder,
isso prejudicará a evolução do sistema?”

**Ciclo de vida e revisão.** ADR passa pelo mesmo fluxo governado de código: branch, pull request,
comentários, revisão independente, evidências e histórico. A decisão antiga não é reescrita para
parecer atual: uma decisão nova cria ADR novo, aponta a relação e marca o anterior como
`superseded` ou inativo, conforme o caso. Documento contraditório, incompleto ou obsoleto gera
falsa confiança e deve ser corrigido ou explicitamente marcado; nunca é tratado como contexto
vigente por silêncio.

**Encadeamento e links.** Todo ADR aponta para os PRDs, RFCs, HLDs, FDDs, LLDs e ADRs anteriores
que fundamentam a decisão; os documentos impactados apontam de volta para o ADR. As relações são
explícitas e usam, quando aplicável, `dependsOn`, `relatesTo` e `supersedes`. Assim, o acervo deixa
de ser uma pasta de arquivos e passa a ser um grafo histórico navegável de decisões, antecedentes e
consequências.

**Linkagem assistida, revisão humana obrigatória.** Agentes podem propor relações a partir de
evidências documentadas e do histórico, mas não inventam vínculos nem mudam estado de ADR por
inferência. O revisor confirma cada ligação e seu sentido antes de registrá-la. Essa disciplina
permite que IA recupere intenção arquitetural a partir de contexto declarado, em vez de adivinhar
motivos pelo código.

Antes de qualquer delegação, o Homem de Ferro classifica a mudança como **via rápida** ou **fluxo completo**. Se identificar possível exceção enxuta, ele não a inicia nem a classifica autonomamente: explica escopo, motivo, controles mantidos e documentação dispensada, e pede autorização explícita do usuário para aquela mudança. Fora da exceção autorizada da regra 9, a classificação, as validações e os agentes acionados ficam registrados na task e no resumo decisório mínimo de `docs/continuidade.md`.

### Exceção enxuta: ajuste básico ou urgente

```
branch nova → PR → validações proporcionais → revisão independente → merge
```

Pela regra 9, ajuste básico e/ou urgente pode dispensar **task e documentação formal** somente após autorização explícita do usuário para aquela mudança e quando não introduz, altera ou remove comportamento de produto, regra de negócio, endpoint, contrato público, persistência, integração, dependência, segredo, permissão, pipeline, decisão arquitetural ou mudança estrutural.

- A exceção não dispensa branch nova, PR, revisão independente, validação proporcional, segurança nem obrigação legal, regulatória ou contratual aplicável.
- A LLM ou o orquestrador apenas identifica a possibilidade e pede autorização; não escolhe, classifica nem inicia essa exceção por conta própria.
- Ela não se aplica a nenhum gatilho da regra 3. Se houver gatilho documental, a pendência documental imediata e a sincronização no prazo continuam obrigatórias; se houver dúvida, não usar a exceção.
- O PR registra objetivamente o motivo de urgência ou simplicidade, escopo, validações executadas e a justificativa de não haver gatilho documental. Esse registro não substitui documento obrigatório.
- Neo é acionado para qualquer superfície de segurança; se houver incerteza, acesso a arquivo, hook, permissão, segredo, dependência ou configuração sensível, a exceção para e retorna à via rápida ou ao fluxo completo.
- Qualquer conflito material com outra regra de ferro segue a regra 10: pausar e pedir decisão do usuário com trade-offs, alternativas, impacto e regra excepcional.

### Via rápida: manutenção sem comportamento de produto

```
task curta → implementação delimitada → validações proporcionais → revisão independente → merge
```

Usar somente para mudança documental, governança, adaptador de ferramenta, automação mecânica ou manutenção que **não** introduza, altere ou remova comportamento de produto, regra de negócio, endpoint, contrato público, persistência, integração, dependência ou decisão estrutural.

- A task curta declara objetivo, arquivos ou superfície permitida, exclusões, validações e revisor independente.
- PRD, HLD e FDD não são exigidos quando não houver comportamento de produto. Uma decisão estrutural continua exigindo ADR; impacto estrutural continua exigindo HLD.
- A validação é proporcional e determinística sempre que possível: sintaxe, links, JSON, shell, diff, comportamento do hook ou automação tocada. A revisão independente continua obrigatória.
- Segurança não é opcional: Neo é acionado quando a mudança toca permissões, hooks, segredos, dependências, pipeline, configuração, acesso a arquivos ou superfície de ataque. Jarvis é acionado para ambiente, deploy, rollback, observabilidade, backup ou custo. Ted é acionado se surgir comportamento observável ou contrato testável. Yoda é acionado para decisão estrutural, tecnologia, fronteira ou regra de governança.
- Se durante a execução surgir comportamento de produto, risco não coberto ou decisão estrutural, a via rápida para e a mudança retorna ao fluxo completo.

### Fluxo completo: feature ou mudança estrutural

```
roadmap → épico → PRD → RFC (quando houver deliberação) → HLD (quando estrutural) → FDD → LLD (quando reduzir ambiguidade) → task → PR → auditoria → merge → deploy
```

- **Roadmap:** direção do produto; origem de todo épico.
- **Épico:** recorte grande derivado do roadmap.
- **PRD:** o quê e o porquê, com critérios de aceite verificáveis.
- **HLD:** como o sistema se organiza — partes, fronteiras, contratos entre elas. É obrigatório quando a mudança for estrutural. **Dono: Yoda.**
- **FDD:** como cada feature funciona por dentro. É obrigatório quando houver comportamento, regra de negócio, integração, contrato público ou risco relevante. **Dono: quem implementa; revisor: Yoda.** O autor não revisa o próprio FDD (regra 4).
- **LLD:** contratos e detalhes executáveis próximos da implementação. É opcional; usar quando o FDD não reduzir ambiguidade suficiente para implementar e testar com segurança. **Dono: quem implementa; revisor: Yoda quando tocar arquitetura, fronteira ou contrato.**
- **RFC:** proposta e alternativas antes de uma decisão relevante ainda em aberto. É opcional; quando a decisão for tomada, seu registro segue a regra de ADR aplicável.
- **Task:** unidade executável derivada do PRD e do FDD, com escopo fechado.
- **Numeração de tasks:** a primeira task formal do ciclo atual é `T-001`; as seguintes avançam sequencialmente a partir dela. Não inferir a numeração por notas, arquivos ou registros históricos.
- **PR:** entrega da task, com testes e evidências anexadas.
- **Auditoria:** revisão contra PRD e regras de ferro, feita por agente diferente de quem implementou.
- **Merge:** só após auditoria aprovada e pipelines verdes.
- **Publicação e deploy:** seguem o workflow histórico restaurado; custo financeiro zero e os gates continuam obrigatórios.

**ADR é transversal:** não ocupa posição rígida na cadeia, porque uma decisão estrutural pode nascer em qualquer ponto dela — no PRD, RFC, HLD, FDD, LLD ou diante de um problema encontrado no código.

Ao validar uma implementação, lê-se a cadeia **antes** do código: PRD, RFC aplicável, HLD, FDD, LLD aplicável e só então o diff. Ler o código primeiro faz avaliar se ele é coerente consigo mesmo, em vez de coerente com o que foi decidido.

Não iniciar feature sem PRD e task correspondentes. Mudança estrutural também exige HLD; comportamento, regra de negócio, integração, contrato público ou risco relevante também exigem FDD aprovado. A exceção é a via rápida, limitada pelos critérios desta seção.

### Resumo decisório mínimo

Toda task e toda atualização semântica de `docs/continuidade.md` registra, em formato curto e factual:

- **Objetivo:** resultado e limite da mudança.
- **Decisão:** classificação da mudança, caminho escolhido e decisões aplicadas ou pendentes.
- **Evidências:** validações executadas, resultados e artefatos consultados.
- **Riscos e lacunas:** risco remanescente, `❓ LACUNA`, bloqueio ou "nenhum identificado" com base observada.
- **Próximo passo:** ação concreta, dono e condição de continuidade ou conclusão.

O resumo não substitui PRD, HLD, FDD ou ADR. Ele evita depender de histórico de chat e não pode declarar validação que não foi executada.

### Conflito entre regras de ferro

Conflito material não é resolvido por interpretação silenciosa. O agente interrompe a execução, descreve as regras e efeitos em colisão, alternativas viáveis, impacto de cada uma e qual regra seria excepcionalmente limitada, e pede ao usuário que escolha o trade-off. Até a decisão explícita, não implementa, aprova, faz merge nem declara conformidade.

### Acionamento proporcional de agentes

Todo PR recebe revisão independente de agente diferente de quem implementou. O orquestrador aciona somente as especialidades exigidas pelo risco, sem transformar agentes em etapa decorativa:

| Gatilho | Acionamento obrigatório |
|---|---|
| Decisão de tecnologia, estrutura, fronteira, contrato entre módulos ou regra de governança | Yoda; ADR quando a decisão for estrutural ou tecnológica, HLD quando houver impacto estrutural |
| Endpoint, comportamento observável, critério de aceite, fluxo, invariante ou contrato público | Ted; PRD e FDD conforme esta seção |
| Autenticação, autorização, input/output, segredo, dependência, hook, pipeline, credencial, acesso a arquivo ou outra superfície de ataque | Neo |
| Ambiente, container, deploy, rollback, observabilidade, backup/restore, capacidade ou custo de operação | Jarvis |

Yoda, Ted, Neo e Jarvis mantêm pareceres independentes dentro do próprio escopo. Nenhum é chamado apenas para confirmar o trabalho de outro; ausência de gatilho deve ser justificada na task. A auditoria geral integra os pareceres aplicáveis, sem aprovar trabalho próprio.

---

## Arquitetura e testes

### Decisões vigentes

- Este repositório é um **template agnóstico de tecnologia**. Linguagem, framework, banco de dados, provedor de hospedagem, fila, cache, storage, ferramenta de teste e análise estática não estão escolhidos.
- As únicas fundações definidas desde o início são **Git** para versionamento, **GitHub** para colaboração e automação versionada, e **Docker** para execução reprodutível. Configurações concretas permanecem `TBD` até uma ADR aprovada para a aplicação que consumir o template.
- A aplicação é um **monólito modular** com oito bounded contexts: `Identidade`, `MatriculaAcademica`, `PlanejamentoPedagogico`, `Frequencia`, `AvaliacaoDesempenho`, `Comunicacao`, `Instituicao` e `RelatoriosGovernanca`.
- O sistema escolar legado, quando usado como referência funcional ou origem de migração, é um fato histórico a ser validado no PRD e na ADR da aplicação consumidora. Vulnerabilidade do legado não é comportamento a preservar.
- A **grade** é o eixo conceitual do modelo acadêmico, sem inferir entidade, tabela, ownership ou cardinalidade ainda não aprovados.
- Storage, ambiente, CI executável, deploy e observabilidade são decisões por aplicação; devem atender custo zero, segurança e reprodutibilidade, sem pressupor fornecedor.
- DDD, SOLID e os princípios de qualidade definidos por ADR orientam a arquitetura; os gates mecânicos são escolhidos depois que a stack for decidida.
- GitHub hospeda a colaboração e pode executar automações versionadas quando a aplicação definir os workflows; nenhum workflow ou integração externa é presumido pelo template.

As decisões vigentes desta seção são explícitas neste documento. Decisões adicionais só existem quando uma aplicação consumidora as registrar; este resumo não substitui esses documentos.

**Cópia canônica e espelho.** A **base Obsidian é a cópia canônica** de ADR, PRD, HLD, FDD, LLD, RFC e das notas de responsabilidade — é o que a regra de ferro 3 determina. O repositório guarda um **espelho de leitura** em [`docs/adrs/`](adrs/), [`docs/prds/`](prds/), [`docs/hlds/`](hlds/), [`docs/fdds/`](fdds/), `docs/llds/`, `docs/rfcs/` e [`docs/roles/`](roles/), para que um agente trabalhando no código leia a decisão sem depender de acesso ao vault. A sincronização segue três regras:

1. **Pendência rastreada primeiro.** Criação, edição ou remoção é registrada imediatamente em `docs/continuidade.md`, com origem, destino, responsável e prazo máximo de 24 horas; pedido do usuário antecipa a sincronização.
2. **A base vence após conferência.** Em divergência confirmada entre as cópias, vale a base; o espelho é regenerado a partir dela, não reconciliado à mão. Antes da conferência, o registro operacional temporário não pode alegar que a base foi atualizada.
3. **A única diferença permitida é mecânica.** O espelho preserva integralmente o corpo e o frontmatter da nota e converte apenas os wikilinks: `[[nota]]` vira um link Markdown para o caminho relativo da nota, e `[[nota|Rótulo]]` preserva o rótulo nesse link, porque wikilink não resolve fora do Obsidian. O frontmatter é mantido porque carrega informação de decisão — `status` de uma ADR, sobretudo — e porque manter as cópias byte a byte iguais fora dos links torna a divergência detectável por `diff`.

A relação é inversa à das skills: skill tem definição canônica no repositório e registro na base; documento de decisão tem o canônico na base e espelho no repositório.

Pendência dentro do prazo é aceitável na auditoria quando estiver completa e rastreável. Pendência vencida bloqueia a conclusão da mudança e o início de trabalho dependente. Não existe scheduler nem automação externa para substituir essa responsabilidade.

**DDD.** O domínio é o núcleo: regras de negócio ficam isoladas de transporte, persistência e detalhes de framework. Infraestrutura depende do domínio, nunca o contrário. Contextos se comunicam por contratos explícitos, ids ou eventos, nunca importando silenciosamente entidades internas de outro contexto.

**Testes de integração — obrigatórios para todo endpoint:**

- Ferramenta: definida pela ADR de testes da aplicação, compatível com a interface ou contrato exposto.
- **Idempotentes:** rodam repetidamente, em qualquer ordem, sem depender de estado deixado por execução anterior. Cada teste cria e limpa o próprio dado.
- **Evidência obrigatória:** cada execução gera imagem e/ou vídeo, publicados como artefato do pipeline e referenciados no PR.

Endpoint sem teste de integração com evidência não passa na auditoria.

---

## CI/CD

Dois pipelines separados (regra 8), ambos em free tier (regra 5):

1. **Pipeline de review** — revisão automatizada do PR: aderência às regras de ferro, ao PRD e à arquitetura; qualidade e consistência do código.
2. **Pipeline de execução de casos de teste** — roda a suíte de testes de integração e publica as evidências definidas pela ADR de testes como artefato.

Ambos são condição de merge. Publicação e deploy continuam sujeitos à regra de custo financeiro zero e ao workflow restaurado.

---

## Adaptadores por ferramenta

| Arquivo | Ferramenta | Aponta para | Conteúdo permitido |
|---|---|---|---|
| `CLAUDE.md` | Claude Code | `docs/recursos-template.md`, depois `docs/rules.md` se habilitado | Ponteiro de onboarding + regra de idioma |
| `AGENTS.md` | Codex e demais agentes | `docs/recursos-template.md`, depois `docs/rules.md` se habilitado | Ponteiro de onboarding + regra de idioma |
| `.claude/skills/<skill>/SKILL.md` | Claude Code | `docs/skills/<skill>.md` | Frontmatter de descoberta + ponteiro |
| `.claude/agents/<agente>.md` | Claude Code | `docs/agentes/<agente>.md` | Frontmatter de despacho (`model`, `effort`, `tools`) + ponteiro |
| `.claude/hooks/onboarding-recursos-template.sh` | Claude Code | `docs/recursos-template.md` | Único hook registrado: injeta a pergunta de opt-in no `SessionStart` |
| `.codex/hooks/onboarding-recursos-template.sh` | Codex | `docs/recursos-template.md` | Único hook registrado: injeta a pergunta de opt-in no `SessionStart` |
| Hooks de sessão, guarda e continuidade restantes | Claude Code e Codex | suas definições canônicas | Versionados e validados, mas disponíveis e inativos até configuração futura autorizada pelo usuário |

Definição canônica de skill: `docs/skills/`. Fica no repositório, e não na base Obsidian, para que um agente trabalhando no código consiga lê-la sem depender de acesso à base. A base documenta que a skill existe (gatilho da regra 3); o repositório guarda a definição executável.

Ao adicionar suporte a uma nova ferramenta, cria-se **mais um adaptador ponteiro** — nunca uma cópia do conteúdo. A regra de idioma (regra 2) é repetida inline nos adaptadores de propósito. Configurar automação de ciclo de vida exige autorização explícita do usuário; a escolha conversacional não reconfigura hooks por si só.

## Catálogo de skills

Definições canônicas ficam em `docs/skills/`; adaptadores Claude ficam em `.claude/skills/`.

| Skill | Uso |
|---|---|
| `atualizar-obsidian` | Sincronizar toda mudança que acione um gatilho documental |
| `gerar-prd` | Entrevistar e gerar PRD de feature |
| `gerar-hld` | Entrevistar e gerar HLD técnico |
| `gerar-fdd` | Entrevistar e gerar FDD implementável |
| `gerar-adr` | Analisar e registrar decisão arquitetural |
| `criar-task` | Derivar task fechada do fluxo completo ou task curta da via rápida, com validações e revisão proporcionais |
| `refinar-task` | Refinar um épico, por múltiplos papéis, antes do primeiro PRD |
| `criar-migration` | Planejar migration reversível e verificável |
| `api-design` | Planejar e revisar contratos de API |
| `error-handling` | Modelar falhas, exceções e respostas |
| `tdd-workflow` | Implementar por RED, GREEN e REFACTOR |
| `deployment-patterns` | Implementar e revisar deploy já decidido |
| `security-review` | Revisar segurança de FDD, código e configuração |
| `security-scan` | Auditar agentes, hooks, skills e integrações de ferramenta |
| `auditoria` | Auditar entrega entre PR e merge |
| `mapear-codebase` | Mapear repositório existente somente por leitura |
| `auditar-dependencias` | Auditar dependências diretas somente por leitura |
| `deep-research` | Preparar briefing de Deep Research e reestruturar integralmente pesquisa já importada |

## Playbooks

Playbooks são consulta seletiva e não substituem ADR, HLD, FDD ou skill prescritiva.

| Arquivo | Gatilho |
|---|---|
| `docs/playbooks/playbook-backend.md` | Padrões de backend: idempotência, fila, fronteiras de contexto, resiliência, cache, lote, erros e anti-overengineering |
| `docs/playbooks/playbook-database.md` | Problemas de banco relacional e SQL: queries, índices, locks, pool, concorrência, isolamento, paginação e diagnóstico |
| `docs/playbooks/playbook-security.md` | Riscos de segurança: identificação, correção e checklist para injeção, autenticação, autorização, segredos, supply chain e LGPD |

## Arquivos permanentes do projeto

| Arquivo | Papel |
|---|---|
| `docs/rules.md` | Contrato canônico de governança, roles, decisões e catálogos |
| `docs/continuidade.md` | Identificação, plano, estado observado, decisões, histórico, pendências Obsidian e única região gerada |
| `docs/lib.md` | Inventário de todas as dependências, com nome, versões, finalidade e status |
| `docs/roadmap.md` | Direção, fases e prioridades do produto |
| `docs/infraestrutura.md` | Estado e operação da infraestrutura |
| `docs/agentes/` | Definições canônicas dos agentes |
| `docs/skills/` | Definições canônicas das skills |
| `docs/playbooks/` | Referências diagnósticas e decisórias por gatilho |
| `docs/adrs/` | Espelho das ADRs; cópia canônica na base Obsidian |
| `docs/rfcs/` | Espelho das RFCs; cópia canônica na base Obsidian |
| `docs/hlds/` | Espelho do HLD; cópia canônica na base Obsidian |
| `docs/fdds/` | Espelho dos FDDs; cópia canônica na base Obsidian |
| `docs/llds/` | Espelho dos LLDs; cópia canônica na base Obsidian |
| `docs/prds/` | Espelho dos PRDs; cópia canônica na base Obsidian |
| `docs/roles/` | Espelho das três responsabilidades da regra 4; cópia canônica na base Obsidian |
| `.env.example` | Contrato de configuração sem segredos; valores reais ficam fora do repositório |
| `Dockerfile` ou `Containerfile` | Contrato de execução reprodutível, quando a aplicação o exigir |
| `.github/workflows/` | Automação versionada no GitHub, definida pela aplicação consumidora |

---

## Pendências de decisão (exigem ADR antes de codar)

Ainda não definidos pelo usuário — **não assumir nenhum destes sem confirmação**. A mesma lista está em `regras-de-ferro.md`, na base Obsidian:

- Linguagem, framework, build, persistência, cache, fila, storage, frontend, provedor e topologia de execução.
- Configuração do repositório GitHub, proteção de `main`, runners e estratégia adicional de branches.
- Estratégia de imagem Docker, registry, identidade de deploy, retenção de artefatos e ambiente de publicação.
- Formato de publicação das evidências de teste como artefato.
- Fronteiras, ownership, agregados e contratos detalhados dos oito bounded contexts.
- Acesso, schema, estratégia de cutover e as propriedades técnicas de qualquer legado, quando houver.

O fato de uma tecnologia estar decidida não autoriza inventar configuração, versão ou topologia que a ADR manteve como `TBD`. Regra de negócio ausente continua sendo `❓ LACUNA`.
