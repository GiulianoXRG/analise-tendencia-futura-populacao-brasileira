# Análise automatizada de todas as UFs (Censo 2022, amostra)
#
# Repete para cada unidade da federação os passos feitos para o RN:
#   1. agrega as pessoas da UF por município, sexo e idade;
#   2. pirâmide etária em grupos de 5 anos (gráfico em graficos/piramides/);
#   3. razões de dependência e índice de envelhecimento.
# E junta tudo em tabelas comparativas em resultados/.
#
# Uso, com a raiz do projeto como diretório de trabalho:
#   Rscript R/analise_todas_ufs.R            # todas as UFs
#   Rscript R/analise_todas_ufs.R PB PE CE   # agrega só as UFs indicadas
#   Rscript R/analise_todas_ufs.R --refazer  # ignora o que já foi agregado
#
# A etapa lenta (ler o CSV de cada UF) só roda uma vez: a agregação fica salva
# em dados_ufs/ e é reaproveitada nas execuções seguintes.
#
# Fonte: microdados de acesso controlado do IBGE, no zip da raiz do projeto.
# Não compartilhe dados_ufs/; divulgue só os resultados agregados por UF.

pacotes <- c("censobr", "data.table", "tidyverse")
faltando <- pacotes[!vapply(pacotes, requireNamespace, logical(1),
                            quietly = TRUE)]
if (length(faltando) > 0) install.packages(faltando)

library(censobr)
source("R/funcoes_uf.R")


# Configuração -------------------------------------------------------------

argumentos <- commandArgs(trailingOnly = TRUE)
refazer    <- "--refazer" %in% argumentos
siglas     <- toupper(setdiff(argumentos, "--refazer"))
if (length(siglas) == 0) siglas <- ufs$sigla

desconhecidas <- setdiff(siglas, ufs$sigla)
if (length(desconhecidas) > 0) {
  stop("UF desconhecida: ", paste(desconhecidas, collapse = ", "))
}

zip_censo <- list.files(pattern = "^microdados_censo_amostra_2022.*\\.zip$")[1]
if (is.na(zip_censo)) stop("Zip dos microdados não encontrado na raiz.")

dir.create("dados_ufs", showWarnings = FALSE)
dir.create("graficos/piramides", showWarnings = FALSE, recursive = TRUE)
dir.create("resultados", showWarnings = FALSE)


# Passo 1 — agregação de cada UF (com cache) -------------------------------

arquivo_uf <- \(sigla) file.path("dados_ufs", paste0("populacao_", sigla,
                                                     ".rds"))

for (sigla_uf in siglas) {
  uf <- filter(ufs, sigla == sigla_uf)
  if (file.exists(arquivo_uf(sigla_uf)) && !refazer) next

  inicio <- Sys.time()
  populacao <- agregar_pessoas_uf(uf$cod_uf, zip_censo)
  write_rds(populacao, arquivo_uf(sigla_uf))
  milhar <- \(x) format(round(x), big.mark = ".", decimal.mark = ",")
  message(sprintf("%s: %s registros, %s pessoas (%.0f s)", sigla_uf,
                  milhar(sum(populacao$registros)),
                  milhar(sum(populacao$populacao)),
                  as.numeric(Sys.time() - inicio, units = "secs")))
}

# Os resultados usam todas as UFs já agregadas, e não só as pedidas nesta
# execução, para que rodar uma UF avulsa não apague as tabelas das demais.
siglas <- ufs$sigla[file.exists(arquivo_uf(ufs$sigla))]

populacao_ufs <- map(siglas, \(s) read_rds(arquivo_uf(s))) |>
  set_names(siglas) |>
  list_rbind(names_to = "sigla")


# Nome dos municípios ------------------------------------------------------

# O zip só traz o código do município. O nome vem da base pública de setores
# censitários de 2022 do censobr (baixada uma vez e guardada em cache).
municipios <- read_tracts(year = 2022, dataset = "Basico") |>
  distinct(code_muni, name_muni) |>
  collect() |>
  transmute(cod_municipio = as.integer(code_muni), municipio = name_muni)

populacao_ufs <- populacao_ufs |>
  left_join(municipios, by = "cod_municipio")

# Conferência: nenhum município deve ficar sem nome.
stopifnot(!anyNA(populacao_ufs$municipio))


# Passo 2 — pirâmides etárias ----------------------------------------------

piramides <- populacao_ufs |>
  group_by(sigla) |>
  group_modify(\(dados, chave) calcular_piramide(dados)) |>
  ungroup()

# Conferência: em cada UF os percentuais somam 100.
stopifnot(piramides |>
            summarise(total = sum(percentual), .by = sigla) |>
            pull(total) |>
            all.equal(rep(100, length(siglas))) |>
            isTRUE())

# Mesmo eixo em todas as pirâmides (o maior % entre as UFs, arredondado para
# cima), para que possam ser comparadas lado a lado. Mínimo de 5%, como no RN.
limite_x <- max(5, ceiling(max(piramides$percentual)))

for (sigla_uf in siglas) {
  uf <- filter(ufs, sigla == sigla_uf)
  grafico <- piramides |>
    filter(sigla == sigla_uf) |>
    grafico_piramide(uf$nome, limite_x)
  ggsave(sprintf("graficos/piramides/piramide_etaria_%s.png",
                 tolower(sigla_uf)),
         grafico, width = 9, height = 8, dpi = 300, bg = "white")
}

piramides |>
  left_join(ufs, by = "sigla") |>
  select(cod_uf, sigla, uf = nome, grupo_idade, sexo, populacao,
         percentual) |>
  mutate(percentual = round(percentual, 2), populacao = round(populacao)) |>
  write_csv("resultados/piramides_ufs.csv")


# Passo 3 — indicadores de dependência -------------------------------------

indicadores <- populacao_ufs |>
  group_by(sigla) |>
  group_modify(\(dados, chave) calcular_indicadores(dados)) |>
  ungroup() |>
  left_join(ufs, by = "sigla") |>
  select(cod_uf, sigla, uf = nome, everything()) |>
  arrange(cod_uf)

# Brasil: só faz sentido quando todas as UFs foram processadas.
if (setequal(siglas, ufs$sigla)) {
  indicadores <- indicadores |>
    bind_rows(calcular_indicadores(populacao_ufs) |>
                mutate(sigla = "BR", uf = "Brasil"))
}

indicadores <- indicadores |>
  mutate(populacao = round(populacao),
         across(razao_dependencia_jovem:indice_envelhecimento,
                \(x) round(x, 1)))

write_csv(indicadores, "resultados/indicadores_ufs.csv")
print(indicadores, n = Inf, width = Inf)


# Gráfico comparativo ------------------------------------------------------

# Razão de dependência total de cada UF, dividida em jovem e idosa, ordenada
# do maior para o menor índice de envelhecimento.
comparativo <- indicadores |>
  filter(sigla != "BR") |>
  mutate(sigla = fct_reorder(sigla, indice_envelhecimento)) |>
  pivot_longer(c(razao_dependencia_jovem, razao_dependencia_idosa),
               names_to = "componente", values_to = "valor") |>
  mutate(componente = if_else(componente == "razao_dependencia_jovem",
                              "Jovens (0-14)", "Idosos (65+)"),
         componente = fct_relevel(componente, "Idosos (65+)"))

grafico_comparativo <- ggplot(comparativo,
                              aes(x = valor, y = sigla, fill = componente)) +
  geom_col(width = 0.75) +
  scale_fill_manual(values = c("Jovens (0-14)" = "#2a78d6",
                               "Idosos (65+)"  = "#eb6834"),
                    breaks = c("Jovens (0-14)", "Idosos (65+)")) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.03))) +
  labs(
    title    = "Razão de dependência por UF, 2022",
    subtitle = paste("Dependentes por 100 pessoas de 15 a 64 anos;",
                     "UFs ordenadas pelo índice de envelhecimento"),
    x = NULL, y = NULL, fill = NULL,
    caption  = "Fonte: IBGE, Censo Demográfico 2022, microdados da amostra."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title         = element_text(face = "bold", size = 15),
    plot.subtitle      = element_text(colour = "grey35"),
    plot.caption       = element_text(colour = "grey45", size = 9),
    plot.title.position   = "plot",
    plot.caption.position = "plot",
    legend.position    = "top",
    legend.justification = "left",
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank()
  )

ggsave("graficos/dependencia_ufs.png", grafico_comparativo,
       width = 9, height = 8, dpi = 300, bg = "white")
