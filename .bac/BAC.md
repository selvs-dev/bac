# BAC — Backlog-as-Code

Sistema de gestão de tarefas (Scrum/Kanban) versionado no próprio repo, em
markdown. Análogo a Infrastructure-as-Code: o estado vive no git, é revisado
em PR, e funciona offline / sem depender de GitHub Projects, Jira ou
ferramenta externa.

Este arquivo é a **única** fonte de convenções. Os arquivos de item
(`FEAT-*.md`, `BUG-*.md`, etc.) seguem o padrão definido aqui sem repetir
explicações.

---

## Estrutura de pastas

```
.bac/
├─ BAC.md                    # convenções (este arquivo)
├─ README.md                 # bootstrap pra trazer o sistema pra outro repo
├─ CONTEXT.md                # contexto do projeto (stack, arquitetura, decisões)
├─ TEAM.md                   # pessoas e agentes (@handles)
├─ TEMPLATE-FEATURE.md       # template pra criar uma FEAT
├─ TEMPLATE-BUG.md           # template pra criar um BUG
│
├─ draft/                    # itens em construção (spec não aprovado)
│  └─ FEAT-NNN-<slug>.md
│
├─ backlog/                  # itens READY aguardando sprint
│  └─ FEAT-NNN-<slug>.md
│
└─ sprint-NNN/               # uma pasta por sprint
   ├─ SPRINT.md              # metadados da sprint (objetivo, retrospectiva)
   └─ FEAT-NNN-<slug>.md     # itens da sprint
```

**A pasta é o estado.** O arquivo move de pasta para refletir sua fase:

```
criado       → draft/
READY        → sai de draft/, entra em backlog/
sprint       → sai de backlog/, entra em sprint-NNN/
```

Dentro da sprint, o status detalhado (READY → IN_PROGRESS → REVIEW → DONE)
é rastreado pela tag BAC no próprio arquivo.

---

## A tag BAC

Cada arquivo de item carrega no topo (entre o front-matter e o título) uma
marca HTML que representa o estado atual:

```html
<!-- BAC:<TYPE>:<STATUS> id=<ITEM_ID> [attr="value" ...] -->
```

A tag é invisível na renderização do `.md` — serve para grep e automação.
Logo abaixo dela, uma linha visível em blockquote espelha o estado para humanos.
**As duas precisam estar sempre alinhadas.**

### Tipos suportados

| TYPE | Filename prefix | Quando usar | Branch | Commit / PR prefix |
|------|----------------|-------------|--------|--------------------|
| `FEATURE` | `FEAT-NNN` | Funcionalidade nova ou melhoria | `feat/NNN-<slug>` | `feat(NNN):` |
| `BUG` | `BUG-NNN` | Correção de algo quebrado | `fix/NNN-<slug>` | `fix(NNN):` |
| `TASK` | `TASK-NNN` | Trabalho técnico sem ser FEAT nem BUG | `task/NNN-<slug>` | `chore(NNN):` |
| `SPIKE` | `SPIKE-NNN` | Investigação com prazo curto | `spike/NNN-<slug>` | `chore(NNN):` |
| `DOC` | `DOC-NNN` | Mudança só em documentação | `docs/NNN-<slug>` | `docs(NNN):` |
| `BLOCK` | _(inline)_ | Bloqueio interno dentro de outro item | _(não tem)_ | _(não tem)_ |

### Statuses suportados

| STATUS | Pasta | Significado |
|--------|-------|-------------|
| `DRAFT` | `draft/` | Spec em construção — não pode ser desenvolvido |
| `READY` | `backlog/` ou `sprint-NNN/` | Spec aprovado — pode ser puxado pra sprint |
| `IN_PROGRESS` | `sprint-NNN/` | Branch aberta, em desenvolvimento ativo |
| `REVIEW` | `sprint-NNN/` | PR draft aberto, esperando review |
| `BLOCKED` | `sprint-NNN/` | Travado por algo externo |
| `DONE` | `sprint-NNN/` | PR mergeado, critérios de aceite satisfeitos |
| `CANCELED` | pasta onde estava | Não vamos fazer — preservado como registro |

Pipeline típico: `DRAFT → READY → IN_PROGRESS → REVIEW → DONE`.

**`DRAFT` é o status padrão.** Ausência de tag = `DRAFT`.
**Só `READY` libera implementação.** Agente recusa qualquer outro.

### IDs

Cada tipo tem contador independente, global, sequencial e nunca reutilizado.
Ao criar um item, grep o maior `<PREFIX>-NNN` em todo `.bac/` e some 1.

### Atributos opcionais da tag

```html
<!-- BAC:FEATURE:IN_PROGRESS id=FEAT-001 owner="@claude" branch="feat/001-foo" -->
<!-- BAC:FEATURE:REVIEW id=FEAT-001 owner="@claude" branch="feat/001-foo" pr="#42" -->
<!-- BAC:FEATURE:DONE id=FEAT-001 done_at="2026-06-25" done_by="@claude" pr="#42" -->
<!-- BAC:FEATURE:CANCELED id=FEAT-001 canceled_at="2026-06-25" reason="duplicado de FEAT-005" -->
<!-- BAC:FEATURE:READY id=FEAT-001 ready_at="2026-06-25" ready_by="@selvs" -->
```

Só uma tag principal por arquivo. Ao mudar o status, **atualize a tag existente**
— não acumule várias. O histórico fica no `git log`.

### Linha de status visível

| Status | Linha visível |
|--------|---------------|
| `DRAFT` | `> 📝 **\`DRAFT\`** — spec em construção, ainda não pode ser implementado` |
| `READY` | `> 📋 **\`READY\`** — pronto pra puxar · aprovado por @selvs em 2026-06-25` |
| `IN_PROGRESS` | `> 🚧 **\`IN_PROGRESS\`** — branch \`feat/001-foo\` · @claude` |
| `REVIEW` | `> 👀 **\`REVIEW\`** — PR [#42](https://...) · @claude` |
| `BLOCKED` | `> ⛔ **\`BLOCKED\`** — esperando decisão sobre X` |
| `DONE` | `> ✅ **\`DONE\`** — PR [#42](https://...) · @claude · 2026-06-25` |
| `CANCELED` | `> 🗑️ **\`CANCELED\`** — duplicado de FEAT-005 · 2026-06-25` |

### Front-matter mínimo

```yaml
---
priority: P1     # P0 (crítico) | P1 (alta) | P2 (média) | P3 (nice-to-have)
---
```

---

## Sprint — metadados

Cada sprint tem uma pasta `sprint-NNN/` com um arquivo `SPRINT.md`:

```markdown
---
status: OPEN     # OPEN | CLOSED
---

# Sprint 001 — <nome curto / versão>

**Objetivo:** <o que este pacote entrega — resultado, não lista de tarefas>

## Retrospectiva

_(preencher ao fechar a sprint — 3 frases: bom, ruim, ajustar.)_
```

**Sprint status é explícito** no front-matter: `OPEN` (padrão) ou `CLOSED`.
A sprint não tem timebox — é um pacote de features fechado pelo usuário quando
ele decide.

---

## Blocks (bloqueios internos)

```markdown
## Blocks

### BLOCK-001 — Validar decisão X

<!-- BAC:BLOCK:OPEN id=BLOCK-001 item=FEAT-001 opened_at="2026-06-25" -->

**Motivo:** ...
**Impacto:** ...
**Responsável:** @selvs

<!-- /BAC:BLOCK -->
```

Quando resolvido, troque `OPEN` por `RESOLVED` (sem apagar o texto):

```html
<!-- BAC:BLOCK:RESOLVED id=BLOCK-001 item=FEAT-001 resolved_at="2026-06-25" resolved_by="@selvs" -->
```

---

## Buscar itens — receitas de grep

```bash
# Todos os itens no draft
ls .bac/draft/

# Todos os itens no backlog
ls .bac/backlog/

# Todos os itens de uma sprint
ls .bac/sprint-001/

# Itens IN_PROGRESS em qualquer sprint
grep -rl "BAC:.*:IN_PROGRESS" .bac/sprint-*/

# Itens em REVIEW (PR aberto)
grep -rl "BAC:.*:REVIEW" .bac/sprint-*/

# Item específico — onde está
find .bac/ -name "FEAT-001-*.md"

# Todos os P0 no backlog
grep -l "priority: P0" .bac/backlog/

# Próximo número livre de FEAT
grep -roh "id=FEAT-[0-9]*" .bac/ | grep -oP '[0-9]+' | sort -n | tail -1

# Todos os bloqueios abertos
grep -R "BAC:BLOCK:OPEN" .bac/

# Sprints abertas
grep -rl "status: OPEN" .bac/sprint-*/SPRINT.md
```

---

## Intenção do humano: criar, refinar, promover, implementar

| Fase | Frases-gatilho | O que faz | Tag final | Mexe em código? |
|------|---------------|-----------|-----------|-----------------|
| **Criar** | "abre/cria uma feature/bug/task" | Cria arquivo em `draft/`, usando o template | `DRAFT` | Não |
| **Refinar** | "adiciona X em FEAT-NNN", "complementa" | Edita o `.md` físico | `DRAFT` (não muda) | Não |
| **Promover** | "marca FEAT-NNN como READY", "spec aprovado" | Atualiza tag, move arquivo de `draft/` para `backlog/` | `READY` | Não |
| **Colocar em sprint** | "adiciona FEAT-NNN na sprint NNN" | Move arquivo de `backlog/` para `sprint-NNN/` | `READY` | Não |
| **Implementar** | "implementa FEAT-NNN" | Branch + código (só se `READY`) | `IN_PROGRESS` → `DONE` | Sim |
| **Ambíguo** | "faz uma feature de X" | **Perguntar** | — | — |

**Regras duras:**

- `DRAFT` é cíclico — spec amadurece em refinamentos. Agente nunca promove sozinho.
- Só `READY` libera implementação.
- Ausência de tag = `DRAFT` (default seguro).
- Em dúvida: refinar < criar < promover < implementar.

---

## Fluxo completo

### 1. Criar um item

1. Decidir tipo (`FEATURE`, `BUG`, `TASK`, `SPIKE`, `DOC`).
2. Próximo número livre: `grep -roh "id=FEAT-[0-9]*" .bac/ | grep -oP '[0-9]+' | sort -n | tail -1`.
3. Criar em `.bac/draft/<ID>-<slug>.md` usando o template correspondente.
4. Tag inicial: `<!-- BAC:FEATURE:DRAFT id=FEAT-NNN -->`.

### 2. Refinar (DRAFT amadurece)

1. Localizar o arquivo: `find .bac/ -name "FEAT-NNN-*.md"`.
2. Ler o arquivo inteiro (outro agente pode ter editado entre sessões).
3. Editar a seção necessária.
4. Tag permanece `DRAFT`. Não mover o arquivo.

### 3. Promover DRAFT → READY

Só com pedido explícito do humano.

1. Localizar o arquivo: `find .bac/draft/ -name "FEAT-NNN-*.md"`.
2. Atualizar a tag:
   ```html
   <!-- BAC:FEATURE:READY id=FEAT-NNN ready_at="YYYY-MM-DD" ready_by="@handle" -->
   ```
3. Atualizar a linha visível em blockquote.
4. Mover o arquivo de `draft/` para `backlog/`.

### 4. Colocar em sprint

1. Verificar se existe uma `sprint-NNN/` com `SPRINT.md` com `status: OPEN`.
   - Se não existir → criar `sprint-NNN/` (próximo número sequencial) com
     `SPRINT.md` e pedir ao usuário um nome/objetivo para a sprint.
2. Mover o arquivo de `backlog/` para `sprint-NNN/`.
3. Tag do item permanece `READY`.

### 5. Implementar

Só quando o humano pedir explicitamente e o item estiver `READY`.

1. Confirmar tag `READY` no arquivo físico (em `sprint-NNN/`).
2. Criar branch: `feat/NNN-<slug>` a partir de `develop`.
3. Atualizar tag para `IN_PROGRESS` + atualizar linha visível.
4. Implementar respeitando escopo e critérios de aceite.
5. Abrir PR draft. Atualizar tag para `REVIEW`, adicionar `pr="#NN"`.
6. Após merge: tag `DONE`.

### 6. Fechar uma sprint

Só com pedido explícito do usuário ("fecha a sprint", "encerra a sprint NNN").

1. Atualizar `status: CLOSED` no front-matter do `sprint-NNN/SPRINT.md`.
2. Preencher `## Retrospectiva`.
3. Itens não-DONE: mover arquivo de volta para `backlog/` ou diretamente
   para a próxima `sprint-NNN/`.
4. Itens `DONE`/`CANCELED` ficam em `sprint-NNN/` como registro permanente.

---

## Por que markdown + pastas, não Issues?

- **Versionado** — histórico no `git log`, não num banco externo.
- **Offline / portátil** — funciona se mudarmos de plataforma.
- **Contexto rico pro agente** — o Claude lê o `.md` inteiro de uma vez.
- **Sem limite de itens** — pastas crescem indefinidamente sem conflitos.
- **Pasta = estado** — `ls .bac/backlog/` é o backlog; `ls .bac/sprint-001/` é o sprint board.
- **Git move** — `git mv` preserva o histórico do arquivo ao mover entre pastas.
