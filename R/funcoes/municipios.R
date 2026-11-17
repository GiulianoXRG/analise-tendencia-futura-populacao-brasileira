# Municípios: nomes, malha do mapa, pastas e indicadores por município


# Pastas -------------------------------------------------------------------

# Os resultados dos municípios de uma UF ficam em ufs/<uf>/municipios/:
#   README.md, graficos/ e resultados/   visão geral, com mapas e tabelas
#   <nome-do-municipio>/                 uma pasta por município
pasta_municipios <- function(sigla_uf, ...) {
  pasta_uf(sigla_uf, "municipios", ...)
}

# Nome de pasta a partir do nome do município: "Açu" vira "acu" e
# "São Gonçalo do Amarante" vira "sao_goncalo_do_amarante".
nome_para_pasta <- function(nome) {
  nome |>
    stringi::stri_trans_general("Latin-ASCII") |>
    tolower() |>
    str_replace_all("[^a-z0-9]+", "_") |>
    str_remove_all("^_|_$")
}


# Nomes e malha dos municípios ---------------------------------------------

# Código e nome de todos os municípios do Brasil, da base pública de setores
# censitários de 2022 do pacote censobr (a mesma usada no passo 1).
ler_nomes_municipios <- function() {
  censobr::read_tracts(year = 2022, dataset = "Basico") |>
    distinct(code_muni, name_muni) |>
    collect() |>
    transmute(
      cod_municipio = as.integer(code_muni),
      municipio     = name_muni,
      sigla_uf      = sigla_da_uf(cod_municipio %/% 100000)
    )
}

# Contorno dos municípios da UF para os mapas, do pacote geobr (IPEA).
# É baixado uma vez e guardado em ufs/<uf>/dados/malha_municipios.rds.
ler_malha_municipios <- function(sigla_uf) {
  arquivo <- pasta_uf(sigla_uf, "dados", "malha_municipios.rds")

  if (!file.exists(arquivo)) {
    malha <- geobr::read_municipality(code_muni = sigla_uf, year = 2022,
                                      showProgress = FALSE) |>
      transmute(cod_municipio = as.integer(code_muni))
    write_rds(malha, arquivo)
  }

  read_rds(arquivo)
}


# Funções de apoio ---------------------------------------------------------

# Garante que a tabela tenha as colunas indicadas, criando com zero as que
# faltarem (acontece quando nenhum município tem gente em uma categoria).
garantir_colunas <- function(tabela, colunas) {
  for (coluna in setdiff(colunas, names(tabela))) {
    tabela[[coluna]] <- 0
  }
  tabela
}

# Primeiro e último código de município de uma UF (os códigos começam pelos
# dois dígitos da UF: 2408102 é Natal, no RN, de código 24).
faixa_de_codigos <- function(cod_uf) {
  c(cod_uf * 100000, (cod_uf + 1) * 100000 - 1)
}


# População ----------------------------------------------------------------

# Indicadores de dependência e envelhecimento de cada município.
indicadores_municipios <- function(populacao_uf) {
  populacao_uf |>
    group_by(cod_municipio) |>
    group_modify(function(dados, grupo) calcular_indicadores(dados)) |>
    ungroup() |>
    left_join(
      summarise(populacao_uf, registros = sum(registros), .by = cod_municipio),
      by = "cod_municipio"
    )
}

# Pirâmide etária de cada município.
piramides_municipios <- function(populacao_uf) {
  populacao_uf |>
    group_by(cod_municipio) |>
    group_modify(function(dados, grupo) calcular_piramide(dados)) |>
    ungroup()
}


# Migração -----------------------------------------------------------------

# Naturalidade e migração recente de cada município da UF.
#
# `migracao` é a base de migração de todas as UFs (aberta com arrow). As
# saídas de um município são as pessoas que hoje moram em qualquer lugar do
# Brasil e moravam nele antes, por isso precisam das bases de todas as UFs.
#
# Só entram nos fluxos as mudanças com município de origem conhecido, para
# que entradas e saídas sejam contadas do mesmo jeito.
calcular_migracao_municipios <- function(migracao, cod_uf_escolhida) {
  codigos <- faixa_de_codigos(cod_uf_escolhida)

  # Naturalidade dos moradores de cada município.
  naturalidade <- migracao |>
    filter(cod_uf == cod_uf_escolhida) |>
    group_by(cod_municipio, local_nascimento, uf_nascimento) |>
    summarise(populacao = sum(peso), .groups = "drop") |>
    collect() |>
    mutate(origem = case_when(
      local_nascimento == "Neste município" ~ "mesmo_municipio",
      local_nascimento == "Outro país"      ~ "exterior",
      is.na(uf_nascimento)                  ~ "ignorada",
      uf_nascimento == cod_uf_escolhida     ~ "outro_municipio_uf",
      TRUE                                  ~ "outra_uf"
    )) |>
    count(cod_municipio, origem, wt = populacao, name = "populacao") |>
    pivot_wider(names_from = origem, values_from = populacao,
                values_fill = 0) |>
    garantir_colunas(c("mesmo_municipio", "outro_municipio_uf", "outra_uf",
                       "exterior", "ignorada"))

  # Fluxos entre municípios nos últimos 10 anos que chegam ou saem da UF.
  fluxos <- migracao |>
    filter(residencia_anterior == "Brasil",
           !is.na(mun_anterior),
           mun_anterior != cod_municipio,
           cod_uf == cod_uf_escolhida |
             (mun_anterior >= codigos[1] & mun_anterior <= codigos[2])) |>
    group_by(origem = mun_anterior, destino = cod_municipio) |>
    summarise(migrantes = sum(peso), .groups = "drop") |>
    collect()

  na_uf <- function(codigo) {
    codigo >= codigos[1] & codigo <= codigos[2]
  }

  entradas <- fluxos |>
    filter(na_uf(destino)) |>
    summarise(
      entradas          = sum(migrantes),
      entradas_mesma_uf = sum(migrantes[na_uf(origem)]),
      .by = destino
    ) |>
    rename(cod_municipio = destino)

  saidas <- fluxos |>
    filter(na_uf(origem)) |>
    summarise(
      saidas          = sum(migrantes),
      saidas_mesma_uf = sum(migrantes[na_uf(destino)]),
      .by = origem
    ) |>
    rename(cod_municipio = origem)

  # Quem veio do exterior e quem veio do Brasil sem informar o município.
  outras_chegadas <- migracao |>
    filter(cod_uf == cod_uf_escolhida, !is.na(residencia_anterior)) |>
    mutate(tipo = if_else(residencia_anterior == "Exterior",
                          "vindos_exterior", "brasil")) |>
    filter(tipo == "vindos_exterior" | is.na(mun_anterior)) |>
    mutate(tipo = if_else(tipo == "brasil", "origem_ignorada", tipo)) |>
    group_by(cod_municipio, tipo) |>
    summarise(populacao = sum(peso), .groups = "drop") |>
    collect() |>
    pivot_wider(names_from = tipo, values_from = populacao,
                values_fill = 0) |>
    garantir_colunas(c("vindos_exterior", "origem_ignorada"))

  tabela <- naturalidade |>
    left_join(entradas,        by = "cod_municipio") |>
    left_join(saidas,          by = "cod_municipio") |>
    left_join(outras_chegadas, by = "cod_municipio") |>
    mutate(across(c(entradas, entradas_mesma_uf, saidas, saidas_mesma_uf,
                    vindos_exterior, origem_ignorada),
                  function(valor) replace_na(valor, 0))) |>
    mutate(
      populacao                = mesmo_municipio + outro_municipio_uf +
                                 outra_uf + exterior + ignorada,
      pct_naturais_municipio   = 100 * mesmo_municipio / populacao,
      pct_outro_municipio_uf   = 100 * outro_municipio_uf / populacao,
      pct_outra_uf             = 100 * outra_uf / populacao,
      pct_exterior             = 100 * exterior / populacao,
      entradas_outra_uf        = entradas - entradas_mesma_uf,
      saidas_outra_uf          = saidas - saidas_mesma_uf,
      saldo_migratorio         = entradas - saidas,
      taxa_liquida_migracao    = 1000 * saldo_migratorio / populacao
    )

  list(tabela = tabela, fluxos = fluxos)
}


# Mortalidade --------------------------------------------------------------

# Óbitos, taxa bruta e taxa padronizada por idade de cada município, para os
# meses em `meses`.
#
# A taxa bruta depende da estrutura etária: um município mais velho tem mais
# óbitos mesmo com a mesma mortalidade por idade. A taxa padronizada aplica
# as taxas por idade de cada município a uma mesma população, a da UF, e por
# isso permite comparar os municípios entre si.
#
# Óbitos com sexo ou idade ignorados são redistribuídos proporcionalmente,
# com o mesmo fator da UF inteira.
calcular_mortalidade_municipios <- function(obitos_uf, populacao_uf, meses) {
  obitos_periodo <- filter(obitos_uf, mes %in% meses)

  conhecidos <- filter(obitos_periodo, !is.na(sexo), !is.na(idade))
  fator      <- sum(obitos_periodo$obitos) / sum(conhecidos$obitos)

  obitos_por_grupo <- conhecidos |>
    mutate(x = grupo_da_tabua(idade)) |>
    count(cod_municipio, sexo, x, wt = obitos * fator, name = "obitos")

  populacao_por_grupo <- populacao_uf |>
    mutate(x = grupo_da_tabua(idade)) |>
    count(cod_municipio, sexo, x, wt = populacao, name = "populacao")

  base <- full_join(obitos_por_grupo, populacao_por_grupo,
                    by = c("cod_municipio", "sexo", "x")) |>
    mutate(obitos    = replace_na(obitos, 0),
           populacao = replace_na(populacao, 0))

  # População padrão: a da UF inteira, por grupo de idade (ambos os sexos).
  padrao <- base |>
    summarise(populacao_padrao = sum(populacao), .by = x)

  padronizada <- base |>
    summarise(obitos = sum(obitos), populacao = sum(populacao),
              .by = c(cod_municipio, x)) |>
    left_join(padrao, by = "x") |>
    mutate(taxa = if_else(populacao > 0, obitos / populacao, 0)) |>
    summarise(
      taxa_padronizada_mortalidade =
        1000 * sum(taxa * populacao_padrao) / sum(populacao_padrao),
      .by = cod_municipio
    )

  resumo <- obitos_periodo |>
    summarise(obitos = sum(obitos), registros_obitos = sum(registros),
              .by = cod_municipio)

  tabela <- populacao_uf |>
    summarise(populacao = sum(populacao), .by = cod_municipio) |>
    left_join(resumo,      by = "cod_municipio") |>
    left_join(padronizada, by = "cod_municipio") |>
    mutate(
      obitos                 = replace_na(obitos, 0),
      registros_obitos       = replace_na(registros_obitos, 0),
      taxa_bruta_mortalidade = 1000 * obitos / populacao
    )

  list(tabela = tabela, base = base)
}

# Tábuas de vida (por sexo e ambos os sexos) dos municípios em `codigos`.
tabuas_municipios <- function(base, codigos) {
  base_escolhida <- filter(base, cod_municipio %in% codigos)

  ambos_os_sexos <- base_escolhida |>
    summarise(across(c(obitos, populacao), sum), .by = c(cod_municipio, x)) |>
    mutate(sexo = "Total")

  bind_rows(base_escolhida, ambos_os_sexos) |>
    group_by(cod_municipio, sexo) |>
    group_modify(function(dados, grupo) tabua_vida(dados, grupo$sexo)) |>
    ungroup()
}
