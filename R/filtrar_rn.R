# Passo 1 — Filtrar as pessoas do Rio Grande do Norte no Censo 2022 (amostra)
#
# Fonte: microdados de acesso controlado do IBGE, no zip da raiz do projeto.
# Não compartilhe a base gerada aqui; divulgue só resultados agregados.

install.packages(c("censobr", "tidyverse"))

library(censobr)
library(tidyverse)


# Extração do CSV do RN ----------------------------------------------------

# O zip traz uma pasta por UF; o RN é a 24. Extraímos só o arquivo de
# pessoas dela para uma pasta temporária, sem descompactar o Brasil todo.
zip_censo <- list.files(pattern = "^microdados_censo_amostra_2022.*\\.zip$")[1]
csv_rn    <- "24/Pessoas_24_controlado.csv"

unzip(zip_censo, files = csv_rn, exdir = tempdir())


# Leitura e filtro ---------------------------------------------------------

# P0020 = código da UF (24 = RN)
# P0080 = código do município
# P0160 = sexo (1 = homem, 2 = mulher)
# P0181 = idade em anos completos
# P0111 = peso amostral (quantas pessoas cada registro representa)
pessoas_rn <- read_delim(
  file.path(tempdir(), csv_rn),
  delim      = ";",
  col_select = c(P0020, P0080, P0160, P0181, P0111),
  col_types  = cols(.default = col_double())
) |>
  filter(P0020 == 24) |>
  transmute(
    cod_municipio = P0080,
    sexo  = if_else(P0160 == 1, "Homens", "Mulheres"),
    idade = P0181,
    peso  = P0111
  )


# Nome dos municípios ------------------------------------------------------

# O zip só traz o código do município. O nome vem da base pública de setores
# censitários de 2022 do censobr (baixada uma vez e guardada em cache).
municipios_rn <- read_tracts(year = 2022, dataset = "Basico") |>
  filter(code_state == 24) |>
  distinct(code_muni, name_muni) |>
  collect() |>
  rename(cod_municipio = code_muni, municipio = name_muni)

pessoas_rn <- pessoas_rn |>
  left_join(municipios_rn, by = "cod_municipio") |>
  relocate(municipio, .after = cod_municipio)


# Conferência --------------------------------------------------------------

# A soma dos pesos deve bater com a população do RN no Censo 2022 (3.302.729).
pessoas_rn |>
  summarise(registros = n(), populacao = sum(peso))

pessoas_rn |>
  count(sexo, wt = peso, name = "populacao")

# O RN tem 167 municípios, e nenhum registro deve ficar sem nome.
n_distinct(pessoas_rn$municipio)
sum(is.na(pessoas_rn$municipio))


# Salvar -------------------------------------------------------------------

dir.create("dados_rn", showWarnings = FALSE)
write_rds(pessoas_rn, "dados_rn/pessoas_rn.rds")
