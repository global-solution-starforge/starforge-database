# Starforge Database - Oracle SQL e PL/SQL

## Visao Geral

Esta solucao complementa o DDL fornecido para o sistema Starforge, uma plataforma ficticia de financiamento coletivo para missoes espaciais. O banco registra agencias, organizacoes, missoes, fases tecnicas, naves, usuarios, tiers de apoio, contribuicoes financeiras e desbloqueios de naves no hangar digital.

O objetivo da entrega e demonstrar dominio de Oracle SQL e PL/SQL por meio de massa de dados consistente, blocos anonimos com regras de negocio, relatorios analiticos e scripts de teste.

## Requisitos Atendidos

| Requisito | Arquivos |
|---|---|
| DDL organizado | `ddl/schema.sql` |
| Massa com no minimo 100 registros | `dados/carga_100_registros.sql` |
| 6 blocos anonimos independentes | `blocos-anonimos/bloco_01.sql` a `bloco_06.sql` |
| Excecoes explicitas nos blocos | Todos os arquivos em `blocos-anonimos/` |
| Variaveis locais e `SELECT INTO` | Todos os arquivos em `blocos-anonimos/` |
| DML com variaveis | Todos os blocos usam `UPDATE`/`DELETE`; os blocos 01 e 02 tambem usam `INSERT` |
| Condicionais | Todos os blocos possuem `IF`, `ELSIF`, `ELSE` ou `CASE` |
| Repeticoes | Blocos 01, 02, 03, 04, 05 e 06 usam `FOR`, `WHILE` ou `LOOP` |
| 5 relatorios com JOIN | `relatorios/relatorio_01.sql` a `relatorio_05.sql` |
| Testes dos blocos | `testes/blocos-anonimos/teste_bloco_01.sql` a `teste_bloco_06.sql` |
| Testes dos relatorios | `testes/relatorios/teste_relatorio_01.sql` a `teste_relatorio_05.sql` |

## Detalhamento das Tabelas

`TB_AGENCIA`: cadastra agencias espaciais responsaveis por missoes.

`TB_ORGANIZACAO`: cadastra organizacoes proponentes das missoes.

`TB_TIER`: define os niveis de contribuicao: APOIADOR, OPERATIVO e COMANDANTE.

`TB_USUARIO`: armazena apoiadores cadastrados na plataforma.

`TB_MISSAO`: representa campanhas de financiamento para missoes espaciais.

`TB_FASE_MISSAO`: controla as quatro fases tecnicas de cada missao.

`TB_NAVE`: registra a nave associada a cada missao.

`TB_CONTRIBUICAO`: registra pagamentos dos usuarios para missoes e tiers.

`TB_HANGAR`: registra desbloqueios de naves para contribuicoes qualificadas.

Relacionamentos principais: uma agencia e uma organizacao possuem varias missoes; cada missao possui fases e uma nave; usuarios fazem contribuicoes para missoes escolhendo um tier; contribuicoes do tier COMANDANTE podem desbloquear uma nave no hangar.

## Dicionario de Dados

### TB_AGENCIA

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_AGENCIA | VARCHAR2(36) | Sim | Sim | Nao | Identificador da agencia |
| NM_AGENCIA | VARCHAR2(50) | Sim | Nao | Nao | Nome unico da agencia |

### TB_ORGANIZACAO

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_ORGANIZACAO | VARCHAR2(36) | Sim | Sim | Nao | Identificador da organizacao |
| NM_ORGANIZACAO | VARCHAR2(50) | Sim | Nao | Nao | Nome da organizacao |

### TB_TIER

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_TIER | VARCHAR2(36) | Sim | Sim | Nao | Identificador do tier |
| NM_TIER | VARCHAR2(50) | Sim | Nao | Nao | Nome do tier: APOIADOR, OPERATIVO ou COMANDANTE |
| VL_MIN_TIER | NUMBER(10,2) | Sim | Nao | Nao | Valor minimo para o tier |
| FL_ACESSO_ANT_TIER | VARCHAR2(1) | Sim | Nao | Nao | Indica acesso antecipado: S ou N |
| DS_TIER | VARCHAR2(255) | Nao | Nao | Nao | Beneficios do tier |

### TB_USUARIO

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_USUARIO | VARCHAR2(36) | Sim | Sim | Nao | Identificador do usuario |
| NM_USUARIO | VARCHAR2(100) | Sim | Nao | Nao | Nome do usuario |
| EM_USUARIO | VARCHAR2(100) | Sim | Nao | Nao | E-mail unico |
| SEN_HASH_USUARIO | VARCHAR2(255) | Sim | Nao | Nao | Hash da senha |
| STT_USUARIO | VARCHAR2(7) | Sim | Nao | Nao | Status: ATIVO ou INATIVO |
| RL_USUARIO | VARCHAR2(5) | Sim | Nao | Nao | Papel do usuario: ADMIN ou USER |
| DT_CADST_USUARIO | DATE | Sim | Nao | Nao | Data de cadastro |

### TB_MISSAO

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_MISSAO | VARCHAR2(36) | Sim | Sim | Nao | Identificador da missao |
| CD_MISSAO | VARCHAR2(20) | Sim | Nao | Nao | Codigo unico da missao |
| NM_MISSAO | VARCHAR2(100) | Sim | Nao | Nao | Nome da missao |
| DS_MISSAO | CLOB | Nao | Nao | Nao | Briefing da missao |
| STT_MISSAO | VARCHAR2(20) | Sim | Nao | Nao | CRIACAO, ATIVA, CONCLUIDA ou FALHOU |
| VL_META_MISSAO | NUMBER(12,2) | Sim | Nao | Nao | Meta financeira |
| DT_LIMITE | DATE | Nao | Nao | Nao | Data limite de financiamento |
| TP_ORB_MISSAO | VARCHAR2(50) | Nao | Nao | Nao | Tipo de orbita |
| VD_UTIL_MISSAO | VARCHAR2(20) | Nao | Nao | Nao | Vida util estimada |
| CG_UTIL_MISSAO | VARCHAR2(100) | Nao | Nao | Nao | Carga util |
| COORD_LAT_MISSAO | NUMBER(10,6) | Nao | Nao | Nao | Latitude monitorada |
| COORD_LNG_MISSAO | NUMBER(10,6) | Nao | Nao | Nao | Longitude monitorada |
| BADG_MISSAO | VARCHAR2(50) | Nao | Nao | Nao | Badge da campanha |
| TB_ORGANIZACAO_ID_ORGANIZACAO | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_ORGANIZACAO` |
| TB_AGENCIA_ID_AGENCIA | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_AGENCIA` |

### TB_FASE_MISSAO

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_FASE_MISSAO | VARCHAR2(36) | Sim | Sim | Nao | Identificador da fase |
| NMR_FASE_MISSAO | NUMBER(1) | Sim | Nao | Nao | Numero da fase, de 1 a 4 |
| NM_FASE_MISSAO | VARCHAR2(100) | Sim | Nao | Nao | Nome da fase |
| DS_FASE_MISSAO | VARCHAR2(255) | Nao | Nao | Nao | Descricao tecnica |
| STT_FASE | VARCHAR2(20) | Sim | Nao | Nao | AGUARDANDO, EM ANDAMENTO ou CONCLUIDO |
| PCT_FASE_MISSAO | NUMBER(5,2) | Sim | Nao | Nao | Percentual de progresso |
| TB_MISSAO_ID_MISSAO | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_MISSAO` |

### TB_NAVE

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_NAVE | VARCHAR2(36) | Sim | Sim | Nao | Identificador da nave |
| NM_NAVE | VARCHAR2(100) | Sim | Nao | Nao | Nome da nave |
| CLS_NAVE | VARCHAR2(100) | Nao | Nao | Nao | Classe da nave |
| IMG_URL_NAVE | VARCHAR2(255) | Nao | Nao | Nao | URL da imagem |
| TB_MISSAO_ID_MISSAO | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_MISSAO` |

### TB_CONTRIBUICAO

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_CONTRIBUICAO | VARCHAR2(36) | Sim | Sim | Nao | Identificador da contribuicao |
| VL_CONTRIBUICAO | NUMBER(10,2) | Sim | Nao | Nao | Valor contribuido |
| STT_CONTRIBUICAO | VARCHAR2(20) | Sim | Nao | Nao | PENDENTE, CONFIRMADO ou REEMBOLSADO |
| MTD_PGT_CONTRIBUICAO | VARCHAR2(20) | Sim | Nao | Nao | CREDITO, DEBITO ou PIX |
| DT_CONTRIBUICAO | DATE | Sim | Nao | Nao | Data da contribuicao |
| TB_USUARIO_ID_USUARIO | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_USUARIO` |
| TB_MISSAO_ID_MISSAO | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_MISSAO` |
| TB_TIER_ID_TIER | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_TIER` |

### TB_HANGAR

| Coluna | Tipo | Obrigatoria | PK | FK | Descricao |
|---|---|---|---|---|---|
| ID_HANGAR | VARCHAR2(36) | Sim | Sim | Nao | Identificador do hangar |
| DT_DESBLQ_NAVE_HANGAR | DATE | Nao | Nao | Nao | Data de desbloqueio da nave |
| STATUS_NAVE_HANGAR | VARCHAR2(20) | Sim | Nao | Nao | PENDENTE ou DESBLOQUEADA |
| NM_GRAVADO_HANGAR | VARCHAR2(100) | Nao | Nao | Nao | Nome gravado no hangar |
| TB_NAVE_ID_NAVE | VARCHAR2(36) | Sim | Nao | Sim | FK para `TB_NAVE` |
| TB_CONTRIB_ID_CONTRIB | VARCHAR2(36) | Sim | Nao | Sim | FK unica para `TB_CONTRIBUICAO` |

## Guia de Execucao

Execute em uma conexao Oracle com permissao para criar tabelas.

1. DDL: `@ddl/schema.sql`
2. Massa de dados: `@dados/carga_100_registros.sql`
3. Blocos anonimos: `@blocos-anonimos/bloco_01.sql` ate `@blocos-anonimos/bloco_06.sql`
4. Relatorios: `@relatorios/relatorio_01.sql` ate `@relatorios/relatorio_05.sql`
5. Testes: scripts em `testes/blocos-anonimos/` e `testes/relatorios/`

Para recriar o ambiente do zero, execute primeiro o DDL em um schema limpo, pois o script fornecido cria objetos sem comandos `DROP`.

## Guia de Testes

| Arquivo | Objetivo | Comando | Resultado esperado |
|---|---|---|---|
| `teste_bloco_01.sql` | Cadastro de apoiador e contribuicao pendente | `@testes/blocos-anonimos/teste_bloco_01.sql` | Primeiro sucesso; segunda execucao mostra excecao de e-mail duplicado |
| `teste_bloco_02.sql` | Confirmar pagamento e atualizar hangar | `@testes/blocos-anonimos/teste_bloco_02.sql` | Contribuicao confirmada e hangar desbloqueado; excecao para reembolso |
| `teste_bloco_03.sql` | Reembolsar missao falha | `@testes/blocos-anonimos/teste_bloco_03.sql` | Contribuicoes da MIS-010 ficam REEMBOLSADO; excecao para missao ativa |
| `teste_bloco_04.sql` | Recalcular status da missao | `@testes/blocos-anonimos/teste_bloco_04.sql` | MIS-007 fica CONCLUIDA; excecao para missao sem fases |
| `teste_bloco_05.sql` | Revisao cadastral de usuario | `@testes/blocos-anonimos/teste_bloco_05.sql` | Usuario USR-021 fica INATIVO; excecao quando possui contribuicao confirmada |
| `teste_bloco_06.sql` | Promocao de tier por valor | `@testes/blocos-anonimos/teste_bloco_06.sql` | CONTRIB-008 fica no tier OPERATIVO; excecao para reembolso |
| `teste_relatorio_01.sql` | Arrecadacao por missao | `@testes/relatorios/teste_relatorio_01.sql` | Uma linha por missao |
| `teste_relatorio_02.sql` | Contribuicoes por tier | `@testes/relatorios/teste_relatorio_02.sql` | Totais, soma e ticket medio por tier |
| `teste_relatorio_03.sql` | Progresso por missao | `@testes/relatorios/teste_relatorio_03.sql` | Total de fases e progresso medio por missao |
| `teste_relatorio_04.sql` | Hangar e naves | `@testes/relatorios/teste_relatorio_04.sql` | Uma linha por registro de hangar |
| `teste_relatorio_05.sql` | Desempenho por agencia | `@testes/relatorios/teste_relatorio_05.sql` | Total de missoes e arrecadacao por agencia |
