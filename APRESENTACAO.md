
## Duarte — Abertura e modelagem · slides 1–5 (~5 min)

- 1 · Título: abre a apresentação, diz o nome e o pitch de uma frase ("plataforma de financiamento e gestão de missões espaciais").
- 2 · Roteiro: apresenta as 5 etapas do que virá.
- 3 · Problema: as 4 dores — capital disperso, falta de transparência, engajamento sem retorno, decisão sem dados.
- 4 · Solução: o fluxo (apoiador financia → agência gere → pagamentos/reembolsos automáticos → vira indicador) e as 3 entregas.
- 5 · Modelagem: as 9 tabelas, com Missão e Contribuição como núcleos; UUIDs (VARCHAR2 36); destacar que TB_CONTRIBUICAO liga usuário/missão/tier e TB_HANGAR liga nave à contribuição.


---
---

## Anna — Telas × Tabelas · slides 6–10 (~5 min)

- Explica a lógica geral: cada tela consome tabelas/colunas específicas. Percorre Missões Ativas, Contribuir, Hangar, Impacto, Piloto.
- Pontos de ouro para citar: a barra de financiamento = Σ TB_CONTRIBUICAO.VL_CONTRIBUICAO / TB_MISSAO.VL_META_MISSAO; o selo de acesso = TB_TIER; o "Total contribuído" e o tier no Piloto.

---
---

## Tiago — Blocos anônimos (intro + 1 a 4) · slides 11–11 (~10 min)

- 11 · Intro: 6 blocos simulam regras reais em PL/SQL, todos com tratamento de exceções e transação (COMMIT/ROLLBACK).
- 12 · Bloco 1: cadastro + 1ª contribuição (INSERTs em USUARIO e CONTRIBUICAO; exceção de e-mail duplicado).
- 13 · Bloco 2: confirma pagamento e desbloqueia a nave no hangar quando o tier é COMANDANTE.
- 14 · Bloco 3: reembolso de missão FALHOU (loop nas contribuições; exceção se status ≠ FALHOU).

---
---

## Gustavo — Bloco 4 · slide 24 (~1 min)

- 15 · Bloco 4: recalcula o status da missão pelo % médio das fases.

---
---

## Duarte — Blocos 5 e 6 · slides 16–17 (~4 min)

- 16 · Bloco 5: revisão cadastral — inativa usuário sem contribuições confirmadas; WHILE limpa pendências.
- 17 · Bloco 6: promoção automática de tier (CASE por valor da contribuição).

---
---

## Gustavo — Relatórios (intro + 1 a 3) · slides 18–21 (~5 min)

- 18 · Intro: os 5 relatórios = inteligência operacional.
- 19 · Rel 1: arrecadação confirmada por missão e % da meta.
- 20 · Rel 2: ticket médio por tier.
- 21 · Rel 3: progresso das fases por missão.

---
---

## Anna — Relatórios 4 e 5 · slides 22–23 (~3 min)

- 22 · Rel 4: hangar — naves desbloqueadas e seus comandantes.
- 23 · Rel 5: desempenho por agência.

---
--- 

## Gustavo — Encerramento · slide 24 (~1 min)
- 24 . Encerramento: agradecimento e frasezinha de efeito