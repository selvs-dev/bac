# CONTEXT.md — Contexto do Projeto

> **Fonte canônica de contexto.** Este arquivo descreve o que o projeto é,
> como está estruturado, quais decisões foram tomadas e por quê.
> Agentes de IA devem ler este arquivo antes de qualquer trabalho no repo.
> Mantenha-o atualizado conforme o projeto evolui.

---

## O que é o `<NOME_DO_PROJETO>`

<DESCRIÇÃO EM 1-2 PARÁGRAFOS: o que o produto faz, para quem, qual o modelo de negócio ou objetivo principal.>

---

## Arquitetura geral

### Repositórios relacionados

| Repo | Função |
|------|--------|
| `<org>/<repo>` | **Este repo** — <função> |
| `<org>/<repo>` | <função> |

### Stack técnica

- **Framework:** <ex: Next.js 15, FastAPI, Rails>
- **Estilo:** <ex: Tailwind CSS, CSS Modules>
- **Auth + DB:** <ex: Supabase, Firebase, PostgreSQL>
- **Deploy:** <ex: Vercel, AWS, Railway>
- **CI:** <ex: GitHub Actions>

### Ambientes

| Branch | Ambiente | URL |
|--------|----------|-----|
| `develop` | dev | `dev.<domínio>` |
| `main` | prod | `<domínio>` |

---

## Estrutura de rotas / módulos

```
<estrutura principal do projeto — rotas, módulos, pacotes>
```

---

## Modelo de dados

<Descrição das entidades principais, tabelas, schemas. Pode ser uma tabela, um diagrama ASCII ou prosa.>

---

## Fluxos principais

<Descreva os 2-4 fluxos mais importantes do sistema: happy path do usuário, fluxo de autenticação, fluxo de pagamento, etc.>

---

## Controle de acesso

<Como funciona autenticação e autorização no sistema.>

---

## Infra e deploy

<Como o projeto é provisionado e deployado. Secrets, variáveis de ambiente relevantes, dependências externas.>

---

## Decisões de arquitetura

| Decisão | Escolha | Alternativa descartada | Motivo |
|---------|---------|------------------------|--------|
| <tema> | <o que foi escolhido> | <o que foi descartado> | <por quê> |

---

## Pessoas e agentes

Ver [`.bac/TEAM.md`](./.bac/TEAM.md) para handles completos.

- **@<handle>** — <Nome>, <função>
- **@claude** — agente de IA (Claude Code), implementação

---

*Última atualização: <YYYY-MM-DD>*
