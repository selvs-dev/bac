# .bac/ — Backlog-as-Code

Convenções, fluxo e templates: **[BAC.md](./BAC.md)**.

## Estrutura

```
.bac/
├─ BAC.md                    # convenções (fonte de verdade)
├─ README.md                 # este arquivo (bootstrap)
├─ CONFIG.yaml               # config do sistema (duração default de sprint, etc.)
├─ CONTEXT.md                # contexto do projeto (stack, arquitetura, decisões)
├─ TEAM.md                   # pessoas e agentes (@handles)
├─ TEMPLATE-FEATURE.md       # template pra criar uma FEAT
├─ TEMPLATE-BUG.md           # template pra criar um BUG
│
├─ DRAFT.md                  # índice — itens em construção (spec não aprovado)
├─ BACKLOG.md                # índice — itens READY aguardando sprint
├─ SPRINT-NNN.md             # índice — itens de uma sprint (um arquivo por sprint)
│
└─ YYYY/MM/                  # arquivos físicos — criados aqui, nunca movidos
   └─ FEAT-NNN-<slug>.md
```

**O arquivo nunca muda de pasta.** A transição de estado muda apenas em qual
índice o item aparece:

```
criado  → DRAFT.md
READY   → sai de DRAFT.md, entra em BACKLOG.md
sprint  → sai de BACKLOG.md, entra em SPRINT-NNN.md
```

Sprint status é explícito no front-matter do `SPRINT-NNN.md`:

```yaml
---
status: OPEN     # OPEN | CLOSED
---
```

Sprint não tem timebox — é um pacote de features fechado pelo usuário quando ele decide.
`OPEN` é o padrão; `CLOSED` é atualizado manualmente ao encerrar.

---

## Bootstrap em um projeto novo

### 1. Copiar a pasta `.bac/`

Copie a pasta inteira pro novo repo. Antes de commitar, limpe o que era
específico do projeto anterior:

- Apague tudo dentro de `.bac/YYYY/MM/` (os itens antigos).
- Esvazie as tabelas de `DRAFT.md` e `BACKLOG.md` (mantendo o cabeçalho).
- Apague os `SPRINT-NNN.md` existentes (ou use como template para o primeiro).
- Mantenha intactos: `BAC.md`, `README.md`, `TEAM.md`, `CONFIG.yaml`,
  `TEMPLATE-FEATURE.md`, `TEMPLATE-BUG.md`.

### 2. Ajustar `CONTEXT.md` e `TEAM.md`

- `CONTEXT.md` — descreva o novo projeto (stack, arquitetura, fluxos).
- `TEAM.md` — atualize com as pessoas do novo projeto.

### 3. Criar os arquivos de instruções na raiz do repo

| Arquivo | Quem auto-carrega |
|---------|------------------|
| `AGENTS.md` (raiz) | convenção comunitária |
| `CLAUDE.md` (raiz) | Claude Code |
| `.github/copilot-instructions.md` | GitHub Copilot |

#### Template: `CLAUDE.md` (raiz)

~~~markdown
# CLAUDE.md

Este repositório usa [`AGENTS.md`](./AGENTS.md) como fonte canônica das
instruções pra agentes de IA. **Leia AGENTS.md primeiro.**
~~~

#### Template: `AGENTS.md` (raiz)

~~~markdown
# AGENTS.md — Instruções para agentes de IA

**Você é um agente lendo isto?** Comece por aqui. Depois leia
[`.bac/BAC.md`](./.bac/BAC.md) (sistema de tarefas) e
[`.bac/CONTEXT.md`](./.bac/CONTEXT.md) (contexto do projeto).

---

## Sobre o projeto

<DESCRIÇÃO_DO_PROJETO>

## Branches e ambientes

| Branch | Ambiente | URL |
|--------|----------|-----|
| `develop` | dev | `dev.<domínio>` |
| `main` | prod | `<domínio>` |

Toda implementação em branch própria (`feat/NNN-<slug>` ou `fix/NNN-<slug>`),
com PR draft de volta pra `develop`. Nunca push direto.

## Sistema de tarefas: Backlog-as-Code

Toda tarefa vive como markdown em [`.bac/`](./.bac/). Leia
[`.bac/BAC.md`](./.bac/BAC.md) antes de qualquer implementação.

- [`.bac/DRAFT.md`](./.bac/DRAFT.md) — itens em construção
- [`.bac/BACKLOG.md`](./.bac/BACKLOG.md) — itens prontos pra sprint
- [`.bac/SPRINT-NNN.md`](./.bac/) — itens da sprint corrente
- [`.bac/TEAM.md`](./.bac/TEAM.md) — pessoas e agentes

## Regras absolutas

- **PR draft sempre.** Nunca mergeie sem aprovação humana.
- **Nunca pushe direto** em `main` ou `develop`.
- **Só `READY` libera implementação.** `DRAFT` ou ausência de tag → recuse.
- **Arquivo físico nunca move.** Estado muda nos índices, não na pasta.
- **Se o spec estiver ambíguo**, pergunte antes de implementar.

## Desenvolvimento local

<COMANDOS_PRA_RODAR_LOCALMENTE>
~~~

### 4. Verificar

- Commitar tudo: `.bac/` + `AGENTS.md` + `CLAUDE.md` + `.github/copilot-instructions.md`.
- Abrir uma sessão do Claude Code e pedir "leia o AGENTS.md" — deve confirmar
  o fluxo BAC (índices, nunca mover arquivos) sem você explicar nada.
