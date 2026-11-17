# Passo 5 — READMEs das UFs e dos municípios
#
# Escreve:
#   ufs/<sigla>/README.md                  resultados da UF, ao lado do Brasil
#   ufs/<sigla>/municipios/README.md       mapas e tabela de todos os
#                                          municípios da UF (se o passo 4
#                                          rodou para ela)
#   ufs/<sigla>/municipios/<nome>/README.md  resultados de cada município, ao
#                                          lado da UF
# Tudo é lido das tabelas salvas pelos passos 1 a 4.
#
# Rode depois dos passos 1 a 4 (R/rodar_tudo.R já faz isso).

source("R/carregar_funcoes.R")


# Funções de apoio ---------------------------------------------------------

ler_resultado_uf <- function(sigla, arquivo) {
  read_csv(pasta_uf(sigla, "resultados", arquivo), show_col_types = FALSE)
}

existe_resultado_uf <- function(sigla, arquivo) {
  file.exists(pasta_uf(sigla, "resultados", arquivo))
}

# Número com sinal: +249, -37.339.
formatar_com_sinal <- function(x, formatar) {
  paste0(if_else(x > 0, "+", ""), formatar(x))
}

# Monta uma tabela em Markdown a partir de um data frame já formatado.
# `alinhamento` tem um item por coluna: "---" (esquerda) ou "--:" (direita).
tabela_markdown <- function(dados, alinhamento) {
  cabecalho  <- paste0("| ", paste(names(dados), collapse = " | "), " |")
  separador  <- paste0("|", paste(alinhamento, collapse = "|"), "|")
  linhas     <- apply(dados, 1, function(linha) {
    paste0("| ", paste(linha, collapse = " | "), " |")
  })

  c(cabecalho, separador, linhas)
}


# Valores do Brasil, para comparação ---------------------------------------

indicadores_brasil <- ler_tabela_brasil("indicadores_ufs.csv") |>
  filter(sigla == "BR")

mortalidade_brasil <- NULL
if (file.exists(pasta_brasil("resultados", "mortalidade_ufs.csv"))) {
  mortalidade_brasil <- ler_tabela_brasil("mortalidade_ufs.csv") |>
    filter(sigla == "BR")
}


# Seções do README ---------------------------------------------------------

secao_estrutura_etaria <- function(sigla, nome) {
  uf     <- ler_resultado_uf(sigla, "indicadores.csv")
  brasil <- indicadores_brasil

  tabela <- tibble(
    Indicador = c("Razão de dependência jovem",
                  "Razão de dependência idosa",
                  "Razão de dependência total",
                  "Índice de envelhecimento"),
    UF = formatar_decimal(c(uf$razao_dependencia_jovem,
                            uf$razao_dependencia_idosa,
                            uf$razao_dependencia_total,
                            uf$indice_envelhecimento)),
    Brasil = formatar_decimal(c(brasil$razao_dependencia_jovem,
                                brasil$razao_dependencia_idosa,
                                brasil$razao_dependencia_total,
                                brasil$indice_envelhecimento))
  ) |>
    rename(!!sigla := UF)

  c(
    paste0("População: **", formatar_milhar(uf$populacao), "** pessoas."),
    "",
    "## Estrutura etária",
    "",
    paste0("![Pirâmide etária ", artigo_uf(nome), " ", nome,
           "](graficos/piramide_etaria.png)"),
    "",
    tabela_markdown(tabela, c("---", "--:", "--:")),
    "",
    "Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;",
    "idosos: 65 ou mais."
  )
}

secao_migracao <- function(sigla) {
  uf     <- ler_resultado_uf(sigla, "migracao.csv")
  fluxos <- ler_resultado_uf(sigla, "fluxos_migracao.csv")

  tabela <- tibble(
    Indicador = c("Nascidos na própria UF",
                  "Nascidos em outra UF",
                  "Nascidos no exterior",
                  "Entradas de outras UFs (últimos 10 anos)",
                  "Saídas para outras UFs (últimos 10 anos)",
                  "Saldo migratório entre UFs",
                  "Saldo por 1.000 habitantes"),
    Valor = c(paste0(formatar_decimal(uf$pct_naturais), "%"),
              paste0(formatar_decimal(uf$pct_outra_uf), "%"),
              paste0(formatar_decimal(uf$pct_exterior), "%"),
              formatar_milhar(uf$imigrantes_interestaduais),
              formatar_milhar(uf$emigrantes_interestaduais),
              formatar_com_sinal(uf$saldo_interestadual, formatar_milhar),
              formatar_com_sinal(uf$taxa_liquida_migracao, formatar_decimal))
  )

  # As 5 UFs de onde mais gente veio e as 5 para onde mais gente foi.
  cinco_maiores <- function(sentido_do_fluxo) {
    fluxos |>
      filter(sentido == sentido_do_fluxo) |>
      slice_max(migrantes, n = 5)
  }

  chegaram <- cinco_maiores("entrada")
  sairam   <- cinco_maiores("saida")

  principais <- tibble(
    Origem   = chegaram$origem,
    Chegaram = formatar_milhar(chegaram$migrantes),
    Destino  = sairam$destino,
    Saíram   = formatar_milhar(sairam$migrantes)
  )

  c(
    "## Migração",
    "",
    tabela_markdown(tabela, c("---", "--:")),
    "",
    "Principais origens de quem chegou e destinos de quem saiu (últimos 10",
    "anos):",
    "",
    tabela_markdown(principais, c("---", "--:", "---", "--:"))
  )
}

secao_mortalidade <- function(sigla, nome) {
  uf <- ler_resultado_uf(sigla, "mortalidade.csv")

  valores <- function(tabela) {
    c(formatar_milhar(tabela$obitos),
      formatar_decimal(c(tabela$taxa_bruta_mortalidade,
                         tabela$e0_total,
                         tabela$e0_homens,
                         tabela$e0_mulheres,
                         tabela$e60_total)))
  }

  tabela <- tibble(
    Indicador = c("Óbitos no período",
                  "Taxa bruta de mortalidade (por mil)",
                  "Esperança de vida ao nascer, total",
                  "Esperança de vida ao nascer, homens",
                  "Esperança de vida ao nascer, mulheres",
                  "Esperança de vida aos 60 anos, total"),
    UF     = valores(uf),
    Brasil = if (is.null(mortalidade_brasil)) "" else valores(mortalidade_brasil)
  ) |>
    rename(!!sigla := UF)

  c(
    "## Mortalidade",
    "",
    "Óbitos de agosto de 2021 a julho de 2022 informados no Censo.",
    "",
    tabela_markdown(tabela, c("---", "--:", "--:")),
    "",
    paste("**Atenção:** sem correção do sub-registro de óbitos do Censo;",
          "a mortalidade está subestimada e a esperança de vida,",
          "superestimada."),
    "",
    paste0("![Taxas específicas de mortalidade ", artigo_uf(nome), " ", nome,
           "](graficos/curva_mortalidade.png)")
  )
}

secao_arquivos <- function(sigla) {
  descricoes <- c(
    "indicadores.csv"     = "razões de dependência e índice de envelhecimento",
    "piramides.csv"       = "população por sexo e grupo de idade (pirâmide)",
    "migracao.csv"        = "naturalidade e saldo migratório",
    "naturalidade.csv"    = "moradores por UF de nascimento",
    "fluxos_migracao.csv" = "entradas e saídas por UF de origem/destino",
    "mortalidade.csv"     = "óbitos, taxa bruta e esperança de vida",
    "tabuas_vida.csv"     = "tábuas de vida abreviadas por sexo",
    "obitos_mensais.csv"  = "óbitos por mês, jan/2019 a jul/2022"
  )

  linhas <- c("## Arquivos", "")

  for (arquivo in names(descricoes)) {
    if (existe_resultado_uf(sigla, arquivo)) {
      linhas <- c(linhas, paste0("- [`resultados/", arquivo, "`](resultados/",
                                 arquivo, "): ", descricoes[[arquivo]]))
    }
  }

  if (dir.exists(pasta_municipios(sigla))) {
    linhas <- c(linhas,
                paste("- [`municipios/`](municipios/): os mesmos resultados",
                      "para cada município da UF, com mapas"))
  }

  if (dir.exists(pasta_uf(sigla, "roteiro"))) {
    linhas <- c(linhas,
                paste("- [`roteiro/`](roteiro/): primeira etapa do projeto,",
                      "a análise passo a passo feita só para esta UF"))
  }

  linhas
}


# Escrever o README de cada UF ---------------------------------------------

for (sigla in ufs$sigla) {
  if (!existe_resultado_uf(sigla, "indicadores.csv")) {
    next
  }

  nome <- nome_da_uf(sigla)

  readme <- c(
    paste0("# ", nome, " (", sigla, ")"),
    "",
    paste("Resultados do Censo Demográfico 2022 (microdados da amostra) para",
          "esta UF. Gerado por `R/05_readmes.R`; veja o",
          "[README principal](../../README.md) para a metodologia."),
    "",
    secao_estrutura_etaria(sigla, nome)
  )

  if (existe_resultado_uf(sigla, "migracao.csv")) {
    readme <- c(readme, "", secao_migracao(sigla))
  }

  if (existe_resultado_uf(sigla, "mortalidade.csv")) {
    readme <- c(readme, "", secao_mortalidade(sigla, nome))
  }

  readme <- c(readme, "", secao_arquivos(sigla))

  escrever_texto(readme, pasta_uf(sigla, "README.md"))
}


# READMEs dos municípios ---------------------------------------------------

ler_resultado_municipios <- function(sigla_uf, arquivo) {
  read_csv(pasta_municipios(sigla_uf, "resultados", arquivo),
           show_col_types = FALSE)
}

# Página de um município, com os valores da UF ao lado.
readme_municipio <- function(municipio, sigla_uf, uf, dados) {
  codigo <- municipio$cod_municipio
  nome   <- paste0(municipio$municipio, " (", sigla_uf, ")")

  ind <- filter(dados$indicadores, cod_municipio == codigo)
  mig <- filter(dados$migracao,    cod_municipio == codigo)
  mor <- filter(dados$mortalidade, cod_municipio == codigo)

  # Estrutura etária
  tabela_idade <- tibble(
    Indicador = c("Razão de dependência jovem",
                  "Razão de dependência idosa",
                  "Razão de dependência total",
                  "Índice de envelhecimento"),
    Municipio = formatar_decimal(c(ind$razao_dependencia_jovem,
                                   ind$razao_dependencia_idosa,
                                   ind$razao_dependencia_total,
                                   ind$indice_envelhecimento)),
    UF = formatar_decimal(c(uf$indicadores$razao_dependencia_jovem,
                            uf$indicadores$razao_dependencia_idosa,
                            uf$indicadores$razao_dependencia_total,
                            uf$indicadores$indice_envelhecimento))
  ) |>
    rename(!!municipio$municipio := Municipio, !!sigla_uf := UF)

  # Migração
  tabela_migracao <- tibble(
    Indicador = c("Nascidos no próprio município",
                  paste("Nascidos em outro município", artigo_uf(uf$nome),
                        uf$nome),
                  "Nascidos em outra UF",
                  "Nascidos no exterior",
                  paste("Chegaram de outro município", artigo_uf(uf$nome),
                        uf$nome),
                  "Chegaram de outra UF",
                  "Saíram para outro município da UF",
                  "Saíram para outra UF",
                  "Saldo migratório",
                  "Saldo por 1.000 habitantes",
                  "Chegaram do exterior"),
    Valor = c(paste0(formatar_decimal(c(mig$pct_naturais_municipio,
                                        mig$pct_outro_municipio_uf,
                                        mig$pct_outra_uf,
                                        mig$pct_exterior)), "%"),
              formatar_milhar(c(mig$entradas_mesma_uf, mig$entradas_outra_uf,
                                mig$saidas_mesma_uf, mig$saidas_outra_uf)),
              formatar_com_sinal(mig$saldo_migratorio, formatar_milhar),
              formatar_com_sinal(mig$taxa_liquida_migracao, formatar_decimal),
              formatar_milhar(mig$vindos_exterior))
  )

  # Os 5 lugares de onde mais gente veio e para onde mais gente foi.
  chegaram <- dados$fluxos |>
    filter(destino_cod == codigo) |>
    slice_max(migrantes, n = 5, with_ties = FALSE)
  sairam <- dados$fluxos |>
    filter(origem_cod == codigo) |>
    slice_max(migrantes, n = 5, with_ties = FALSE)

  # As duas colunas podem ter tamanhos diferentes; completa com vazio.
  linhas_fluxo <- max(nrow(chegaram), nrow(sairam))
  completar    <- function(x) c(x, rep("", linhas_fluxo - length(x)))

  tabela_fluxos <- tibble(
    Origem   = completar(chegaram$origem),
    Chegaram = completar(formatar_milhar(chegaram$migrantes)),
    Destino  = completar(sairam$destino),
    Saíram   = completar(formatar_milhar(sairam$migrantes))
  )

  # Mortalidade. A população padrão da taxa padronizada é a da própria UF,
  # então na UF a taxa padronizada é igual à bruta.
  tabela_mortalidade <- tibble(
    Indicador = c("Óbitos no período",
                  "Registros de óbito na amostra",
                  "Taxa bruta de mortalidade (por mil)",
                  "Taxa padronizada por idade (por mil)"),
    Municipio = c(formatar_milhar(mor$obitos),
                  formatar_milhar(mor$registros_obitos),
                  formatar_decimal(mor$taxa_bruta_mortalidade),
                  formatar_decimal(mor$taxa_padronizada_mortalidade)),
    UF = c(formatar_milhar(uf$mortalidade$obitos),
           "",
           formatar_decimal(uf$mortalidade$taxa_bruta_mortalidade),
           formatar_decimal(uf$mortalidade$taxa_bruta_mortalidade))
  )

  tem_tabua <- !is.na(mor$e0_total)

  if (tem_tabua) {
    esperanca <- tibble(
      Indicador = c("Esperança de vida ao nascer, total",
                    "Esperança de vida ao nascer, homens",
                    "Esperança de vida ao nascer, mulheres",
                    "Esperança de vida aos 60 anos, total"),
      Municipio = formatar_decimal(c(mor$e0_total, mor$e0_homens,
                                     mor$e0_mulheres, mor$e60_total)),
      UF = formatar_decimal(c(uf$mortalidade$e0_total,
                              uf$mortalidade$e0_homens,
                              uf$mortalidade$e0_mulheres,
                              uf$mortalidade$e60_total))
    )
    tabela_mortalidade <- bind_rows(tabela_mortalidade, esperanca)
  }

  tabela_mortalidade <- tabela_mortalidade |>
    rename(!!municipio$municipio := Municipio, !!sigla_uf := UF)

  if (tem_tabua) {
    nota_mortalidade <- c(
      paste("A tábua de vida usa poucos registros de óbito da amostra e deve",
            "ser lida como aproximada. Sem correção do sub-registro de",
            "óbitos do Censo."),
      "",
      paste0("![Taxas específicas de mortalidade de ", nome,
             "](curva_mortalidade.png)")
    )
  } else {
    nota_mortalidade <- paste(
      "Com poucos óbitos na amostra, as taxas deste município variam muito",
      "por acaso; por isso não há tábua de vida. Sem correção do",
      "sub-registro de óbitos do Censo."
    )
  }

  c(
    paste0("# ", nome),
    "",
    paste("Resultados do Censo Demográfico 2022 (microdados da amostra).",
          "Gerado por `R/05_readmes.R`; veja a",
          "[página dos municípios](../README.md) e o",
          "[README principal](../../../../README.md)."),
    "",
    paste0("População: **", formatar_milhar(ind$populacao), "** pessoas (",
           formatar_milhar(ind$registros), " registros na amostra)."),
    "",
    "## Estrutura etária",
    "",
    paste0("![Pirâmide etária de ", nome, "](piramide_etaria.png)"),
    "",
    tabela_markdown(tabela_idade, c("---", "--:", "--:")),
    "",
    "Valores por 100 pessoas.",
    "",
    "## Migração",
    "",
    "Chegadas e saídas: mudanças de município nos últimos 10 anos.",
    "",
    tabela_markdown(tabela_migracao, c("---", "--:")),
    "",
    "Principais origens de quem chegou e destinos de quem saiu:",
    "",
    tabela_markdown(tabela_fluxos, c("---", "--:", "---", "--:")),
    "",
    "## Mortalidade",
    "",
    "Óbitos de agosto de 2021 a julho de 2022 informados no Censo.",
    "",
    tabela_markdown(tabela_mortalidade, c("---", "--:", "--:")),
    "",
    nota_mortalidade
  )
}

# Página com os mapas e a tabela de todos os municípios da UF.
readme_municipios_uf <- function(sigla_uf, nome_uf, municipios, dados) {
  resumo <- municipios |>
    left_join(select(dados$indicadores, cod_municipio, populacao,
                     razao_dependencia_total, indice_envelhecimento),
              by = "cod_municipio") |>
    left_join(select(dados$migracao, cod_municipio, pct_naturais_municipio,
                     taxa_liquida_migracao),
              by = "cod_municipio") |>
    left_join(select(dados$mortalidade, cod_municipio, obitos),
              by = "cod_municipio")

  tabela <- tibble(
    "Município"                 = paste0("[", resumo$municipio, "](",
                                         resumo$pasta, "/)"),
    "População"                 = formatar_milhar(resumo$populacao),
    "Dependência total"         = formatar_decimal(resumo$razao_dependencia_total),
    "Índice de envelhecimento"  = formatar_decimal(resumo$indice_envelhecimento),
    "Nascidos no município (%)" = formatar_decimal(resumo$pct_naturais_municipio),
    "Saldo migratório por mil"  = formatar_com_sinal(resumo$taxa_liquida_migracao,
                                                     formatar_decimal),
    "Óbitos (12 meses)"         = formatar_milhar(resumo$obitos)
  )

  arquivos <- c(
    "indicadores_municipios.csv"     = "dependência e envelhecimento",
    "piramides_municipios.csv"       = "população por sexo e grupo de idade",
    "migracao_municipios.csv"        = "naturalidade, entradas, saídas e saldo",
    "fluxos_migracao_municipios.csv" = "fluxos entre municípios",
    "mortalidade_municipios.csv"     = "óbitos e taxas bruta e padronizada",
    "tabuas_vida_municipios.csv"     = "tábuas de vida dos municípios grandes"
  )

  c(
    paste0("# Municípios ", artigo_uf(nome_uf), " ", nome_uf),
    "",
    paste0("Resultados do Censo Demográfico 2022 (microdados da amostra) ",
           "para os ", nrow(municipios), " municípios ", artigo_uf(nome_uf),
           " ", nome_uf, ". Gerado por `R/05_readmes.R`. Cada município ",
           "tem sua própria página, com pirâmide etária, migração e ",
           "mortalidade."),
    "",
    paste("**Cuidados:** nos municípios pequenos os valores vêm de poucos",
          "registros da amostra (as tabelas mostram quantos). A mortalidade",
          "municipal varia muito por acaso e não tem correção do",
          "sub-registro de óbitos; por isso ela não está nos mapas, e a",
          "tábua de vida só foi feita para os municípios com 100 mil",
          "habitantes ou mais."),
    "",
    "## Mapas",
    "",
    "![Índice de envelhecimento](graficos/mapa_indice_envelhecimento.png)",
    "",
    "![Razão de dependência total](graficos/mapa_razao_dependencia.png)",
    "",
    paste0("![Moradores nascidos no próprio município]",
           "(graficos/mapa_naturais_municipio.png)"),
    "",
    "![Saldo migratório](graficos/mapa_saldo_migratorio.png)",
    "",
    "## Todos os municípios",
    "",
    tabela_markdown(tabela, c("---", rep("--:", 6))),
    "",
    "## Arquivos",
    "",
    paste0("- [`resultados/", names(arquivos), "`](resultados/",
           names(arquivos), "): ", arquivos)
  )
}

for (sigla_uf in ufs$sigla) {
  arquivo_indicadores <- pasta_municipios(sigla_uf, "resultados",
                                          "indicadores_municipios.csv")
  if (!file.exists(arquivo_indicadores)) {
    next
  }

  dados <- list(
    indicadores = ler_resultado_municipios(sigla_uf,
                                           "indicadores_municipios.csv"),
    migracao    = ler_resultado_municipios(sigla_uf,
                                           "migracao_municipios.csv"),
    mortalidade = ler_resultado_municipios(sigla_uf,
                                           "mortalidade_municipios.csv"),
    fluxos      = ler_resultado_municipios(sigla_uf,
                                           "fluxos_migracao_municipios.csv")
  )

  uf <- list(
    nome        = nome_da_uf(sigla_uf),
    indicadores = ler_resultado_uf(sigla_uf, "indicadores.csv"),
    mortalidade = ler_resultado_uf(sigla_uf, "mortalidade.csv")
  )

  # A pasta de cada município é o nome dele sem acentos (veja
  # nome_para_pasta() em R/funcoes/municipios.R).
  municipios <- dados$indicadores |>
    select(cod_municipio, municipio) |>
    mutate(pasta = nome_para_pasta(municipio)) |>
    arrange(municipio, .locale = "pt")

  for (i in seq_len(nrow(municipios))) {
    municipio <- municipios[i, ]
    escrever_texto(readme_municipio(municipio, sigla_uf, uf, dados),
                pasta_municipios(sigla_uf, municipio$pasta, "README.md"))
  }

  escrever_texto(readme_municipios_uf(sigla_uf, uf$nome, municipios, dados),
              pasta_municipios(sigla_uf, "README.md"))
}
