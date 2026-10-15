# Funções da análise por UF (Censo 2022, amostra)
#
# Generalizam os passos 1 a 3 feitos para o RN (filtrar, pirâmide etária e
# indicadores de dependência) para qualquer unidade da federação.
# São carregadas por R/analise_todas_ufs.R; não precisam ser rodadas sozinhas.

library(data.table)
library(tidyverse)


# Unidades da federação ----------------------------------------------------

# Código IBGE, sigla e nome. O código é o nome da pasta de cada UF no zip.
ufs <- tribble(
  ~cod_uf, ~sigla, ~nome,
  11, "RO", "Rondônia",
  12, "AC", "Acre",
  13, "AM", "Amazonas",
  14, "RR", "Roraima",
  15, "PA", "Pará",
  16, "AP", "Amapá",
  17, "TO", "Tocantins",
  21, "MA", "Maranhão",
  22, "PI", "Piauí",
  23, "CE", "Ceará",
  24, "RN", "Rio Grande do Norte",
  25, "PB", "Paraíba",
  26, "PE", "Pernambuco",
  27, "AL", "Alagoas",
  28, "SE", "Sergipe",
  29, "BA", "Bahia",
  31, "MG", "Minas Gerais",
  32, "ES", "Espírito Santo",
  33, "RJ", "Rio de Janeiro",
  35, "SP", "São Paulo",
  41, "PR", "Paraná",
  42, "SC", "Santa Catarina",
  43, "RS", "Rio Grande do Sul",
  50, "MS", "Mato Grosso do Sul",
  51, "MT", "Mato Grosso",
  52, "GO", "Goiás",
  53, "DF", "Distrito Federal"
)


# Passo 1 — leitura e agregação --------------------------------------------

# Lê o CSV de pessoas de uma UF e devolve a população (soma dos pesos) por
# município, sexo e idade simples.
#
# Por eficiência:
#   - extrai do zip só o arquivo de pessoas da UF, e o apaga ao terminar;
#   - o data.table::fread lê só as 5 colunas usadas, com várias threads;
#   - os microdados são agregados logo após a leitura, então o que fica em
#     memória e em disco é uma tabela pequena (município x sexo x idade), e
#     não um registro por pessoa.
#
# P0020 = código da UF | P0080 = código do município | P0160 = sexo
# P0181 = idade em anos completos | P0111 = peso amostral
agregar_pessoas_uf <- function(cod_uf, zip_censo) {
  csv_uf  <- sprintf("%d/Pessoas_%d_controlado.csv", cod_uf, cod_uf)
  pasta   <- file.path(tempdir(), "censo")
  unzip(zip_censo, files = csv_uf, exdir = pasta)
  caminho <- file.path(pasta, csv_uf)
  on.exit(unlink(caminho), add = TRUE)

  pessoas <- fread(
    caminho,
    sep        = ";",
    select     = c(P0020 = "integer", P0080 = "integer", P0160 = "integer",
                   P0181 = "integer", P0111 = "double"),
    showProgress = FALSE
  )

  # Conferência: o arquivo da UF só deve ter pessoas daquela UF.
  stopifnot(all(pessoas$P0020 == cod_uf), !anyNA(pessoas$P0181))

  pessoas[, .(populacao = sum(P0111), registros = .N),
          by = .(cod_municipio = P0080, sexo = P0160, idade = P0181)] |>
    as_tibble() |>
    mutate(sexo = if_else(sexo == 1, "Homens", "Mulheres"))
}


# Passo 2 — pirâmide etária ------------------------------------------------

# right = FALSE fecha o intervalo à esquerda: [0, 5) = 0 a 4 anos.
limites_idade <- c(seq(0, 90, by = 5), Inf)
rotulos_idade <- c(paste(seq(0, 85, by = 5), seq(4, 89, by = 5), sep = "-"),
                   "90+")

# Cada sexo e grupo de idade como % da população total da UF, de modo que
# as barras de homens e mulheres somadas dão 100%.
calcular_piramide <- function(populacao) {
  populacao |>
    mutate(grupo_idade = cut(idade, breaks = limites_idade,
                             labels = rotulos_idade, right = FALSE)) |>
    count(grupo_idade, sexo, wt = populacao, name = "populacao") |>
    mutate(percentual = 100 * populacao / sum(populacao))
}

# Mesmo gráfico do RN. `limite_x` é o % máximo do eixo; usar o mesmo valor
# em todas as UFs deixa as pirâmides comparáveis entre si.
grafico_piramide <- function(piramide, nome_uf, limite_x = 5) {
  cores <- c(Homens = "#2a78d6", Mulheres = "#eb6834")
  populacao_total <- sum(piramide$populacao)

  # Os homens ficam com valores negativos só para desenhar à esquerda;
  # os rótulos e o eixo mostram o valor absoluto.
  dados_grafico <- piramide |>
    mutate(
      lado   = if_else(sexo == "Homens", -1, 1),
      valor  = lado * percentual,
      rotulo = format(round(percentual, 1), decimal.mark = ",", nsmall = 1)
    )

  ggplot(dados_grafico, aes(x = valor, y = grupo_idade, fill = sexo)) +
    geom_col(width = 0.82) +
    # Percentual na ponta de cada barra, afastado um pouco para fora.
    geom_text(aes(x = valor + lado * 0.024 * limite_x, label = rotulo,
                  hjust = if_else(lado < 0, 1, 0)),
              size = 3, colour = "grey35") +
    geom_vline(xintercept = 0, colour = "grey20", linewidth = 0.4) +
    # Nome de cada sexo no topo do seu lado, no lugar da legenda.
    annotate("text", x = c(-1, 1) * limite_x / 2,
             y = length(rotulos_idade) + 1.2,
             label = c("Homens", "Mulheres"), colour = cores,
             fontface = "bold", size = 4.5) +
    scale_x_continuous(labels = \(x) paste0(abs(x), "%"),
                       breaks = seq(-limite_x, limite_x, by = 1),
                       expand = expansion(mult = 0.02)) +
    scale_y_discrete(expand = expansion(add = c(0.6, 1.6))) +
    scale_fill_manual(values = cores, guide = "none") +
    coord_cartesian(xlim = c(-limite_x, limite_x), clip = "off") +
    labs(
      title    = paste0("Pirâmide etária ", artigo_uf(nome_uf), " ", nome_uf,
                        ", 2022"),
      subtitle = paste0("Percentual da população total (",
                        format(round(populacao_total), big.mark = ".",
                               decimal.mark = ","),
                        " pessoas) por sexo e grupo de idade"),
      x = NULL, y = NULL,
      caption  = "Fonte: IBGE, Censo Demográfico 2022, microdados da amostra."
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title         = element_text(face = "bold", size = 15),
      plot.subtitle      = element_text(colour = "grey35",
                                        margin = margin(b = 10)),
      plot.caption       = element_text(colour = "grey45", size = 9),
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      axis.text.y        = element_text(colour = "grey20"),
      axis.text.x        = element_text(colour = "grey45"),
      panel.grid.major.y = element_blank(),
      panel.grid.minor   = element_blank(),
      panel.grid.major.x = element_line(colour = "grey92", linewidth = 0.3),
      plot.margin        = margin(15, 20, 10, 15)
    )
}

# Contração de "de" + artigo para o título ("do Pará", "da Bahia", "de Goiás").
artigo_uf <- function(nome_uf) {
  case_when(
    nome_uf %in% c("Alagoas", "Goiás", "Mato Grosso", "Mato Grosso do Sul",
                   "Minas Gerais", "Pernambuco", "Rondônia", "Roraima",
                   "Santa Catarina", "São Paulo", "Sergipe") ~ "de",
    nome_uf %in% c("Bahia", "Paraíba") ~ "da",
    TRUE ~ "do"
  )
}


# Passo 3 — razões de dependência e índice de envelhecimento ---------------

# jovens = 0 a 14 anos | idade ativa = 15 a 64 anos | idosos = 65 anos ou mais
# Todos os indicadores são expressos por 100 pessoas.
calcular_indicadores <- function(populacao) {
  populacao |>
    mutate(grupo = case_when(
      idade <= 14 ~ "jovens",
      idade <= 64 ~ "ativos",
      TRUE        ~ "idosos"
    )) |>
    count(grupo, wt = populacao, name = "populacao") |>
    pivot_wider(names_from = grupo, values_from = populacao) |>
    transmute(
      populacao               = jovens + ativos + idosos,
      razao_dependencia_jovem = 100 * jovens / ativos,
      razao_dependencia_idosa = 100 * idosos / ativos,
      razao_dependencia_total = 100 * (jovens + idosos) / ativos,
      indice_envelhecimento   = 100 * idosos / jovens
    )
}
