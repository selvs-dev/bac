# .bac/ — Backlog-as-Code

Convenções, fluxo e templates: **[BAC.md](./BAC.md)**.

## Estrutura

```
.bac/
├─ BAC.md                    # convenções (fonte de verdade)
├─ README.md                 # este arquivo (bootstrap)
├─ CONFIG.yaml               # config do sistema
├─ CONTEXT.md                # contexto do projeto (stack, arquitetura, decisões)
├─ TEAM.md                   # pessoas e agentes (@handles)
├─ TEMPLATE-FEATURE.md       # template pra criar uma FEAT
├─ TEMPLATE-BUG.md           # template pra criar um BUG
│
├─ draft/                    # itens em construção (spec não aprovado)
├─ backlog/                  # itens READY aguardando sprint
└─ sprint-NNN/               # uma pasta por sprint
   ├─ SPRINT.md              # metadados: objetivo e retrospectiva
   └─ FEAT-NNN-<slug>.md     # itens da sprint
```

**A pasta é o estado.** O arquivo move entre pastas via `git mv`:

```
criado       → draft/
READY        → sai de draft/, entra em backlog/
sprint       → sai de backlog/, entra em sprint-NNN/
```

Dentro da sprint, o status detalhado (READY → IN_PROGRESS → REVIEW → DONE)
fica na tag BAC dentro do próprio arquivo.

---

## Bootstrap em um projeto novo

### 1. Copiar a pasta `.bac/`

Copie a pasta inteira pro novo repo. Antes de commitar, limpe o que era
específico do projeto anterior:

- Esvazie `draft/`, `backlog/` e as pastas `sprint-NNN/` (exceto `SPRINT.md`).
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

- [`.bac/draft/`](./.bac/draft/) — itens em construção
- [`.bac/backlog/`](./.bac/backlog/) — itens prontos pra sprint
- [`.bac/sprint-NNN/`](./.bac/) — pasta da sprint corrente
- [`.bac/TEAM.md`](./.bac/TEAM.md) — pessoas e agentes

## Regras absolutas

- **PR draft sempre.** Nunca mergeie sem aprovação humana.
- **Nunca pushe direto** em `main` ou `develop`.
- **Só `READY` libera implementação.** `DRAFT` ou ausência de tag → recuse.
- **A pasta é o estado.** Mover o arquivo = mudar de fase.
- **Se o spec estiver ambíguo**, pergunte antes de implementar.

## Desenvolvimento local

<COMANDOS_PRA_RODAR_LOCALMENTE>
~~~

### 4. Verificar

- Commitar tudo: `.bac/` + `AGENTS.md` + `CLAUDE.md` + `.github/copilot-instructions.md`.
- Abrir uma sessão do Claude Code e pedir "leia o AGENTS.md" — deve confirmar
  o fluxo BAC (pastas como estado) sem você explicar nada.
