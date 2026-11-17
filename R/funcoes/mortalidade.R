# Mortalidade: óbitos e tábua de vida


# Óbitos por município, sexo, idade e mês ----------------------------------

# Lê os óbitos de moradores informados pelo domicílio (janeiro de 2019 a
# julho de 2022) e soma os pesos por município, mês, sexo e idade.
#
# Colunas do arquivo de mortalidade:
#   M0020  código da UF
#   M0080  código do município
#   M0111  peso amostral
#   M0151  mês e ano do óbito (1 = jan/2019, ..., 43 = jul/2022, 99 = ignorado)
#   M0160  sexo (1 masculino, 2 feminino, 9 ignorado)
#   M0171  idade ao morrer, em anos (em branco quando não foi informada)
agregar_obitos_uf <- function(cod_uf, zip_censo) {
  colunas <- c(
    M0020 = "integer",
    M0080 = "integer",
    M0111 = "double",
    M0151 = "integer",
    M0160 = "integer",
    M0171 = "integer"
  )

  obitos <- ler_arquivo_uf(cod_uf, zip_censo,
                           arquivo = "Mortalidade",
                           colunas = colunas)

  # Conferência: o arquivo só tem óbitos desta UF.
  stopifnot(all(obitos$M0020 == cod_uf))

  obitos |>
    mutate(
      cod_municipio = M0080,
      mes           = if_else(M0151 == 99, NA, M0151),
      sexo          = case_when(M0160 == 1 ~ "Homens",
                                M0160 == 2 ~ "Mulheres"),
      idade         = M0171
    ) |>
    group_by(cod_municipio, mes, sexo, idade) |>
    summarise(
      obitos    = sum(M0111),
      registros = n(),
      .groups   = "drop"
    )
}

# Converte o código do mês (1 = jan/2019) na data do primeiro dia do mês.
data_do_mes <- function(mes) {
  as.Date("2019-01-01") + months(mes - 1)
}


# Grupos de idade da tábua -------------------------------------------------

# A tábua abreviada usa os grupos 0, 1-4, 5-9, ..., 85-89 e 90+.
# Cada grupo é identificado pela idade em que começa (x).
inicio_dos_grupos <- c(0, 1, seq(5, 90, by = 5))

grupo_da_tabua <- function(idade) {
  posicao <- findInterval(idade, inicio_dos_grupos)
  inicio_dos_grupos[posicao]
}


# Tábua de vida abreviada --------------------------------------------------

# Fatores de separação das idades 0 e 1-4 (quanto, em média, vive no
# intervalo quem morre nele), pelo modelo de Coale-Demeny, como em Preston,
# Heuveline e Guillot (2001). Dependem da taxa de mortalidade infantil m0.
# Para ambos os sexos juntos, usa-se a média dos fatores de homens e mulheres.
fatores_separacao_infantil <- function(m0, sexo) {
  if (m0 >= 0.107) {
    homens   <- c(0.330, 1.352)
    mulheres <- c(0.350, 1.361)
  } else {
    homens   <- c(0.045 + 2.684 * m0, 1.651 - 2.816 * m0)
    mulheres <- c(0.053 + 2.800 * m0, 1.522 - 1.518 * m0)
  }

  if (sexo == "Homens")   return(homens)
  if (sexo == "Mulheres") return(mulheres)
  (homens + mulheres) / 2
}

# Monta a tábua de vida a partir dos óbitos e da população de cada grupo.
#
# `dados` tem uma linha por grupo de idade, com as colunas x (idade inicial),
# obitos e populacao. `sexo` é "Homens", "Mulheres" ou "Total".
#
# Notação das colunas, a mesma dos livros de demografia e atuária:
#   n    tamanho do grupo de idade, em anos
#   nMx  taxa específica de mortalidade
#   nax  anos vividos no grupo, em média, por quem morre nele
#   nqx  probabilidade de morrer no grupo
#   lx   sobreviventes na idade x, de uma coorte de 100.000 nascidos
#   ndx  mortes no grupo
#   nLx  anos vividos no grupo pela coorte
#   Tx   anos que a coorte ainda vai viver a partir da idade x
#   ex   esperança de vida na idade x
tabua_vida <- function(dados, sexo, raiz = 100000) {
  dados  <- arrange(dados, x)
  ultimo <- nrow(dados)  # o último grupo (90+) é aberto

  n <- c(diff(dados$x), Inf)

  m <- dados$obitos / dados$populacao

  # Nas idades 0 e 1-4 os fatores vêm do modelo; nas demais, supõe-se que
  # quem morre viveu metade do intervalo; no grupo aberto, a = 1 / m.
  a         <- n / 2
  a[1:2]    <- fatores_separacao_infantil(m[1], sexo)
  a[ultimo] <- 1 / m[ultimo]

  q         <- n * m / (1 + (n - a) * m)
  q         <- pmin(q, 1)
  q[ultimo] <- 1  # no grupo aberto, todos acabam morrendo

  l <- raiz * cumprod(c(1, 1 - q[-ultimo]))

  d <- l * q

  L         <- n * lead(l) + a * d
  L[ultimo] <- l[ultimo] / m[ultimo]

  Tx <- rev(cumsum(rev(L)))

  tibble(
    x         = dados$x,
    n         = n,
    obitos    = dados$obitos,
    populacao = dados$populacao,
    nMx       = m,
    nax       = a,
    nqx       = q,
    lx        = l,
    ndx       = d,
    nLx       = L,
    Tx        = Tx,
    ex        = Tx / l
  )
}
