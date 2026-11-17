# Gráficos do projeto
#
# Todos os gráficos usam o mesmo tema e as mesmas cores, definidos no início
# do arquivo.


# Tema, cores e fonte ------------------------------------------------------

cores_sexo <- c(Homens = "#2a78d6", Mulheres = "#eb6834")

fonte_censo <- "Fonte: IBGE, Censo Demográfico 2022, microdados da amostra."

fonte_censo_obitos <- paste(fonte_censo,
                            "Sem correção do sub-registro de óbitos.")

tema_projeto <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title            = element_text(face = "bold", size = 15),
      plot.subtitle         = element_text(colour = "grey35"),
      plot.caption          = element_text(colour = "grey45", size = 9),
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      panel.grid.minor      = element_blank()
    )
}

legenda_no_topo <- function() {
  theme(legend.position = "top", legend.justification = "left")
}

sem_linhas_horizontais <- function() {
  theme(panel.grid.major.y = element_blank())
}

# Salva um gráfico em PNG, sempre com fundo branco. Os gráficos dos
# municípios usam dpi menor, para os arquivos não ficarem pesados.
salvar_grafico <- function(grafico, arquivo, largura = 9, altura = 8,
                           dpi = 300) {
  ggsave(arquivo, grafico, width = largura, height = altura,
         dpi = dpi, bg = "white")
}

# "de" + artigo para os títulos: "do Pará", "da Bahia", "de Goiás".
artigo_uf <- function(nome_uf) {
  case_when(
    nome_uf %in% c("Alagoas", "Goiás", "Mato Grosso", "Mato Grosso do Sul",
                   "Minas Gerais", "Pernambuco", "Rondônia", "Roraima",
                   "Santa Catarina", "São Paulo", "Sergipe") ~ "de",
    nome_uf %in% c("Bahia", "Paraíba") ~ "da",
    TRUE ~ "do"
  )
}


# Pirâmide etária ----------------------------------------------------------

# `limite_x` é o percentual máximo do eixo. Usar o mesmo valor em todas as
# UFs deixa as pirâmides comparáveis entre si.
#
# O título padrão é o da UF ("Pirâmide etária do Pará, 2022"); para um
# município, passe o título pronto em `titulo`.
grafico_piramide <- function(piramide, nome_uf, limite_x = 5, titulo = NULL) {
  populacao_total <- sum(piramide$populacao)

  # Os homens ficam com valores negativos só para serem desenhados à
  # esquerda; os rótulos e o eixo mostram o valor sem o sinal.
  dados <- piramide |>
    mutate(
      lado   = if_else(sexo == "Homens", -1, 1),
      valor  = lado * percentual,
      rotulo = format(round(percentual, 1), decimal.mark = ",", nsmall = 1)
    )

  if (is.null(titulo)) {
    titulo <- paste0("Pirâmide etária ", artigo_uf(nome_uf), " ", nome_uf,
                     ", 2022")
  }

  subtitulo <- paste0("Percentual da população total (",
                      formatar_milhar(populacao_total),
                      " pessoas) por sexo e grupo de idade")

  ggplot(dados, aes(x = valor, y = grupo_idade, fill = sexo)) +
    geom_col(width = 0.82) +

    # Percentual na ponta de cada barra, um pouco afastado dela.
    geom_text(
      aes(x     = valor + lado * 0.024 * limite_x,
          label = rotulo,
          hjust = if_else(lado < 0, 1, 0)),
      size = 3, colour = "grey35"
    ) +

    geom_vline(xintercept = 0, colour = "grey20", linewidth = 0.4) +

    # Nome de cada sexo no topo do seu lado, no lugar da legenda.
    annotate("text",
             x        = c(-1, 1) * limite_x / 2,
             y        = length(rotulos_idade) + 1.2,
             label    = c("Homens", "Mulheres"),
             colour   = cores_sexo,
             fontface = "bold",
             size     = 4.5) +

    scale_x_continuous(
      labels = function(x) paste0(abs(x), "%"),
      breaks = seq(-limite_x, limite_x, by = 1),
      expand = expansion(mult = 0.02)
    ) +
    scale_y_discrete(expand = expansion(add = c(0.6, 1.6))) +
    scale_fill_manual(values = cores_sexo, guide = "none") +
    coord_cartesian(xlim = c(-limite_x, limite_x), clip = "off") +

    labs(title = titulo, subtitle = subtitulo, caption = fonte_censo,
         x = NULL, y = NULL) +

    tema_projeto() +
    sem_linhas_horizontais() +
    theme(
      plot.subtitle      = element_text(colour = "grey35",
                                        margin = margin(b = 10)),
      axis.text.y        = element_text(colour = "grey20"),
      axis.text.x        = element_text(colour = "grey45"),
      panel.grid.major.x = element_line(colour = "grey92", linewidth = 0.3),
      plot.margin        = margin(15, 20, 10, 15)
    )
}


# Razão de dependência por UF ----------------------------------------------

# Barras com a razão de dependência total de cada UF, divididas em jovens e
# idosos, com as UFs ordenadas pelo índice de envelhecimento.
grafico_dependencia <- function(indicadores) {
  dados <- indicadores |>
    filter(sigla != "BR") |>
    mutate(sigla = fct_reorder(sigla, indice_envelhecimento)) |>
    pivot_longer(c(razao_dependencia_jovem, razao_dependencia_idosa),
                 names_to = "componente", values_to = "valor") |>
    mutate(
      componente = if_else(componente == "razao_dependencia_jovem",
                           "Jovens (0-14)", "Idosos (65+)"),
      componente = fct_relevel(componente, "Idosos (65+)")
    )

  cores <- c("Jovens (0-14)" = "#2a78d6", "Idosos (65+)" = "#eb6834")

  ggplot(dados, aes(x = valor, y = sigla, fill = componente)) +
    geom_col(width = 0.75) +
    scale_fill_manual(values = cores,
                      breaks = c("Jovens (0-14)", "Idosos (65+)")) +
    scale_x_continuous(expand = expansion(mult = c(0, 0.03))) +
    labs(
      title    = "Razão de dependência por UF, 2022",
      subtitle = paste("Dependentes por 100 pessoas de 15 a 64 anos;",
                       "UFs ordenadas pelo índice de envelhecimento"),
      caption  = fonte_censo,
      x = NULL, y = NULL, fill = NULL
    ) +
    tema_projeto() +
    legenda_no_topo() +
    sem_linhas_horizontais()
}


# Saldo migratório por UF --------------------------------------------------

grafico_saldo_migratorio <- function(indicadores_migracao) {
  dados <- indicadores_migracao |>
    mutate(
      sigla = fct_reorder(sigla, taxa_liquida_migracao),
      sinal = if_else(taxa_liquida_migracao >= 0, "Ganha", "Perde")
    )

  ggplot(dados, aes(x = taxa_liquida_migracao, y = sigla, fill = sinal)) +
    geom_col(width = 0.75) +
    geom_vline(xintercept = 0, colour = "grey20", linewidth = 0.4) +
    scale_fill_manual(values = c(Ganha = "#2a78d6", Perde = "#eb6834"),
                      guide = "none") +
    scale_x_continuous(breaks = seq(-100, 100, by = 20)) +
    labs(
      title    = "Saldo migratório entre UFs, 2022",
      subtitle = paste("Entradas menos saídas por 1.000 habitantes, entre",
                       "quem mudou de município há menos de 10 anos"),
      caption  = fonte_censo,
      x = NULL, y = NULL
    ) +
    tema_projeto() +
    sem_linhas_horizontais()
}


# Esperança de vida por UF -------------------------------------------------

# Um ponto para homens e outro para mulheres, ligados por uma linha, com as
# UFs ordenadas pela esperança de vida de ambos os sexos.
grafico_esperanca_vida <- function(tabuas) {
  dados <- tabuas |>
    filter(x == 0, sigla != "BR") |>
    select(sigla, sexo, ex) |>
    pivot_wider(names_from = sexo, values_from = ex) |>
    mutate(sigla = fct_reorder(sigla, Total))

  ggplot(dados, aes(y = sigla)) +
    geom_segment(aes(x = Homens, xend = Mulheres, yend = sigla),
                 colour = "grey80", linewidth = 1.2) +
    geom_point(aes(x = Homens,   colour = "Homens"),   size = 2.6) +
    geom_point(aes(x = Mulheres, colour = "Mulheres"), size = 2.6) +
    scale_colour_manual(values = cores_sexo) +
    labs(
      title    = "Esperança de vida ao nascer por UF, 2021-2022",
      subtitle = paste("Anos, a partir dos óbitos de ago/2021 a jul/2022",
                       "informados no Censo"),
      caption  = fonte_censo_obitos,
      x = NULL, y = NULL, colour = NULL
    ) +
    tema_projeto() +
    legenda_no_topo() +
    sem_linhas_horizontais()
}


# Curva de mortalidade -----------------------------------------------------

# Taxas específicas de mortalidade por idade e sexo, em escala log.
# `tabua` são as tábuas de vida de um só lugar (UF ou município).
grafico_curva_mortalidade <- function(tabua, nome) {
  # Grupos sem nenhum óbito (taxa zero) não aparecem na escala log.
  dados <- tabua |>
    filter(sexo != "Total", nMx > 0) |>
    mutate(idade_media = if_else(is.infinite(n), x + 2.5, x + n / 2))

  formatar_eixo <- function(v) {
    format(v, big.mark = ".", decimal.mark = ",",
           scientific = FALSE, drop0trailing = TRUE)
  }

  ggplot(dados, aes(x = idade_media, y = 1000 * nMx, colour = sexo)) +
    geom_line(linewidth = 0.9) +
    geom_point(size = 1.8) +
    scale_y_log10(labels = formatar_eixo) +
    scale_x_continuous(breaks = seq(0, 90, by = 10)) +
    scale_colour_manual(values = cores_sexo) +
    labs(
      title    = paste0("Taxas específicas de mortalidade, ", nome,
                        ", 2021-2022"),
      subtitle = paste("Óbitos por 1.000 habitantes em cada grupo de idade",
                       "(escala log)"),
      caption  = fonte_censo_obitos,
      x = "Idade", y = NULL, colour = NULL
    ) +
    tema_projeto() +
    legenda_no_topo()
}


# Mapa dos municípios ------------------------------------------------------

# Pinta cada município pelo valor de `coluna`.
#
# `tipo = "sequencial"` vai do azul claro (menor) ao azul escuro (maior);
# `tipo = "divergente"` usa laranja para negativos, azul para positivos e
# branco no zero (bom para saldos).
grafico_mapa <- function(malha, coluna, titulo, subtitulo,
                         tipo = "sequencial", fonte = fonte_censo) {
  formatar_legenda <- function(v) {
    format(v, decimal.mark = ",", big.mark = ".", trim = TRUE)
  }

  if (tipo == "divergente") {
    maior_distancia <- max(abs(malha[[coluna]]), na.rm = TRUE)

    escala <- scale_fill_gradient2(
      low      = "#eb6834",
      mid      = "white",
      high     = "#2a78d6",
      midpoint = 0,
      limits   = c(-maior_distancia, maior_distancia),
      labels   = formatar_legenda
    )
  } else {
    escala <- scale_fill_gradient(
      low    = "#e3eefb",
      high   = "#123f7a",
      labels = formatar_legenda
    )
  }

  ggplot(malha) +
    geom_sf(aes(fill = .data[[coluna]]), colour = "white", linewidth = 0.15) +
    escala +
    labs(title = titulo, subtitle = subtitulo, caption = fonte, fill = NULL) +
    tema_projeto() +
    theme(
      axis.text        = element_blank(),
      panel.grid.major = element_blank(),
      legend.position  = "bottom",
      legend.key.width = unit(2.5, "cm")
    )
}
