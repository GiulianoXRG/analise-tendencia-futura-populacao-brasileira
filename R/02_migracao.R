# Passo 2 — Migração
#
#   1. filtra, pessoa a pessoa, as variáveis de migração de cada UF;
#   2. calcula a naturalidade: quantos moradores nasceram na própria UF, em
#      outra UF ou no exterior;
#   3. calcula a migração recente entre UFs (quem mora há menos de 10 anos no
#      município e veio de outra UF): entradas, saídas e saldo.
#
# Rode depois de R/01_populacao.R, que gera a população usada na conferência.
#
# Uso, com a raiz do projeto como diretório de trabalho:
#   Rscript R/02_migracao.R             todas as UFs
#   Rscript R/02_migracao.R PB PE       só as UFs indicadas
#   Rscript R/02_migracao.R --refazer   lê os microdados de novo
#
# Fonte: microdados de acesso controlado do IBGE, no zip da raiz do projeto.
# Não compartilhe as pastas dados/; divulgue só os resultados agregados.

source("R/carregar_funcoes.R")

opcoes <- ler_opcoes()


# 1. Filtro de cada UF -----------------------------------------------------

# Cada UF vira um arquivo Parquet com uma linha por pessoa.
siglas    <- atualizar_cache(opcoes, "migracao.parquet", filtrar_migracao_uf)
todas_ufs <- setequal(siglas, ufs$sigla)
criar_pastas(siglas)

# O arrow abre os arquivos de todas as UFs como se fossem uma tabela só, sem
# carregar os registros na memória: só as somas já agrupadas são trazidas
# para o R, com collect().
migracao <- arrow::open_dataset(pasta_uf(siglas, "dados", "migracao.parquet"))


# 2. Naturalidade ----------------------------------------------------------

# População por UF de residência, local e UF de nascimento.
por_nascimento <- migracao |>
  group_by(cod_uf, local_nascimento, uf_nascimento) |>
  summarise(populacao = sum(peso), .groups = "drop") |>
  collect()

# Matriz UF de nascimento x UF de residência, só com quem nasceu no Brasil
# e tem a UF de nascimento conhecida.
matriz_naturalidade <- por_nascimento |>
  filter(local_nascimento != "Outro país", !is.na(uf_nascimento)) |>
  count(uf_nascimento, uf_residencia = cod_uf,
        wt = populacao, name = "populacao") |>
  mutate(
    uf_nascimento = sigla_da_uf(uf_nascimento),
    uf_residencia = sigla_da_uf(uf_residencia),
    populacao     = round(populacao)
  ) |>
  arrange(uf_residencia, desc(populacao))

# Cada morador classificado pelo lugar onde nasceu.
naturalidade <- por_nascimento |>
  mutate(origem = case_when(
    local_nascimento == "Outro país" ~ "exterior",
    is.na(uf_nascimento)             ~ "uf_ignorada",
    uf_nascimento == cod_uf          ~ "mesma_uf",
    TRUE                             ~ "outra_uf"
  )) |>
  count(cod_uf, origem, wt = populacao, name = "populacao") |>
  pivot_wider(names_from = origem, values_from = populacao, values_fill = 0) |>
  mutate(
    populacao    = mesma_uf + outra_uf + exterior + uf_ignorada,
    pct_naturais = 100 * mesma_uf / populacao,
    pct_outra_uf = 100 * outra_uf / populacao,
    pct_exterior = 100 * exterior / populacao
  )


# 3. Migração recente entre UFs --------------------------------------------

# Onde moravam antes as pessoas que estão há menos de 10 anos no município.
por_residencia_anterior <- migracao |>
  filter(!is.na(residencia_anterior)) |>
  group_by(cod_uf, residencia_anterior, uf_anterior) |>
  summarise(populacao = sum(peso), .groups = "drop") |>
  collect()

# Fluxos entre UFs diferentes: origem = UF anterior, destino = UF atual.
fluxos <- por_residencia_anterior |>
  filter(residencia_anterior == "Brasil",
         !is.na(uf_anterior),
         uf_anterior != cod_uf) |>
  count(origem = uf_anterior, destino = cod_uf,
        wt = populacao, name = "migrantes")

# Entradas de uma UF: quem chegou de outra UF.
# Saídas de uma UF: quem saiu dela e hoje mora em outra UF. Por isso elas só
# ficam completas quando todas as UFs foram lidas. Quem saiu do Brasil não é
# captado pelo Censo e não entra nas saídas.
entradas <- count(fluxos, cod_uf = destino, wt = migrantes, name = "entradas")
saidas   <- count(fluxos, cod_uf = origem,  wt = migrantes, name = "saidas")

# Quem mudou de município dentro da própria UF e quem veio do exterior.
outros_migrantes <- por_residencia_anterior |>
  mutate(tipo = case_when(
    residencia_anterior == "Exterior" ~ "vindos_exterior",
    is.na(uf_anterior)                ~ "uf_anterior_ignorada",
    uf_anterior == cod_uf             ~ "intraestaduais",
    TRUE                              ~ "interestaduais"
  )) |>
  count(cod_uf, tipo, wt = populacao, name = "populacao") |>
  pivot_wider(names_from = tipo, values_from = populacao, values_fill = 0) |>
  select(cod_uf, intraestaduais, vindos_exterior)


# Tabela final por UF ------------------------------------------------------

indicadores_migracao <- naturalidade |>
  left_join(outros_migrantes, by = "cod_uf") |>
  left_join(entradas,         by = "cod_uf") |>
  left_join(saidas,           by = "cod_uf") |>
  mutate(
    saidas                = if (todas_ufs) replace_na(saidas, 0) else NA_real_,
    saldo_interestadual   = entradas - saidas,
    taxa_liquida_migracao = 1000 * saldo_interestadual / populacao
  ) |>
  left_join(ufs, by = "cod_uf") |>
  transmute(
    cod_uf, sigla,
    uf                        = nome,
    populacao,
    naturais_da_uf            = mesma_uf,
    nascidos_outra_uf         = outra_uf,
    nascidos_exterior         = exterior,
    pct_naturais, pct_outra_uf, pct_exterior,
    migrantes_intraestaduais  = intraestaduais,
    imigrantes_interestaduais = entradas,
    emigrantes_interestaduais = saidas,
    saldo_interestadual,
    taxa_liquida_migracao,
    imigrantes_exterior       = vindos_exterior
  ) |>
  arrange(cod_uf) |>
  mutate(
    across(c(populacao:nascidos_exterior,
             migrantes_intraestaduais:saldo_interestadual,
             imigrantes_exterior),
           round),
    across(c(pct_naturais:pct_exterior, taxa_liquida_migracao),
           function(valor) round(valor, 1))
  )

# Conferências: a população bate com a do passo 1, e o total de entradas é
# igual ao total de saídas.
conferir_populacao(indicadores_migracao)

if (todas_ufs) {
  stopifnot(isTRUE(all.equal(sum(entradas$entradas), sum(saidas$saidas))))
}


# Salvar -------------------------------------------------------------------

salvar_tabela(indicadores_migracao, "migracao")

fluxos_com_siglas <- fluxos |>
  mutate(
    origem    = sigla_da_uf(origem),
    destino   = sigla_da_uf(destino),
    migrantes = round(migrantes)
  ) |>
  arrange(desc(migrantes))

write_csv(matriz_naturalidade,
          pasta_brasil("resultados", "matriz_naturalidade.csv"))
write_csv(fluxos_com_siglas,
          pasta_brasil("resultados", "fluxos_migracao_recente.csv"))

# Na pasta de cada UF: onde nasceram seus moradores e os fluxos de entrada e
# saída que envolvem a UF.
for (sigla_uf in siglas) {
  naturalidade_da_uf <- filter(matriz_naturalidade, uf_residencia == sigla_uf)

  fluxos_da_uf <- fluxos_com_siglas |>
    filter(origem == sigla_uf | destino == sigla_uf) |>
    mutate(sentido = if_else(destino == sigla_uf, "entrada", "saida"),
           .before = 1)

  write_csv(naturalidade_da_uf,
            pasta_uf(sigla_uf, "resultados", "naturalidade.csv"))
  write_csv(fluxos_da_uf,
            pasta_uf(sigla_uf, "resultados", "fluxos_migracao.csv"))
}

if (todas_ufs) {
  salvar_grafico(grafico_saldo_migratorio(indicadores_migracao),
                 pasta_brasil("graficos", "saldo_migratorio_ufs.png"))
}

indicadores_migracao |>
  select(sigla, pct_naturais, pct_outra_uf,
         imigrantes_interestaduais, emigrantes_interestaduais,
         saldo_interestadual, taxa_liquida_migracao) |>
  print(n = Inf, width = Inf)
