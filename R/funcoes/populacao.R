# População: agregação, pirâmide etária e indicadores de dependência


# População por município, sexo e idade ------------------------------------

# Lê as pessoas da UF e soma os pesos por município, sexo e idade.
#
# A soma é feita logo depois da leitura: o que fica guardado é uma tabela
# pequena (uma linha por município, sexo e idade), e não uma linha por pessoa.
agregar_pessoas_uf <- function(cod_uf, zip_censo) {
  pessoas <- ler_pessoas_uf(cod_uf, zip_censo)

  pessoas |>
    group_by(
      cod_municipio = P0080,
      sexo          = P0160,
      idade         = P0181
    ) |>
    summarise(
      populacao = sum(P0111),
      registros = n(),
      .groups   = "drop"
    ) |>
    mutate(sexo = if_else(sexo == 1, "Homens", "Mulheres"))
}


# Pirâmide etária ----------------------------------------------------------

# Grupos de 5 anos: 0-4, 5-9, ..., 85-89 e 90+.
# Com right = FALSE, o intervalo [0, 5) vira "0-4".
limites_idade <- c(seq(0, 90, by = 5), Inf)

rotulos_idade <- c(
  paste(seq(0, 85, by = 5), seq(4, 89, by = 5), sep = "-"),
  "90+"
)

# Calcula quanto cada sexo e grupo de idade representa da população total
# da UF. Somando as barras de homens e mulheres, dá 100%.
calcular_piramide <- function(populacao) {
  populacao |>
    mutate(grupo_idade = cut(idade,
                             breaks = limites_idade,
                             labels = rotulos_idade,
                             right  = FALSE)) |>
    count(grupo_idade, sexo, wt = populacao, name = "populacao") |>
    mutate(percentual = 100 * populacao / sum(populacao))
}


# Razões de dependência e índice de envelhecimento -------------------------

# Grandes grupos de idade:
#   jovens = 0 a 14 anos | ativos = 15 a 64 anos | idosos = 65 anos ou mais
#
# Todos os indicadores são por 100 pessoas:
#   razão de dependência jovem = jovens / ativos x 100
#   razão de dependência idosa = idosos / ativos x 100
#   razão de dependência total = (jovens + idosos) / ativos x 100
#   índice de envelhecimento   = idosos / jovens x 100
calcular_indicadores <- function(populacao) {
  grupos <- populacao |>
    mutate(grupo = case_when(
      idade <= 14 ~ "jovens",
      idade <= 64 ~ "ativos",
      TRUE        ~ "idosos"
    )) |>
    count(grupo, wt = populacao, name = "populacao") |>
    pivot_wider(names_from = grupo, values_from = populacao)

  grupos |>
    transmute(
      populacao               = jovens + ativos + idosos,
      razao_dependencia_jovem = 100 * jovens / ativos,
      razao_dependencia_idosa = 100 * idosos / ativos,
      razao_dependencia_total = 100 * (jovens + idosos) / ativos,
      indice_envelhecimento   = 100 * idosos / jovens
    )
}
