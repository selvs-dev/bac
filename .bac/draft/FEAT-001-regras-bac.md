---
priority: P1
---

<!-- BAC:FEATURE:DRAFT id=FEAT-001 -->

> 📝 **`DRAFT`** — spec em construção, ainda não pode ser implementado

# Estruturar Regras do BAC

## Contexto

O sistema BAC nasceu acoplado ao projeto `ia4.dev` e precisa ser extraído
como sistema genérico reutilizável. As convenções atuais usam pastas para
representar o estado do item (`draft/`, `backlog/`, `sprint-NNN/`), com
arquivos que se movem entre elas conforme o fluxo avança.

## Proposta

Reescrever o `BAC.md` e todos os templates para refletir a estrutura atual:
- Arquivos criados em `draft/` e movidos conforme o estado avança
- Estado de fase determinado pela pasta; estado detalhado pela tag BAC
- `sprint-NNN/SPRINT.md` como metadados da sprint

## Escopo

### Dentro do escopo
- Reescrever `BAC.md` com as convenções de pastas como estado
- Atualizar `README.md` (bootstrap)
- Atualizar `TEMPLATE-FEATURE.md` e `TEMPLATE-BUG.md`

### Fora do escopo
- Criar ferramenta CLI para automação
- Integração com GitHub Actions
- Converter projetos existentes que usam a estrutura antiga

## Critérios de aceite

- [ ] `BAC.md` descreve o fluxo de pastas como estado
- [ ] Templates apontam para `draft/` como destino inicial
- [ ] `README.md` de bootstrap está atualizado

## Como testar

Abrir uma sessão do Claude Code no repo e pedir "leia o BAC.md" —
o agente deve descrever corretamente o fluxo de pastas sem mencionar
arquivos de índice.

## Notas / decisões

A pasta representa o estado de fase do item. O arquivo move via `git mv`
para preservar o histórico. O status detalhado (IN_PROGRESS, REVIEW, etc.)
fica na tag BAC dentro do arquivo.
