# Pitch StarForge

## 1. Abertura

StarForge é uma plataforma gamificada de crowdfunding espacial. A proposta conecta cidadãos, empresas e instituições a missões de naves, satelites e foguetes com impacto real na Terra: monitoramento ambiental, previsão de desastres, agricultura de precisão, análise climática e infraestrutura espacial.

A ideia nasce do tema da Global Solution 2026/1: a economia espacial como nova fronteira tecnológica. O projeto transforma esse tema em uma experiência simples: o usuário escolhe uma missão, contribui financeiramente, acompanha o avanço técnico e recebe recompensas digitais, como badges, acesso antecipado e naves exclusivas no hangar.

Frase de apresentação:

> "O StarForge aproxima pessoas comuns da economia espacial, permitindo que elas financiem missões reais e acompanhem, com transparência, como cada contribuição ajuda a transformar dados orbitais em impacto na Terra."

## 2. Problema

Satélites já ajudam a monitorar clima, agronegócio, desastres naturais, conectividade e regiões remotas. Mesmo assim, a população normalmente enxerga o setor espacial como algo distante, caro e restrito a governos ou grandes empresas.

O problema que o StarForge resolve é duplo:

1. Projetos espaciais precisam de financiamento, visibilidade e engajamento.
2. Usuários querem participar de causas tecnológicas relevantes, mas precisam de confiança, transparência e recompensa clara.

## 3. Solução

O StarForge cria um fluxo de financiamento coletivo para missões espaciais. Cada missão possui uma meta financeira, prazo, agência parceira, organização responsável, fases técnicas, nave exclusiva, tiers de contribuição e histórico de pagamentos.

O banco Oracle é o núcleo da solução porque guarda:

- Quem é o usuário e qual seu papel na plataforma.
- Qual missão está disponível e qual problema da Terra ela ataca.
- Quanto foi contribuído e em qual status o pagamento está.
- Qual tier foi escolhido e quais benefícios ele libera.
- Qual nave está associada à missão.
- Qual o status do hangar do usuário.
- Qual o progresso técnico de cada fase da missão.

## 4. Jornada Do Usuário

### Passo 1 - Usuário entra na plataforma

Na jornada, o usuário cria sua conta ou acessa o sistema.

Dados usados:

| Dado | Tabela | Por que é necessário |
|---|---|---|
| Nome e e-mail | `TB_USUARIO` | Identificar o apoiador e evitar cadastro duplicado |
| Senha hash | `TB_USUARIO` | Manter autenticação segura |
| Status | `TB_USUARIO` | Permitir inativação sem perder histórico |
| Papel `ADMIN` ou `USER` | `TB_USUARIO.RL_USUARIO` | Separar usuários comuns de administradores |
| Data de cadastro | `TB_USUARIO` | Auditoria e análise de crescimento da base |

Demonstração no banco:

```sql
@blocos-anonimos/bloco_01.sql
```

O que mostrar:

- O bloco verifica se já existe usuário com o mesmo e-mail.
- Busca com `SELECT INTO` o tier `APOIADOR`.
- Busca uma missão ativa.
- Insere usuário e contribuição inicial.
- Atualiza a primeira fase aguardando da missão.
- Trata exceção quando o e-mail já existe.

Mensagem para apresentar:

> "Aqui o banco não é só armazenamento. Ele aplica regra de negócio: impede duplicidade, escolhe o tier correto, vincula o usuário a uma missão ativa e registra a primeira contribuição."

### Passo 2 - Usuário escolhe uma missão espacial

Na Home, o usuário vê missões como `AMZ-01`, `ATL-02`, `AGR-03` e outras campanhas de impacto.

Dados usados:

| Dado | Tabela | Por que é necessário |
|---|---|---|
| Código e nome da missão | `TB_MISSAO` | Exibir a campanha de forma clara |
| Descrição | `TB_MISSAO` | Explicar impacto e objetivo técnico |
| Status | `TB_MISSAO` | Mostrar se está ativa, concluída, em criação ou falhou |
| Meta financeira | `TB_MISSAO` | Calcular progresso de arrecadação |
| Agência e organização | `TB_AGENCIA`, `TB_ORGANIZACAO` | Dar credibilidade institucional |
| Órbita, carga útil e coordenadas | `TB_MISSAO` | Conectar a missão a dados técnicos reais |

Relatório de apoio:

```sql
@relatorios/relatorio_01.sql
```

O que mostrar:

- Arrecadação confirmada por missão.
- Agência e organização responsáveis.
- Percentual atingido da meta.

Mensagem para apresentar:

> "Esse relatório responde a pergunta principal do usuário: quais missões estão avançando e quanto falta para elas serem viabilizadas?"

### Passo 3 - Usuário escolhe um tier de contribuição

Depois de escolher a missão, o usuário decide quanto quer contribuir.

Dados usados:

| Dado | Tabela | Por que é necessário |
|---|---|---|
| Nome do tier | `TB_TIER` | Diferenciar APOIADOR, OPERATIVO e COMANDANTE |
| Valor mínimo | `TB_TIER` | Validar se a contribuição encaixa no tier |
| Benefícios | `TB_TIER` | Explicar recompensa para o usuário |
| Acesso antecipado | `TB_TIER` | Indicar privilégio do tier |

Relatório de apoio:

```sql
@relatorios/relatorio_02.sql
```

O que mostrar:

- Quantidade de contribuições por tier.
- Valor total por tier.
- Ticket médio, menor e maior contribuição.

Mensagem para apresentar:

> "O tier permite transformar contribuição financeira em experiência de jogo. Ele também ajuda o time a entender quais benefícios engajam mais."

### Passo 4 - Usuário contribui e o pagamento é confirmado

Uma contribuição nasce como `PENDENTE`, pode virar `CONFIRMADO` e, em caso de falha da missão, pode virar `REEMBOLSADO`.

Dados usados:

| Dado | Tabela | Por que é necessário |
|---|---|---|
| Valor | `TB_CONTRIBUICAO` | Medir arrecadação da missão |
| Método de pagamento | `TB_CONTRIBUICAO` | Registrar PIX, crédito ou débito |
| Status da contribuição | `TB_CONTRIBUICAO` | Controlar pendência, confirmação e reembolso |
| Data | `TB_CONTRIBUICAO` | Auditoria e histórico |
| Usuário, missão e tier | `TB_CONTRIBUICAO` | Amarrar quem apoiou, o que apoiou e em qual nível |

Demonstração no banco:

```sql
@blocos-anonimos/bloco_02.sql
```

O que mostrar:

- O bloco busca contribuição, usuário e tier por `JOIN`.
- Se o pagamento estiver reembolsado, aciona exceção.
- Se estiver pendente, confirma.
- Se for tier `COMANDANTE`, cria ou atualiza o hangar.
- Atualiza progresso da fase em andamento.

Mensagem para apresentar:

> "Quando o pagamento é confirmado, o banco propaga o efeito para outras áreas da jornada: a missão avança e o apoiador pode ganhar uma nave no hangar."

### Passo 5 - Sistema acompanha a execução técnica da missão

Após a arrecadação, a missão não acaba no pagamento. O usuário acompanha as fases técnicas: projeto orbital, integração do payload, testes ambientais e lançamento.

Dados usados:

| Dado | Tabela | Por que é necessário |
|---|---|---|
| Número da fase | `TB_FASE_MISSAO` | Ordenar o cronograma |
| Nome e descrição | `TB_FASE_MISSAO` | Explicar a etapa técnica |
| Status da fase | `TB_FASE_MISSAO` | Mostrar o andamento |
| Percentual | `TB_FASE_MISSAO` | Calcular progresso médio |
| Missão relacionada | `TB_FASE_MISSAO` | Vincular transparência à campanha correta |

Demonstração no banco:

```sql
@blocos-anonimos/bloco_04.sql
```

O que mostrar:

- O bloco calcula média das fases.
- Se todas estiverem em 100%, marca missão como `CONCLUIDA`.
- Se houver avanço suficiente, mantém como `ATIVA`.
- Se não houver fases, trata exceção.

Relatório de apoio:

```sql
@relatorios/relatorio_03.sql
```

Mensagem para apresentar:

> "Esse ponto mostra transparência. O usuário não vê só o dinheiro entrando; ele vê o projeto técnico evoluindo."

### Passo 6 - Usuário recebe ou acompanha a nave no hangar

O hangar é a camada gamificada da solução. Ele transforma contribuição em recompensa visual e dá sensação de progresso.

Dados usados:

| Dado | Tabela | Por que é necessário |
|---|---|---|
| Nome e classe da nave | `TB_NAVE` | Exibir a recompensa exclusiva |
| Missão da nave | `TB_NAVE` | Garantir que a nave pertence à campanha correta |
| Status do hangar | `TB_HANGAR` | Mostrar se está pendente ou desbloqueada |
| Data de desbloqueio | `TB_HANGAR` | Evidenciar quando a recompensa foi liberada |
| Nome gravado | `TB_HANGAR` | Personalizar recompensa para comandante |
| Contribuição vinculada | `TB_HANGAR` | Garantir rastreabilidade da recompensa |

Relatório de apoio:

```sql
@relatorios/relatorio_04.sql
```

Mensagem para apresentar:

> "A nave não é só um item visual. Ela é uma evidência de participação na missão, ligada ao pagamento e ao progresso da campanha."

### Passo 7 - Se uma missão falha, o sistema protege o usuário

Nem toda missão espacial é bem-sucedida. O projeto precisa demonstrar como lida com falhas.

Demonstração no banco:

```sql
@blocos-anonimos/bloco_03.sql
```

O que mostrar:

- O bloco só permite reembolso se a missão estiver com status `FALHOU`.
- Percorre as contribuições da missão.
- Atualiza contribuições para `REEMBOLSADO`.
- Remove pendências de hangar associadas a reembolso.
- Trata exceção se tentarem reembolsar uma missão que não falhou.

Mensagem para apresentar:

> "A confiança do usuário depende disso. Se a missão falha, o banco automatiza o processo de reembolso e limpa recompensas pendentes."

### Passo 8 - Administração acompanha saúde da plataforma

Administradores precisam saber quais agências performam melhor, quais missões atraem mais contribuições e quais usuários devem ser revisados.

Demonstrações no banco:

```sql
@blocos-anonimos/bloco_05.sql
@blocos-anonimos/bloco_06.sql
```

O que mostrar no bloco 05:

- Revisa usuário sem contribuição confirmada.
- Inativa usuário quando não há engajamento válido.
- Remove pendências antigas.
- Trata exceção quando usuário ativo possui contribuição confirmada.

O que mostrar no bloco 06:

- Recalcula o tier conforme valor contribuído.
- Usa `CASE` para decidir entre `APOIADOR`, `OPERATIVO` e `COMANDANTE`.
- Evita promoção de contribuição reembolsada.

Relatório de apoio:

```sql
@relatorios/relatorio_05.sql
```

Mensagem para apresentar:

> "A camada administrativa mostra que a solução também é sustentável como negócio. Ela ajuda a entender quais parceiros e campanhas geram mais impacto."

## 5. Como Apresentar Os Arquivos Ao Vivo

Ordem recomendada:

1. `@ddl/schema.sql`
2. `@dados/carga_100_registros.sql`
3. Mostrar conferência da carga: 143 registros distribuídos entre as tabelas.
4. `@relatorios/relatorio_01.sql` para apresentar a visão geral das missões.
5. `@blocos-anonimos/bloco_01.sql` para simular novo apoiador.
6. `@blocos-anonimos/bloco_02.sql` para confirmar pagamento e atualizar hangar.
7. `@relatorios/relatorio_04.sql` para mostrar a nave no hangar.
8. `@blocos-anonimos/bloco_04.sql` e `@relatorios/relatorio_03.sql` para mostrar progresso técnico.
9. `@blocos-anonimos/bloco_03.sql` para demonstrar cenário de falha e reembolso.
10. `@relatorios/relatorio_05.sql` para fechar com visão gerencial.

Para evidenciar exceções, usar os scripts em:

```sql
@testes/blocos-anonimos/teste_bloco_01.sql
@testes/blocos-anonimos/teste_bloco_02.sql
@testes/blocos-anonimos/teste_bloco_03.sql
@testes/blocos-anonimos/teste_bloco_04.sql
@testes/blocos-anonimos/teste_bloco_05.sql
@testes/blocos-anonimos/teste_bloco_06.sql
```

## 6. Mapa Dos Blocos Anônimos No Pitch

| Bloco | Momento da jornada | Regra de negócio demonstrada | O que evidenciar |
|---|---|---|---|
| `bloco_01.sql` | Cadastro e primeira contribuição | Evita e-mail duplicado, cria usuário e registra apoio inicial | Novo usuário, contribuição pendente e exceção de duplicidade |
| `bloco_02.sql` | Confirmação de pagamento | Confirma contribuição e desbloqueia/atualiza hangar para comandante | Status confirmado, hangar desbloqueado |
| `bloco_03.sql` | Falha da missão | Processa reembolso e remove pendências | Contribuições reembolsadas |
| `bloco_04.sql` | Transparência técnica | Recalcula status da missão pela média das fases | Missão concluída ou ativa conforme progresso |
| `bloco_05.sql` | Gestão de usuários | Inativa usuário sem contribuição confirmada | Status do usuário alterado |
| `bloco_06.sql` | Ajuste de benefícios | Promove tier conforme valor | Tier corrigido para contribuição |

## 7. Mapa Dos Relatórios No Pitch

| Relatório | Pergunta que responde | Valor para a solução |
|---|---|---|
| `relatorio_01.sql` | Quanto cada missão arrecadou? | Mostra transparência financeira e progresso da meta |
| `relatorio_02.sql` | Quais tiers performam melhor? | Mede engajamento e ticket médio |
| `relatorio_03.sql` | Como está a execução técnica? | Mostra avanço real das fases |
| `relatorio_04.sql` | Quais naves estão no hangar? | Demonstra recompensa e gamificação |
| `relatorio_05.sql` | Quais agências geram mais resultado? | Apoia decisões estratégicas e parcerias |

## 8. Necessidade De Cada Grupo De Dados

| Grupo de dados | Necessidade na solução |
|---|---|
| Usuários | Permitir login, cadastro, histórico, papéis `ADMIN`/`USER` e auditoria de participação |
| Missões | Representar campanhas espaciais com meta, prazo, status e impacto |
| Agências | Dar credibilidade institucional e permitir análise de parceiros |
| Organizações | Identificar quem propõe ou opera a missão |
| Tiers | Transformar valor contribuído em benefícios claros |
| Contribuições | Registrar o fluxo financeiro e alimentar relatórios |
| Naves | Criar a recompensa gamificada vinculada à missão |
| Hangar | Mostrar recompensas pendentes ou desbloqueadas por usuário |
| Fases | Dar transparência ao andamento técnico da missão |

## 9. Roteiro Curto Para Pitch De 3 Minutos

**0:00 - 0:30 - Contexto**

"A economia espacial já impacta clima, agricultura, desastres e conectividade. Mas a população ainda participa pouco desse ecossistema. O StarForge resolve isso criando um crowdfunding espacial gamificado."

**0:30 - 1:00 - Solução**

"No StarForge, o usuário escolhe uma missão de CubeSat, contribui por um tier e acompanha o progresso técnico. Quando a missão avança, ele recebe recompensas digitais, como badges, acesso antecipado e naves exclusivas no hangar."

**1:00 - 1:40 - Banco de dados**

"O banco Oracle sustenta a jornada: usuários, missões, agências, organizações, tiers, contribuições, naves, hangar e fases. Cada relacionamento foi modelado para garantir rastreabilidade: quem apoiou, qual missão recebeu, qual tier foi escolhido e qual recompensa foi liberada."

**1:40 - 2:30 - Automação PL/SQL**

"Implementamos seis blocos anônimos para simular regras reais: cadastro com primeira contribuição, confirmação de pagamento, reembolso de missão falha, atualização de status por fases, revisão de usuários e promoção automática de tier."

**2:30 - 3:00 - Indicadores**

"Os relatórios mostram arrecadação por missão, ticket por tier, progresso técnico, hangar de naves e desempenho por agência. Assim, a solução une engajamento, transparência e inteligência operacional para a nova economia espacial."

## 10. Perguntas Que O Professor Pode Fazer

**Por que o banco é relacional?**

Porque a solução depende de integridade entre usuários, missões, contribuições, tiers e recompensas. Uma contribuição precisa apontar para um usuário existente, uma missão existente e um tier válido.

**Onde está a regra de negócio no banco?**

Nos blocos anônimos: confirmação de pagamento, reembolso, promoção de tier, atualização de fases e validação de duplicidade.

**Como vocês evidenciam persistência?**

Executando a carga e os testes, depois mostrando `SELECT` nos scripts de teste e nos relatórios.

**Como a solução conversa com o tema da Global Solution?**

Ela usa a economia espacial como modelo de negócio e conecta missões orbitais a problemas reais da Terra, como monitoramento ambiental, clima, agricultura e prevenção de desastres.

**Qual é o diferencial?**

Combinar crowdfunding, transparência técnica e gamificação. O usuário não apenas doa: ele acompanha fases, vê impacto e recebe recompensas vinculadas a dados reais do banco.

## 11. Fechamento

O StarForge mostra como um banco de dados pode ir além do armazenamento. Ele organiza a jornada do usuário, protege regras financeiras, acompanha missões espaciais, demonstra progresso técnico e gera indicadores para decisão.

Fechamento sugerido:

> "Com StarForge, financiar uma missão espacial deixa de ser algo distante. O usuário acompanha, contribui, recebe recompensas e participa de uma nova economia que conecta espaço e Terra."
