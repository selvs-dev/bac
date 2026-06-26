---
priority: P1
---

<!-- BAC:FEATURE:DRAFT id=FEAT-001 -->

> 📝 **`DRAFT`** — spec em construção, ainda não pode ser implementado

# Estruturar Regras do BAC

## Contexto

O sistema BAC nasceu acoplado ao projeto `ia4.dev` e precisa ser extraído
como sistema genérico reutilizável. As convenções atuais ainda refletem
a estrutura antiga (pastas como estado), que está sendo substituída por
índices markdown (`DRAFT.md`, `BACKLOG.md`, `SPRINT-NNN.md`) com arquivos
físicos fixos em `YYYY/MM/`.

## Proposta

Reescrever o `BAC.md` e todos os templates para refletir a nova estrutura:
- Arquivos criados em `YYYY/MM/` e nunca movidos
- Estado gerenciado pelos três índices na raiz do `.bac/`
- SPRINT-NNN.md como arquivo-índice substituindo a pasta SPRINT-NN/

## Escopo

### Dentro do escopo
- Reescrever `BAC.md` com as novas convenções
- Atualizar `README.md` (bootstrap)
- Atualizar `TEMPLATE-FEATURE.md` e `TEMPLATE-BUG.md`
- Definir formato dos índices (`DRAFT.md`, `BACKLOG.md`, `SPRINT-NNN.md`)

### Fora do escopo
- Criar ferramenta CLI para automação
- Integração com GitHub Actions
- Converter projetos existentes que usam a estrutura antiga

## Critérios de aceite

- [ ] `BAC.md` descreve o fluxo de índices sem mencionar movimentação de arquivos
- [ ] Templates têm instruções de path `YYYY/MM/`
- [ ] Formato dos três índices está documentado com exemplos
- [ ] `README.md` de bootstrap está atualizado

## Como testar

Abrir uma sessão do Claude Code no repo e pedir "leia o BAC.md" —
o agente deve descrever corretamente o fluxo de índices sem mencionar
movimentação de arquivos.

## Notas / decisões

Decisão principal: pasta não representa estado. O arquivo nasce em
`YYYY/MM/` pelo mês de criação e fica lá para sempre. O que muda é
em qual índice ele aparece.
