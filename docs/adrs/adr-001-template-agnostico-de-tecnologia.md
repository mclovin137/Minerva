---
type: minerva-adr
project: Minerva
date: 2026-08-17
status: aceito
tags:
  - minerva
  - adr
  - governanca
  - arquitetura
ai-first: true
---

# ADR 001 — Template agnóstico de tecnologia

## Para o futuro agente

Este repositório é um template de governança e não uma aplicação com stack definida. Use esta ADR para impedir que exemplos, decisões históricas ou preferências de agentes virem escolha técnica sem decisão explícita da aplicação consumidora.

## Contexto

O template começa limpo, sem decisões anteriores de linguagem, framework, persistência, hospedagem, cache, storage, testes ou análise estática. O usuário determinou que as únicas tecnologias fixadas desde o início são Git, GitHub e Docker.

## Decisão

- Git é a fundação de versionamento e rastreabilidade.
- GitHub é a fundação de colaboração e de automações versionadas quando necessárias.
- Docker é a fundação de execução reprodutível.
- Linguagem, framework, persistência, cache, filas, storage, CI executável, testes, análise estática, registry, hospedagem, observabilidade, identidade e topologia não são definidos pelo template.
- Uma aplicação que consumir o template escolhe cada tecnologia por ADR, somente quando houver requisito que a justifique e sempre respeitando custo financeiro zero, segurança, qualidade e simplicidade.
- Referências a tecnologias no sistema legado são fatos históricos e não recomendações técnicas.

## Consequências

- Skills, agentes, roles e playbooks devem descrever capacidades e critérios, não ferramentas presumidas.
- Nenhum agente pode criar configuração, manifesto, pipeline, serviço externo ou código baseado em uma stack não aprovada.
- GitHub e Docker não autorizam por si só workflow, registry, deploy ou infraestrutura externa: a configuração concreta continua dependente de ADR e task.
- O template pode manter uma automação mínima do GitHub para validar seus próprios documentos e adaptadores, sem configurar build, testes de aplicação, imagem, registry ou deploy. Essa automação não escolhe stack para aplicações consumidoras.

## Alternativas consideradas

1. Manter uma stack padrão para acelerar scaffolds — rejeitada: contraria a finalidade de template e cria lock-in indevido.
2. Não fixar nenhuma ferramenta — rejeitada: Git, GitHub e Docker são as fundações explícitas do usuário para colaboração, rastreabilidade e reprodutibilidade.

## Histórico

- 2026-08-17 — Criada como primeira decisão do template limpo.
- 2026-08-17 — Esclarecida a permissão para uma validação mínima do próprio template no GitHub, sem antecipar pipeline de aplicação.
