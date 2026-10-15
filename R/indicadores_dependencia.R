# Passo 3 — Razões de dependência e índice de envelhecimento do RN (Censo 2022)
#
# Usa a base gerada por R/filtrar_rn.R. Rode aquele script antes.
#
# Grandes grupos etários (convenção usual, também adotada pelo IBGE):
#   jovens = 0 a 14 anos | idade ativa = 15 a 64 anos | idosos = 65 anos ou mais
#
# Todos os indicadores são expressos por 100 pessoas:
#   razão de dependência jovem  = jovens / idade ativa x 100
#   razão de dependência idosa  = idosos / idade ativa x 100
#   razão de dependência total  = (jovens + idosos) / idade ativa x 100
#   índice de envelhecimento    = idosos / jovens x 100

install.packages(c("censobr", "tidyverse"))

library(censobr)
library(tidyverse)

pessoas_rn <- read_rds("dados_rn/pessoas_rn.rds")


# Grandes grupos etários ---------------------------------------------------

populacao_grupos <- pessoas_rn |>
  mutate(grupo = case_when(
    idade <= 14 ~ "jovens",
    idade <= 64 ~ "ativos",
    TRUE        ~ "idosos"
  )) |>
  count(grupo, wt = peso, name = "populacao") |>
  pivot_wider(names_from = grupo, values_from = populacao)

# Conferência: os três grupos somam a população do RN (3.302.729).
populacao_grupos |>
  mutate(total = jovens + ativos + idosos)


# Indicadores --------------------------------------------------------------

indicadores <- populacao_grupos |>
  transmute(
    razao_dependencia_jovem = 100 * jovens / ativos,
    razao_dependencia_idosa = 100 * idosos / ativos,
    razao_dependencia_total = 100 * (jovens + idosos) / ativos,
    indice_envelhecimento   = 100 * idosos / jovens
  ) |>
  pivot_longer(everything(), names_to = "indicador", values_to = "valor") |>
  mutate(valor = round(valor, 1))

indicadores
