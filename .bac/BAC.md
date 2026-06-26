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
├─ DRAFT.md                  # índice — itens em construção (spec não aprovado)
├─ BACKLOG.md                # índice — itens READY aguardando sprint
├─ SPRINT-NNN.md             # índice — itens de uma sprint (um arquivo por sprint)
│
└─ YYYY/MM/                  # arquivos físicos dos itens — nunca movidos
   └─ FEAT-NNN-<slug>.md
```

**Princípio fundamental: o arquivo físico nunca muda de pasta.**

O item é criado em `YYYY/MM/` pelo mês de criação e fica lá para sempre.
O que evolui é a referência nos índices:

```
criado  → aparece em DRAFT.md
READY   → sai de DRAFT.md, entra em BACKLOG.md
sprint  → sai de BACKLOG.md, entra em SPRINT-NNN.md
```

Os índices são a visão de estado; a pasta é apenas organização por data.

---

## Os três índices

Cada entrada nos índices tem **duas linhas paired**: uma tag HTML invisível
(grepp-ável por máquina) e uma linha visível (legível por humano). Mesmo
padrão dos arquivos de item — consistência total.

```
<!-- BAC-IDX id=FEAT-001 priority=P1 status=READY file=./2026/06/FEAT-001-slug.md -->
**FEAT-001** [Título da feature](./2026/06/FEAT-001-slug.md) · P1
```

A tag `BAC-IDX` é invisível na renderização do `.md` e carrega os campos
estruturados. A linha visível espelha os dados para humanos. **Sempre alinhadas.**

### DRAFT.md

```markdown
<!-- BAC-IDX id=FEAT-001 priority=P1 file=./2026/06/FEAT-001-slug.md -->
**FEAT-001** [Título da feature](./2026/06/FEAT-001-slug.md) · P1
```

### BACKLOG.md

```markdown
<!-- BAC-IDX id=FEAT-001 priority=P1 ready_at=2026-06-25 file=./2026/06/FEAT-001-slug.md -->
**FEAT-001** [Título da feature](./2026/06/FEAT-001-slug.md) · P1 · ready 2026-06-25
```

### SPRINT-NNN.md

Um arquivo por sprint. Front-matter com `status`, objetivo e lista de itens.

```markdown
---
status: OPEN     # OPEN | CLOSED
---

# Sprint 001 — <nome curto / versão>

**Objetivo:** <o que este pacote entrega — resultado, não lista de tarefas>

## Itens

<!-- BAC-IDX id=FEAT-001 status=IN_PROGRESS owner=@claude branch=feat/001-slug file=./2026/06/FEAT-001-slug.md -->
**FEAT-001** [Título](./2026/06/FEAT-001-slug.md) · 🚧 IN_PROGRESS · @claude · `feat/001-slug`

## Retrospectiva

_(preencher ao fechar a sprint)_
```

**Sprint status é explícito** no front-matter: `OPEN` (padrão) ou `CLOSED`.
A sprint não tem timebox — é um pacote de features fechado pelo usuário quando
ele decide. O campo `status: CLOSED` é atualizado manualmente ao encerrar.

#### Atributos da tag `BAC-IDX` por índice

O tipo é derivado do prefixo do ID (`FEAT-`, `BUG-`, `TASK-`, `SPIKE-`, `DOC-`)
— não precisa de atributo `type`.

| Atributo | DRAFT | BACKLOG | SPRINT |
|----------|-------|---------|--------|
| `id` | ✓ | ✓ | ✓ |
| `priority` | ✓ | ✓ | — |
| `ready_at` | — | ✓ | — |
| `status` | — | — | ✓ |
| `owner` | — | — | ✓ (quando IN_PROGRESS+) |
| `branch` | — | — | ✓ (quando IN_PROGRESS+) |
| `pr` | — | — | ✓ (quando REVIEW+) |
| `file` | ✓ | ✓ | ✓ |

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

| STATUS | Significado |
|--------|-------------|
| `DRAFT` | Spec em construção — não pode ser desenvolvido |
| `READY` | Spec aprovado — pode ser puxado pra sprint |
| `IN_PROGRESS` | Branch aberta, em desenvolvimento ativo |
| `REVIEW` | PR draft aberto, esperando review |
| `BLOCKED` | Travado por algo externo |
| `DONE` | PR mergeado, critérios de aceite satisfeitos |
| `CANCELED` | Não vamos fazer — preservado como registro |

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

Os índices (`DRAFT.md`, `BACKLOG.md`, `SPRINT-NNN.md`) usam a tag `BAC-IDX`
por linha — grepp-áveis direto, sem parser de tabela.

```bash
# Todos os itens no DRAFT
grep "BAC-IDX" .bac/DRAFT.md

# Todos os itens no backlog
grep "BAC-IDX" .bac/BACKLOG.md

# Todos os itens de uma sprint
grep "BAC-IDX" .bac/SPRINT-001.md

# Itens IN_PROGRESS em qualquer sprint
grep -h "BAC-IDX.*status=IN_PROGRESS" .bac/SPRINT-*.md

# Itens em REVIEW (PR aberto)
grep -h "BAC-IDX.*status=REVIEW" .bac/SPRINT-*.md

# Item específico — onde está
grep -r "BAC-IDX.*id=FEAT-001" .bac/

# Todos os P0 no backlog
grep "BAC-IDX.*priority=P0" .bac/BACKLOG.md

# Extrair só os IDs do backlog (para scripts)
grep "BAC-IDX" .bac/BACKLOG.md | grep -oP 'id=\S+' | sed 's/id=//'

# Extrair file path de um item (para abrir direto)
grep "BAC-IDX.*id=FEAT-001" .bac/DRAFT.md | grep -oP 'file=\S+' | sed 's/file=//'

# Próximo número livre de FEAT
grep -roh "id=FEAT-[0-9]*" .bac/ | grep -oP '[0-9]+' | sort -n | tail -1

# Todos os bloqueios abertos (nos arquivos físicos)
grep -R "BAC:BLOCK:OPEN" .bac/

# Sprints abertas
grep -l "status: OPEN" .bac/SPRINT-*.md
```

---

## Intenção do humano: criar, refinar, promover, implementar

| Fase | Frases-gatilho | O que faz | Tag final | Mexe em código? |
|------|---------------|-----------|-----------|-----------------|
| **Criar** | "abre/cria uma feature/bug/task" | Cria arquivo em `YYYY/MM/`, adiciona em `DRAFT.md` | `DRAFT` | Não |
| **Refinar** | "adiciona X em FEAT-NNN", "complementa" | Edita o `.md` físico | `DRAFT` (não muda) | Não |
| **Promover** | "marca FEAT-NNN como READY", "spec aprovado" | Atualiza tag, move referência de `DRAFT.md` para `BACKLOG.md` | `READY` | Não |
| **Colocar em sprint** | "adiciona FEAT-NNN na sprint NNN" | Move referência de `BACKLOG.md` para `SPRINT-NNN.md` | `READY` | Não |
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
2. Próximo número livre: `grep -Roh "id=FEAT-[0-9]*" .bac/ | sort -t- -k2 -n | tail -1`.
3. Criar em `.bac/YYYY/MM/<ID>-<slug>.md` usando o template correspondente.
4. Adicionar linha na tabela do `DRAFT.md`.
5. Tag inicial: `<!-- BAC:FEATURE:DRAFT id=FEAT-NNN -->`.

### 2. Refinar (DRAFT amadurece)

1. Localizar o arquivo: `grep -Rl "id=FEAT-NNN" .bac/`.
2. Ler o arquivo inteiro (outro agente pode ter editado entre sessões).
3. Editar a seção necessária.
4. Tag permanece `DRAFT`. Não mexer nos índices.

### 3. Promover DRAFT → READY

Só com pedido explícito do humano.

1. Localizar o arquivo.
2. Atualizar a tag:
   ```html
   <!-- BAC:FEATURE:READY id=FEAT-NNN ready_at="YYYY-MM-DD" ready_by="@handle" -->
   ```
3. Atualizar a linha visível em blockquote.
4. Remover a linha do item do `DRAFT.md`.
5. Adicionar a linha do item no `BACKLOG.md`.

### 4. Colocar em sprint

1. Verificar se existe um `SPRINT-NNN.md` com `status: OPEN`.
   - Se não existir → criar `SPRINT-NNN.md` (próximo número sequencial) com
     `status: OPEN` e pedir ao usuário um nome/objetivo para a sprint.
2. Remover a linha do item do `BACKLOG.md`.
3. Adicionar a linha do item na tabela do `SPRINT-NNN.md` com status `READY`.

### 5. Implementar

Só quando o humano pedir explicitamente e o item estiver `READY`.

1. Confirmar tag `READY` no arquivo físico.
2. Criar branch: `feat/NNN-<slug>` a partir de `develop`.
3. Atualizar tag para `IN_PROGRESS` + atualizar linha visível + atualizar coluna Status no `SPRINT-NNN.md`.
4. Implementar respeitando escopo e critérios de aceite.
5. Abrir PR draft. Atualizar tag para `REVIEW`, adicionar `pr="#NN"`, atualizar `SPRINT-NNN.md`.
6. Após merge: tag `DONE`, atualizar `SPRINT-NNN.md`.

### 6. Fechar uma sprint

Só com pedido explícito do usuário ("fecha a sprint", "encerra a sprint NNN").

1. Atualizar `status: CLOSED` no front-matter do `SPRINT-NNN.md`.
2. Preencher `## Retrospectiva`.
3. Itens não-DONE: mover referência de volta para `BACKLOG.md` ou diretamente
   para o próximo `SPRINT-NNN.md`. O arquivo físico **não se move**.
4. Itens `DONE`/`CANCELED` ficam no `SPRINT-NNN.md` como registro permanente.

---

## Por que markdown + índices, não Issues?

- **Versionado** — histórico no `git log`, não num banco externo.
- **Offline / portátil** — funciona se mudarmos de plataforma.
- **Contexto rico pro agente** — o Claude lê o `.md` inteiro de uma vez.
- **Sem limite de itens** — `YYYY/MM/` cresce indefinidamente sem conflitos.
- **Arquivo nunca move** — sem histórico partido no `git log` por renomeação.
- **Índices = kanban** — `cat .bac/BACKLOG.md` é o backlog; `cat .bac/SPRINT-NNN.md` é o sprint board.
