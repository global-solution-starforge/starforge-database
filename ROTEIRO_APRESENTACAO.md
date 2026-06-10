# StarForge — Roteiro de Apresentação

Divisão de fala por integrante (versão rebalanceada). A apresentação tem **24 slides**.
Tempo-alvo total: **~30 min** + perguntas. Cada slide do `.pptx` já contém estas falas nas **notas do apresentador**.

## Divisão geral

| Integrante | Slides | Tema | Tempo aprox. |
|---|---|---|---|
| **Duarte** | 1–5 | Abertura, problema, solução e modelagem | ~5 min |
| **Anna** | 6–10 | Telas do front-end × tabelas | ~5 min |
| **Tiago** | 11–14 | Introdução dos blocos anônimos + blocos 1 a 3 | ~8 min |
| **Gustavo** | 15 | Bloco anônimo 4 | ~2 min |
| **Duarte** | 16–17 | Blocos anônimos 5 e 6 | ~4 min |
| **Gustavo** | 18–21 | Introdução dos relatórios + relatórios 1 a 3 | ~6 min |
| **Anna** | 22–23 | Relatórios 4 e 5 | ~3 min |
| **Gustavo** | 24 | Conclusão | ~1 min |

> **Rebalanceamento aplicado:** o **Bloco 4** e a **Conclusão** passaram para o **Gustavo**. Assim o Tiago não acumula os dois blocos mais densos (1 e 2) somados ao 4, e o Bloco 4 ("status por fases") emenda tematicamente com o Relatório 3 ("progresso das fases"), ambos do Gustavo. Carga final aproximada: Duarte ~9 min · Anna ~8 min · Tiago ~8 min · Gustavo ~9 min.

---

## Duarte — Abertura e modelagem (slides 1–5)

Parte de contexto; falar de forma fluida, sem se prender a cada detalhe.

- **Slide 1 — Título:** abrir, apresentar o grupo e dar o pitch em uma frase: plataforma de financiamento colaborativo e gestão de missões espaciais.
- **Slide 2 — Roteiro:** as 5 etapas da apresentação.
- **Slide 3 — Problema:** as quatro dores — capital disperso, falta de transparência, engajamento sem retorno e decisão sem dados.
- **Slide 4 — Solução:** o fluxo (financiar → gerir por fases → pagamentos/reembolsos automáticos → indicadores) e as três entregas (engajamento, transparência, inteligência operacional).
- **Slide 5 — Modelagem:** as 9 tabelas com IDs UUID; **TB_MISSAO** e **TB_CONTRIBUICAO** como núcleos; mencionar que CONTRIBUICAO liga usuário/missão/tier, que NAVE pertence a uma missão e que HANGAR liga nave a contribuição. Passar a palavra para a Anna.

## Anna — Telas do front-end × tabelas (slides 6–10)

Parte de contexto; a ideia central é "cada tela consome tabelas e colunas específicas". Não precisa esgotar cada coluna.

- **Slide 6 — Missões Ativas:** feed personalizado (USUARIO, MISSAO, TIER, CONTRIBUICAO).
- **Slide 7 — Contribuir:** financiamento coletivo; o botão "Apoiar" insere uma contribuição.
- **Slide 8 — Hangar:** onde a contribuição vira nave desbloqueada (HANGAR, NAVE, CONTRIBUICAO).
- **Slide 9 — Impacto:** telemetria e progresso por fase (MISSAO, FASE_MISSAO).
- **Slide 10 — Piloto:** perfil, conta e total contribuído (USUARIO, TIER, CONTRIBUICAO). Fechar dizendo que as cinco telas exercitam as nove tabelas e passar para o Tiago.

---

## Tiago — Blocos anônimos: introdução + blocos 1 a 3 (slides 11–14)

Esta é a parte técnica principal. Vale explicar bem o que cada bloco faz.

- **Slide 11 — Introdução:** seis blocos anônimos em PL/SQL simulam regras reais. Padrão comum a todos: variáveis declaradas com `%TYPE`, validações, **exceções tratadas** com mensagem via `DBMS_OUTPUT`, e **COMMIT/ROLLBACK** para garantir a integridade da transação.
  - **Falar sobre cursores:** *"Poderíamos ter usado **cursor explícito** (`CURSOR ... IS` com `OPEN`/`FETCH`/`CLOSE`), mas como o trabalho não exigia, optamos por **simplificar** usando **cursores implícitos** — os laços `FOR ... IN (SELECT ...)` e os `SELECT ... INTO`, em que o Oracle abre, busca e fecha o cursor automaticamente."*

### Bloco 1 — Cadastro + 1ª contribuição (slide 12)
Cadastra um novo apoiador e registra a contribuição inicial dele.
- Verifica se o e-mail já existe (`COUNT` em `TB_USUARIO`); se existir, levanta exceção própria.
- Busca o tier `APOIADOR` e uma missão com status `ATIVA`.
- `INSERT` em `TB_USUARIO` (status `ATIVO`) e em `TB_CONTRIBUICAO` (status `PENDENTE`, método `PIX`).
- Inicia a primeira fase `AGUARDANDO` da missão, marcando-a como `EM ANDAMENTO`.
- **Cursor implícito:** o laço `FOR fase IN (SELECT ...)` que percorre as fases.
- **Exceções:** e-mail duplicado, `NO_DATA_FOUND` (missão/tier inexistente), `DUP_VAL_ON_INDEX`.

### Bloco 2 — Confirmação de pagamento + desbloqueio de nave (slide 13)
Confirma um pagamento pendente e libera a nave no hangar quando o apoiador é COMANDANTE.
- Lê a contribuição com `JOIN` em usuário e tier; bloqueia confirmação se já estiver `REEMBOLSADO`.
- Atualiza o status para `CONFIRMADO`.
- Se `tier = COMANDANTE` e `valor ≥ 500`: `INSERT` ou `UPDATE` em `TB_HANGAR` com status `DESBLOQUEADA`.
- Avança `+5%` (`LEAST(100, ...)`) nas fases `EM ANDAMENTO` da missão.
- Remove hangares `PENDENTE` ligados a contribuições reembolsadas.
- **Cursor implícito:** o laço `FOR fase IN (SELECT ...)` que avança as fases `EM ANDAMENTO`.
- **Exceções:** pagamento inválido (reembolsado), `NO_DATA_FOUND`, `TOO_MANY_ROWS`.

### Bloco 3 — Reembolso de missão com falha (slide 14)
Processa reembolsos de uma missão que falhou.
- Só prossegue se o status da missão for `FALHOU`; caso contrário, exceção própria.
- Percorre as contribuições da missão e, para cada uma não reembolsada, atualiza para `REEMBOLSADO`.
- `DELETE` nos hangares `PENDENTE` vinculados a essas contribuições reembolsadas.
- Informa quantas contribuições foram processadas.
- **Cursor implícito:** o laço `FOR contribuicao IN (SELECT ...)` que percorre as contribuições.
- **Exceções:** missão não falhou, `NO_DATA_FOUND`. Passar a palavra para o Gustavo.

## Gustavo — Bloco anônimo 4 (slide 15)

### Bloco 4 — Atualização de status por fases (slide 15)
Recalcula o status da missão a partir do andamento das fases.
- Calcula a média de `PCT_FASE_MISSAO`: média `100` → `CONCLUIDA`; `≥ 20` → `ATIVA`; senão → `CRIACAO`.
- Marca como `CONCLUIDO` todas as fases que estão em 100%.
- Atualiza o `STT_MISSAO` para o novo status.
- Faz limpeza: remove contribuições `PENDENTE` com mais de 180 dias.
- **Cursor implícito:** o laço `FOR fase IN (SELECT ...)` que marca as fases concluídas. (Reforçar, se quiser: daria para usar cursor explícito, mas simplificamos.)
- **Exceções:** missão sem fases cadastradas, `NO_DATA_FOUND`. Devolver a palavra ao Duarte.

## Duarte — Blocos anônimos 5 e 6 (slides 16–17)

### Bloco 5 — Revisão cadastral de usuário (slide 16)
Inativa usuários inativos de fato e limpa pendências.
- Conta contribuições `CONFIRMADO` e `PENDENTE` do usuário.
- Se não houver nenhuma confirmada e ele estiver `ATIVO`, atualiza para `INATIVO`.
- Laço `WHILE` remove as contribuições pendentes uma a uma até zerar.
- **Cursor implícito:** apenas via `SELECT ... INTO` (linha única); não há laço `FOR` sobre consulta aqui.
- **Exceção:** usuário ativo com contribuições confirmadas não pode ser inativado.

### Bloco 6 — Promoção automática de tier (slide 17)
Ajusta o tier de uma contribuição conforme o valor.
- `CASE` no valor: `≥ 500` → `COMANDANTE`; `≥ 150` → `OPERATIVO`; senão → `APOIADOR`.
- Atualiza a FK `TB_TIER_ID_TIER` da contribuição se o tier mudou.
- **Cursor implícito:** apenas via `SELECT ... INTO` (linha única); o `LOOP` usado é um contador simples, não um cursor.
- **Exceção:** contribuição `REEMBOLSADO` não pode ser promovida. Passar para o Gustavo.

---

## Gustavo — Relatórios: introdução + relatórios 1 a 3 (slides 18–21)

Camada de inteligência operacional. Explicar o que cada consulta responde.

- **Slide 18 — Introdução:** os cinco relatórios usam `JOIN`s, agregações e filtros por status; cada um responde uma pergunta de negócio.

### Relatório 1 — Arrecadação por missão (slide 19)
- `JOIN` de `TB_MISSAO`, `TB_AGENCIA` e `TB_ORGANIZACAO`, `LEFT JOIN` com contribuições.
- Soma apenas o que está `CONFIRMADO` e calcula o **percentual da meta** (valor confirmado ÷ `VL_META_MISSAO`).
- Ordena pelo maior valor arrecadado. **Pergunta:** quais missões mais captaram.

### Relatório 2 — Ticket por tier (slide 20)
- Agrupa por tier: total de contribuições, valor total, **ticket médio**, mínimo e máximo.
- **Pergunta:** qual faixa de apoiador gera mais receita.

### Relatório 3 — Progresso das fases por missão (slide 21)
- Conta as fases, calcula o **progresso médio** (`AVG(PCT_FASE_MISSAO)`) e quantas estão concluídas, em andamento e aguardando.
- É o espelho da tela de Impacto. **Pergunta:** quão avançada está cada missão. Passar para a Anna.

## Anna — Relatórios 4 e 5 (slides 22–23)

### Relatório 4 — Hangar: naves desbloqueadas (slide 22)
- Encadeia `TB_HANGAR → TB_NAVE → TB_MISSAO → TB_CONTRIBUICAO → TB_USUARIO`.
- Lista naves desbloqueadas, status, data de desbloqueio e o **comandante** (usuário) que a desbloqueou, com o valor contribuído. **Pergunta:** quem desbloqueou o quê.

### Relatório 5 — Desempenho por agência (slide 23)
- Por agência: total de missões, total de contribuições, valor total, **valor confirmado** e ticket médio.
- Usa `LEFT JOIN` para incluir agências mesmo sem contribuição; ranqueia pelo valor confirmado. **Pergunta:** quais agências performam melhor. Passar para o Gustavo fechar.

## Gustavo — Conclusão (slide 24)

- Amarrar a mensagem: o StarForge une **engajamento, transparência e inteligência operacional**.
- Resumo do que sustenta a solução: **9 tabelas**, **6 blocos anônimos** em PL/SQL com exceções tratadas e **5 relatórios** de decisão.
- Agradecer e abrir para perguntas.

---

## Dicas rápidas
- As falas completas estão nas **notas do apresentador** de cada slide (modo apresentador do PowerPoint/Keynote/Google Slides).
- Nos slides de código (blocos 1–6 e relatórios 1–5), use a **numeração de linha** para apontar trechos ("na linha 22, tratamos a exceção…").
- Ensaiar as transições marcadas em cada nota — elas indicam quem assume a fala em seguida.
