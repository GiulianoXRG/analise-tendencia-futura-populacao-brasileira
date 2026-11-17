# Passo 4 — Municípios
#
# Para cada município da UF:
#   1. pirâmide etária, razões de dependência e índice de envelhecimento;
#   2. naturalidade e migração recente (entradas, saídas e saldo);
#   3. óbitos, taxa bruta e taxa padronizada de mortalidade, e tábua de vida
#      só para os municípios grandes (veja `populacao_minima_tabua`).
# Os resultados ficam em ufs/<uf>/municipios/, com mapas da UF e uma pasta
# por município.
#
# Usa as bases salvas pelos passos 1 a 3. Rode aqueles passos antes.
#
# Uso, com a raiz do projeto como diretório de trabalho:
#   Rscript R/04_municipios.R            Rio Grande do Norte (padrão)
#   Rscript R/04_municipios.R PB CE      os municípios das UFs indicadas
#
# Atenção: em municípios pequenos os resultados vêm de poucos registros da
# amostra (a coluna `registros` mostra quantos). As taxas de mortalidade não
# têm correção do sub-registro de óbitos do Censo.

source("R/carregar_funcoes.R")

opcoes <- ler_opcoes(siglas_padrao = "RN")

# Tábua de vida só para municípios com pelo menos esta população: abaixo
# disso há poucos óbitos na amostra e a tábua vira ruído.
populacao_minima_tabua <- 100000

# Os 12 meses antes da data de referência do Censo (ago/2021 a jul/2022).
meses_referencia <- 32:43


# Bases de entrada ---------------------------------------------------------

for (sigla_uf in opcoes$siglas) {
  for (arquivo in c("populacao.rds", "obitos.rds", "migracao.parquet")) {
    if (!file.exists(pasta_uf(sigla_uf, "dados", arquivo))) {
      stop("Falta ", pasta_uf(sigla_uf, "dados", arquivo),
           ". Rode antes os passos 1 a 3.")
    }
  }
}

# As saídas de um município incluem quem foi para outras UFs, então a
# migração precisa das bases de todas as UFs.
arquivos_migracao <- pasta_uf(ufs$sigla, "dados", "migracao.parquet")
arquivos_migracao <- arquivos_migracao[file.exists(arquivos_migracao)]

if (length(arquivos_migracao) < nrow(ufs)) {
  warning("Nem todas as UFs têm a base de migração: as saídas para fora ",
          "da UF ficam incompletas. Rode R/02_migracao.R para todas.")
}

migracao_brasil <- arrow::open_dataset(arquivos_migracao)
nomes           <- ler_nomes_municipios()

# Nome com a UF, para os fluxos: "Natal (RN)".
nome_com_uf <- function(codigo) {
  linha <- match(codigo, nomes$cod_municipio)
  paste0(nomes$municipio[linha], " (", nomes$sigla_uf[linha], ")")
}


# Cada UF ------------------------------------------------------------------

for (sigla_uf in opcoes$siglas) {
  message("\n", nome_da_uf(sigla_uf), ": municípios")

  cod_uf    <- codigo_da_uf(sigla_uf)
  populacao <- read_rds(pasta_uf(sigla_uf, "dados", "populacao.rds"))
  obitos    <- read_rds(pasta_uf(sigla_uf, "dados", "obitos.rds"))

  municipios <- nomes |>
    filter(cod_municipio %in% populacao$cod_municipio) |>
    mutate(pasta = nome_para_pasta(municipio)) |>
    arrange(municipio, .locale = "pt")

  stopifnot(
    nrow(municipios) == n_distinct(populacao$cod_municipio),
    !anyDuplicated(municipios$pasta)
  )

  criar_pasta(pasta_municipios(sigla_uf, "graficos"))
  criar_pasta(pasta_municipios(sigla_uf, "resultados"))
  for (pasta in municipios$pasta) {
    criar_pasta(pasta_municipios(sigla_uf, pasta))
  }

  # Acrescenta o nome do município e põe as colunas de identificação antes.
  identificar <- function(tabela) {
    tabela |>
      left_join(select(municipios, cod_municipio, municipio),
                by = "cod_municipio") |>
      relocate(cod_municipio, municipio)
  }


  # 1. População -----------------------------------------------------------

  indicadores <- indicadores_municipios(populacao) |>
    identificar() |>
    mutate(across(razao_dependencia_jovem:indice_envelhecimento,
                  function(valor) round(valor, 1)),
           populacao = round(populacao))

  # Conferência: os municípios somam a população da UF.
  populacao_uf <- ler_tabela_brasil("indicadores_ufs.csv") |>
    filter(sigla == sigla_uf) |>
    pull(populacao)
  stopifnot(abs(sum(indicadores$populacao) - populacao_uf) <= nrow(municipios))

  piramides <- piramides_municipios(populacao)
  limite_x  <- max(5, ceiling(max(piramides$percentual)))

  for (i in seq_len(nrow(municipios))) {
    municipio <- municipios[i, ]

    titulo <- paste0("Pirâmide etária de ", municipio$municipio, " (",
                     sigla_uf, "), 2022")

    grafico <- piramides |>
      filter(cod_municipio == municipio$cod_municipio) |>
      grafico_piramide(municipio$municipio, limite_x, titulo = titulo)

    salvar_grafico(grafico,
                   pasta_municipios(sigla_uf, municipio$pasta,
                                    "piramide_etaria.png"),
                   dpi = 150)
  }

  piramides |>
    identificar() |>
    mutate(populacao  = round(populacao),
           percentual = round(percentual, 2)) |>
    write_csv(pasta_municipios(sigla_uf, "resultados",
                               "piramides_municipios.csv"))

  write_csv(indicadores, pasta_municipios(sigla_uf, "resultados",
                                          "indicadores_municipios.csv"))


  # 2. Migração ------------------------------------------------------------

  resultado_migracao <- calcular_migracao_municipios(migracao_brasil, cod_uf)

  migracao <- resultado_migracao$tabela |>
    identificar() |>
    select(cod_municipio, municipio, populacao,
           pct_naturais_municipio, pct_outro_municipio_uf, pct_outra_uf,
           pct_exterior,
           entradas, entradas_mesma_uf, entradas_outra_uf,
           saidas, saidas_mesma_uf, saidas_outra_uf,
           saldo_migratorio, taxa_liquida_migracao,
           vindos_exterior, origem_ignorada) |>
    mutate(
      across(c(populacao, entradas:saldo_migratorio, vindos_exterior,
               origem_ignorada), round),
      across(c(starts_with("pct_"), taxa_liquida_migracao),
             function(valor) round(valor, 1))
    )

  # Conferência: a população da migração bate com a do passo 1.
  stopifnot(all(abs(migracao$populacao -
                      indicadores$populacao[match(migracao$cod_municipio,
                                                  indicadores$cod_municipio)])
                <= 1))

  write_csv(migracao, pasta_municipios(sigla_uf, "resultados",
                                       "migracao_municipios.csv"))

  resultado_migracao$fluxos |>
    mutate(
      origem_nome  = nome_com_uf(origem),
      destino_nome = nome_com_uf(destino),
      migrantes    = round(migrantes)
    ) |>
    select(origem_cod = origem, origem = origem_nome,
           destino_cod = destino, destino = destino_nome, migrantes) |>
    arrange(desc(migrantes)) |>
    write_csv(pasta_municipios(sigla_uf, "resultados",
                               "fluxos_migracao_municipios.csv"))


  # 3. Mortalidade ---------------------------------------------------------

  resultado_mortalidade <- calcular_mortalidade_municipios(obitos, populacao,
                                                           meses_referencia)

  grandes <- indicadores |>
    filter(populacao >= populacao_minima_tabua) |>
    pull(cod_municipio)

  tabuas <- tabuas_municipios(resultado_mortalidade$base, grandes)

  esperanca_de_vida <- tabuas |>
    filter(x %in% c(0, 60)) |>
    transmute(cod_municipio,
              coluna = paste0("e", x, "_", str_to_lower(sexo)),
              ex) |>
    pivot_wider(names_from = coluna, values_from = ex)

  mortalidade <- resultado_mortalidade$tabela |>
    left_join(esperanca_de_vida, by = "cod_municipio") |>
    identificar() |>
    mutate(
      across(c(obitos, populacao), round),
      across(c(taxa_bruta_mortalidade, taxa_padronizada_mortalidade,
               starts_with("e0_"), starts_with("e60_")),
             function(valor) round(valor, 1))
    )

  # Conferência: os óbitos dos municípios somam os da UF no período.
  obitos_uf <- ler_tabela_brasil("mortalidade_ufs.csv") |>
    filter(sigla == sigla_uf) |>
    pull(obitos)
  stopifnot(abs(sum(mortalidade$obitos) - obitos_uf) <= nrow(municipios))

  write_csv(mortalidade, pasta_municipios(sigla_uf, "resultados",
                                          "mortalidade_municipios.csv"))

  tabuas |>
    identificar() |>
    mutate(
      n = if_else(is.infinite(n), NA, n),
      across(c(obitos, populacao, lx, ndx, nLx, Tx), round),
      across(c(nMx, nqx), function(valor) signif(valor, 5)),
      across(c(nax, ex),  function(valor) round(valor, 2))
    ) |>
    write_csv(pasta_municipios(sigla_uf, "resultados",
                               "tabuas_vida_municipios.csv"))

  for (codigo in grandes) {
    municipio <- filter(municipios, cod_municipio == codigo)
    titulo    <- paste0(municipio$municipio, " (", sigla_uf, ")")

    salvar_grafico(
      grafico_curva_mortalidade(filter(tabuas, cod_municipio == codigo),
                                titulo),
      pasta_municipios(sigla_uf, municipio$pasta, "curva_mortalidade.png"),
      altura = 6, dpi = 150
    )
  }


  # Mapas ------------------------------------------------------------------

  # A mortalidade não entra nos mapas: na maioria dos municípios há poucos
  # óbitos na amostra, e o mapa mostraria mais ruído do que diferença real.
  malha <- ler_malha_municipios(sigla_uf) |>
    left_join(indicadores, by = "cod_municipio") |>
    left_join(select(migracao, cod_municipio, taxa_liquida_migracao,
                     pct_naturais_municipio),
              by = "cod_municipio")

  nome_uf <- nome_da_uf(sigla_uf)

  mapas <- list(
    mapa_indice_envelhecimento = grafico_mapa(
      malha, "indice_envelhecimento",
      paste0("Índice de envelhecimento, ", nome_uf, ", 2022"),
      "Idosos (65+) por 100 jovens (0 a 14 anos)"
    ),
    mapa_razao_dependencia = grafico_mapa(
      malha, "razao_dependencia_total",
      paste0("Razão de dependência total, ", nome_uf, ", 2022"),
      "Jovens e idosos por 100 pessoas de 15 a 64 anos"
    ),
    mapa_saldo_migratorio = grafico_mapa(
      malha, "taxa_liquida_migracao",
      paste0("Saldo migratório, ", nome_uf, ", 2022"),
      paste("Entradas menos saídas por 1.000 habitantes, entre quem mudou",
            "de município há menos de 10 anos"),
      tipo = "divergente"
    ),
    mapa_naturais_municipio = grafico_mapa(
      malha, "pct_naturais_municipio",
      paste0("Moradores nascidos no próprio município, ", nome_uf, ", 2022"),
      "Percentual da população"
    )
  )

  for (nome_mapa in names(mapas)) {
    salvar_grafico(mapas[[nome_mapa]],
                   pasta_municipios(sigla_uf, "graficos",
                                    paste0(nome_mapa, ".png")))
  }

  message(sprintf("%d municípios, %d com tábua de vida",
                  nrow(municipios), length(grandes)))
}
