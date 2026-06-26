# Team

Pessoas e agentes que podem ser donos de uma FEAT. Cada entrada tem um
**handle** (`@...`) usado nas linhas do kanban dos `SPRINT-NN.md`.

Exemplo de uso:

```markdown
- [FEAT-001-claude-md](./FEAT-001-claude-md.md) — @claude
- [FEAT-002-restrict-iam-role](./FEAT-002-restrict-iam-role.md) — @selvs @claude
```

Mais de um handle por linha é permitido (par / handoff).

---

## Humanos

### @selvs

- **Nome:** Selvino (Selvs) Rodrigues Jr.
- **Email:** _<preencher>_
- **GitHub:** [@byselvs](https://github.com/byselvs)
- **Função:** Owner do projeto, decisão final sobre escopo e merge

---

## Agentes de IA

Agentes não têm email — interação é via PR, comentário ou tool call.

### @claude

- **Nome:** Claude (Anthropic)
- **Tipo:** AI agent
- **Acesso:** Claude Code (CLI, web, IDE extensions)
- **Modelo padrão:** Claude Opus / Sonnet, conforme o uso
- **Permissões:** abrir branch, commit, push, abrir PR draft;
  **nunca** mergeia sem aprovação humana

### @copilot

- **Nome:** GitHub Copilot
- **Tipo:** AI agent
- **Acesso:** via MCP do GitHub (`create_pull_request_with_copilot`)
- **Permissões:** delegação de tarefas via PR criada pelo Copilot;
  o Copilot trabalha em background e abre PR quando termina
