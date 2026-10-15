# Passo 2 — Pirâmide etária do Rio Grande do Norte (Censo 2022)
#
# Usa a base gerada por R/filtrar_rn.R. Rode aquele script antes.
# Grupos de 5 anos até 90+, em % da população total do estado.

install.packages(c("censobr", "tidyverse"))

library(censobr)
library(tidyverse)

pessoas_rn <- read_rds("dados_rn/pessoas_rn.rds")


# Grupos de idade ----------------------------------------------------------

# right = FALSE fecha o intervalo à esquerda: [0, 5) = 0 a 4 anos.
limites <- c(seq(0, 90, by = 5), Inf)
rotulos <- c(paste(seq(0, 85, by = 5), seq(4, 89, by = 5), sep = "-"), "90+")

pessoas_rn <- pessoas_rn |>
  mutate(grupo_idade = cut(idade, breaks = limites, labels = rotulos,
                           right = FALSE))


# Percentuais --------------------------------------------------------------

# Cada sexo e grupo de idade como % da população total do RN, de modo que
# as barras de homens e mulheres somadas dão 100%.
piramide <- pessoas_rn |>
  count(grupo_idade, sexo, wt = peso, name = "populacao") |>
  mutate(percentual = 100 * populacao / sum(populacao))

# Conferência: a soma dos percentuais deve ser 100.
sum(piramide$percentual)

# Tabela no formato de leitura: um grupo por linha, um sexo por coluna.
piramide |>
  select(grupo_idade, sexo, percentual) |>
  pivot_wider(names_from = sexo, values_from = percentual)


# Gráfico ------------------------------------------------------------------

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

grafico <- ggplot(dados_grafico, aes(x = valor, y = grupo_idade, fill = sexo)) +
  geom_col(width = 0.82) +
  # Percentual na ponta de cada barra, afastado um pouco para fora.
  geom_text(aes(x = valor + lado * 0.12, label = rotulo,
                hjust = if_else(lado < 0, 1, 0)),
            size = 3, colour = "grey35") +
  geom_vline(xintercept = 0, colour = "grey20", linewidth = 0.4) +
  # Nome de cada sexo no topo do seu lado, no lugar da legenda.
  annotate("text", x = c(-2.5, 2.5), y = length(rotulos) + 1.2,
           label = c("Homens", "Mulheres"), colour = cores,
           fontface = "bold", size = 4.5) +
  scale_x_continuous(labels = \(x) paste0(abs(x), "%"),
                     breaks = seq(-5, 5, by = 1),
                     expand = expansion(mult = 0.02)) +
  scale_y_discrete(expand = expansion(add = c(0.6, 1.6))) +
  scale_fill_manual(values = cores, guide = "none") +
  coord_cartesian(xlim = c(-5, 5), clip = "off") +
  labs(
    title    = "Pirâmide etária do Rio Grande do Norte, 2022",
    subtitle = paste0("Percentual da população total (",
                      format(round(populacao_total), big.mark = "."),
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

grafico

# Pasta só para os gráficos do projeto.
dir.create("graficos", showWarnings = FALSE)
ggsave("graficos/piramide_etaria_rn.png", grafico,
       width = 9, height = 8, dpi = 300, bg = "white")
