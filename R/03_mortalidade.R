# Passo 3 — Mortalidade: óbitos, taxas e tábuas de vida
#
#   1. soma os óbitos de moradores de cada UF por sexo, idade e mês
#      (janeiro de 2019 a julho de 2022);
#   2. para os 12 meses antes do Censo (agosto de 2021 a julho de 2022),
#      calcula as taxas de mortalidade por idade e a tábua de vida abreviada
#      de cada UF, por sexo;
#   3. resume por UF: óbitos, taxa bruta de mortalidade e esperança de vida.
#
# Rode depois de R/01_populacao.R, que gera a população usada nas taxas.
#
# Uso, com a raiz do projeto como diretório de trabalho:
#   Rscript R/03_mortalidade.R             todas as UFs
#   Rscript R/03_mortalidade.R PB PE       só as UFs indicadas
#   Rscript R/03_mortalidade.R --refazer   lê os microdados de novo
#
# Atenção: os óbitos do Censo são informados pelos moradores que ficaram no
# domicílio. Não aparecem, por exemplo, as mortes de quem morava sozinho, e
# por isso o Censo capta menos óbitos que o registro civil. As taxas aqui
# não têm correção desse sub-registro: a mortalidade sai subestimada e a
# esperança de vida, superestimada.
#
# Fonte: microdados de acesso controlado do IBGE, no zip da raiz do projeto.
# Não compartilhe as pastas dados/; divulgue só os resultados agregados.

source("R/carregar_funcoes.R")

opcoes <- ler_opcoes()

# Os 12 meses antes da data de referência do Censo (31/07/2022):
# 32 = agosto de 2021, ..., 43 = julho de 2022.
meses_referencia <- 32:43


# 1. Óbitos de cada UF -----------------------------------------------------

siglas_com_obitos    <- atualizar_cache(opcoes, "obitos.rds", agregar_obitos_uf)
siglas_com_populacao <- ufs$sigla[file.exists(pasta_uf(ufs$sigla, "dados",
                                                       "populacao.rds"))]

if (length(siglas_com_populacao) == 0) {
  stop("Rode antes R/01_populacao.R para gerar a população de cada UF.")
}

siglas    <- intersect(siglas_com_obitos, siglas_com_populacao)
todas_ufs <- setequal(siglas, ufs$sigla)
criar_pastas(siglas)

obitos    <- ler_cache(siglas, "obitos.rds")
populacao <- ler_cache(siglas, "populacao.rds")


# Série mensal de óbitos ---------------------------------------------------

# Todos os óbitos com mês conhecido, inclusive os de sexo ou idade ignorados.
obitos |>
  filter(!is.na(mes)) |>
  count(sigla, mes, wt = obitos, name = "obitos") |>
  mutate(mes = data_do_mes(mes), obitos = round(obitos)) |>
  salvar_tabela("obitos_mensais")


# 2. Taxas e tábuas de vida ------------------------------------------------

obitos_no_periodo <- filter(obitos, mes %in% meses_referencia)

# Óbitos com sexo ou idade ignorados são redistribuídos proporcionalmente
# entre os de sexo e idade conhecidos, dentro de cada UF: cada óbito
# conhecido é multiplicado por `fator` = total / conhecidos.
redistribuicao <- obitos_no_periodo |>
  summarise(
    total     = sum(obitos),
    conhecido = sum(obitos[!is.na(sexo) & !is.na(idade)]),
    .by       = sigla
  ) |>
  mutate(fator = total / conhecido)

obitos_por_grupo <- obitos_no_periodo |>
  filter(!is.na(sexo), !is.na(idade)) |>
  left_join(select(redistribuicao, sigla, fator), by = "sigla") |>
  mutate(x = grupo_da_tabua(idade)) |>
  count(sigla, sexo, x, wt = obitos * fator, name = "obitos")

populacao_por_grupo <- populacao |>
  mutate(x = grupo_da_tabua(idade)) |>
  count(sigla, sexo, x, wt = populacao, name = "populacao")

# Uma linha por UF, sexo e grupo de idade, com óbitos e população.
base_tabuas <- full_join(obitos_por_grupo, populacao_por_grupo,
                         by = c("sigla", "sexo", "x")) |>
  mutate(obitos = replace_na(obitos, 0))

# Acrescenta "Total" (os dois sexos somados) para cada UF...
ambos_os_sexos <- base_tabuas |>
  summarise(across(c(obitos, populacao), sum), .by = c(sigla, x)) |>
  mutate(sexo = "Total")

base_tabuas <- bind_rows(base_tabuas, ambos_os_sexos)

# ...e o Brasil (todas as UFs somadas), quando todas foram lidas.
if (todas_ufs) {
  brasil <- base_tabuas |>
    summarise(across(c(obitos, populacao), sum), .by = c(sexo, x)) |>
    mutate(sigla = "BR")

  base_tabuas <- bind_rows(base_tabuas, brasil)
}

tabuas <- base_tabuas |>
  group_by(sigla, sexo) |>
  group_modify(function(dados, grupo) tabua_vida(dados, grupo$sexo)) |>
  ungroup()

# Conferências: toda tábua começa em 100.000 e termina com nqx = 1, e os
# óbitos redistribuídos somam o total de óbitos do período.
stopifnot(
  all(tabuas$lx[tabuas$x == 0] == 100000),
  all(tabuas$nqx[tabuas$x == max(tabuas$x)] == 1),
  all(tabuas$nqx >= 0 & tabuas$nqx <= 1),
  isTRUE(all.equal(sum(obitos_por_grupo$obitos), sum(redistribuicao$total)))
)

tabuas |>
  mutate(
    n = if_else(is.infinite(n), NA, n),
    across(c(obitos, populacao, lx, ndx, nLx, Tx), round),
    across(c(nMx, nqx), function(valor) signif(valor, 5)),
    across(c(nax, ex),  function(valor) round(valor, 2))
  ) |>
  salvar_tabela("tabuas_vida")


# 3. Resumo por UF ---------------------------------------------------------

# Percentual de óbitos com sexo ou idade ignorados, por UF e no Brasil.
ignorados <- redistribuicao |>
  select(sigla, total, conhecido)

if (todas_ufs) {
  ignorados <- bind_rows(
    ignorados,
    summarise(ignorados, across(c(total, conhecido), sum)) |>
      mutate(sigla = "BR")
  )
}

ignorados <- ignorados |>
  transmute(sigla, pct_ignorado = 100 * (1 - conhecido / total))

# Esperança de vida ao nascer (e0) e aos 60 anos (e60), por sexo.
esperanca_de_vida <- tabuas |>
  filter(x %in% c(0, 60)) |>
  transmute(sigla,
            coluna = paste0("e", x, "_", str_to_lower(sexo)),
            ex) |>
  pivot_wider(names_from = coluna, values_from = ex)

mortalidade <- base_tabuas |>
  filter(sexo == "Total") |>
  summarise(obitos    = sum(obitos),
            populacao = sum(populacao),
            .by       = sigla) |>
  mutate(taxa_bruta_mortalidade = 1000 * obitos / populacao) |>
  left_join(ignorados,         by = "sigla") |>
  left_join(esperanca_de_vida, by = "sigla") |>
  left_join(select(ufs, sigla, cod_uf, uf = nome), by = "sigla") |>
  mutate(uf = replace_na(uf, "Brasil")) |>
  select(cod_uf, sigla, uf, obitos, populacao, taxa_bruta_mortalidade,
         pct_ignorado,
         e0_total, e0_homens, e0_mulheres,
         e60_total, e60_homens, e60_mulheres) |>
  arrange(is.na(cod_uf), cod_uf) |>
  mutate(
    across(c(obitos, populacao), round),
    across(c(taxa_bruta_mortalidade, pct_ignorado, e0_total:e60_mulheres),
           function(valor) round(valor, 1))
  )

# Conferência: a população bate com a do passo 1.
conferir_populacao(mortalidade)

salvar_tabela(mortalidade, "mortalidade")


# Gráficos -----------------------------------------------------------------

salvar_grafico(grafico_esperanca_vida(tabuas),
               pasta_brasil("graficos", "esperanca_vida_ufs.png"))

for (sigla_uf in siglas) {
  tabua_da_uf <- filter(tabuas, sigla == sigla_uf)

  salvar_grafico(grafico_curva_mortalidade(tabua_da_uf, nome_da_uf(sigla_uf)),
                 pasta_uf(sigla_uf, "graficos", "curva_mortalidade.png"),
                 altura = 6)
}

if (todas_ufs) {
  tabua_do_brasil <- filter(tabuas, sigla == "BR")

  salvar_grafico(grafico_curva_mortalidade(tabua_do_brasil, "Brasil"),
                 pasta_brasil("graficos", "curva_mortalidade.png"),
                 altura = 6)
}

mortalidade |>
  select(sigla, obitos, taxa_bruta_mortalidade, pct_ignorado,
         e0_total, e0_homens, e0_mulheres, e60_total) |>
  print(n = Inf, width = Inf)
