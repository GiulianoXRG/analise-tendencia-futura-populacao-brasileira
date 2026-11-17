# Passo 1 — População, pirâmides etárias e indicadores de dependência
#
# Para cada UF:
#   1. soma a população por município, sexo e idade;
#   2. monta a pirâmide etária em grupos de 5 anos;
#   3. calcula as razões de dependência e o índice de envelhecimento.
#
# Uso, com a raiz do projeto como diretório de trabalho:
#   Rscript R/01_populacao.R             todas as UFs
#   Rscript R/01_populacao.R PB PE       só as UFs indicadas
#   Rscript R/01_populacao.R --refazer   lê os microdados de novo
#
# Fonte: microdados de acesso controlado do IBGE, no zip da raiz do projeto.
# Não compartilhe as pastas dados/; divulgue só os resultados agregados.

source("R/carregar_funcoes.R")

opcoes <- ler_opcoes()


# 1. População de cada UF --------------------------------------------------

# Lê dos microdados as UFs que ainda não foram lidas.
siglas <- atualizar_cache(opcoes, "populacao.rds", agregar_pessoas_uf)
criar_pastas(siglas)

populacao <- ler_cache(siglas, "populacao.rds")

# O zip só traz o código do município. O nome vem da base pública de setores
# censitários de 2022 do pacote censobr (baixada uma vez e guardada em cache).
municipios <- censobr::read_tracts(year = 2022, dataset = "Basico") |>
  distinct(code_muni, name_muni) |>
  collect() |>
  transmute(cod_municipio = as.integer(code_muni),
            municipio     = name_muni)

populacao <- left_join(populacao, municipios, by = "cod_municipio")

# Conferência: nenhum município pode ficar sem nome.
stopifnot(!anyNA(populacao$municipio))


# 2. Pirâmides etárias -----------------------------------------------------

piramides <- populacao |>
  group_by(sigla) |>
  group_modify(function(dados_uf, grupo) calcular_piramide(dados_uf)) |>
  ungroup()

# Conferência: em cada UF os percentuais somam 100.
soma_por_uf <- summarise(piramides, total = sum(percentual), .by = sigla)
stopifnot(all(abs(soma_por_uf$total - 100) < 1e-8))

# Todas as pirâmides usam o mesmo eixo, para poderem ser comparadas: o maior
# percentual entre as UFs, arredondado para cima (no mínimo 5%, como no RN).
limite_x <- max(5, ceiling(max(piramides$percentual)))

for (sigla_uf in siglas) {
  grafico <- piramides |>
    filter(sigla == sigla_uf) |>
    grafico_piramide(nome_da_uf(sigla_uf), limite_x)

  salvar_grafico(grafico, pasta_uf(sigla_uf, "graficos", "piramide_etaria.png"))
}

piramides |>
  left_join(ufs, by = "sigla") |>
  transmute(
    cod_uf, sigla,
    uf          = nome,
    grupo_idade, sexo,
    populacao   = round(populacao),
    percentual  = round(percentual, 2)
  ) |>
  salvar_tabela("piramides")


# 3. Razões de dependência e índice de envelhecimento ----------------------

indicadores <- populacao |>
  group_by(sigla) |>
  group_modify(function(dados_uf, grupo) calcular_indicadores(dados_uf)) |>
  ungroup() |>
  left_join(ufs, by = "sigla") |>
  select(cod_uf, sigla, uf = nome, everything()) |>
  arrange(cod_uf)

# A linha do Brasil só faz sentido quando todas as UFs foram lidas.
if (setequal(siglas, ufs$sigla)) {
  brasil <- calcular_indicadores(populacao) |>
    mutate(sigla = "BR", uf = "Brasil")

  indicadores <- bind_rows(indicadores, brasil)
}

indicadores <- indicadores |>
  mutate(
    populacao = round(populacao),
    across(razao_dependencia_jovem:indice_envelhecimento,
           function(valor) round(valor, 1))
  )

salvar_tabela(indicadores, "indicadores")

salvar_grafico(grafico_dependencia(indicadores),
               pasta_brasil("graficos", "dependencia_ufs.png"))

print(indicadores, n = Inf, width = Inf)
