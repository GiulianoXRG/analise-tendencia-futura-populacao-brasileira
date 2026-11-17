# Configuração geral do projeto
#
# Lista das UFs, pastas onde cada coisa é salva, opções da linha de comando,
# cache das bases por UF e formatação de números.


# Unidades da federação ----------------------------------------------------

# Código do IBGE, sigla e nome de cada UF.
# O código também é o nome da pasta da UF dentro do zip dos microdados.
ufs <- tribble(
  ~cod_uf, ~sigla, ~nome,
  11,      "RO",   "Rondônia",
  12,      "AC",   "Acre",
  13,      "AM",   "Amazonas",
  14,      "RR",   "Roraima",
  15,      "PA",   "Pará",
  16,      "AP",   "Amapá",
  17,      "TO",   "Tocantins",
  21,      "MA",   "Maranhão",
  22,      "PI",   "Piauí",
  23,      "CE",   "Ceará",
  24,      "RN",   "Rio Grande do Norte",
  25,      "PB",   "Paraíba",
  26,      "PE",   "Pernambuco",
  27,      "AL",   "Alagoas",
  28,      "SE",   "Sergipe",
  29,      "BA",   "Bahia",
  31,      "MG",   "Minas Gerais",
  32,      "ES",   "Espírito Santo",
  33,      "RJ",   "Rio de Janeiro",
  35,      "SP",   "São Paulo",
  41,      "PR",   "Paraná",
  42,      "SC",   "Santa Catarina",
  43,      "RS",   "Rio Grande do Sul",
  50,      "MS",   "Mato Grosso do Sul",
  51,      "MT",   "Mato Grosso",
  52,      "GO",   "Goiás",
  53,      "DF",   "Distrito Federal"
)

codigo_da_uf <- function(sigla) {
  ufs$cod_uf[match(sigla, ufs$sigla)]
}

sigla_da_uf <- function(codigo) {
  ufs$sigla[match(codigo, ufs$cod_uf)]
}

nome_da_uf <- function(sigla) {
  ufs$nome[match(sigla, ufs$sigla)]
}


# Pastas -------------------------------------------------------------------

# Cada UF tem uma pasta em ufs/<sigla>/ com três subpastas:
#   graficos/    gráficos da UF
#   resultados/  tabelas da UF (CSV)
#   dados/       bases tiradas dos microdados (só no computador, fora do git)
#
# As comparações entre UFs e os totais do Brasil ficam em brasil/.

pasta_uf <- function(sigla, ...) {
  file.path("ufs", tolower(sigla), ...)
}

pasta_brasil <- function(...) {
  file.path("brasil", ...)
}

criar_pasta <- function(caminho) {
  dir.create(caminho, showWarnings = FALSE, recursive = TRUE)
}

criar_pastas <- function(siglas) {
  for (sigla in siglas) {
    criar_pasta(pasta_uf(sigla, "graficos"))
    criar_pasta(pasta_uf(sigla, "resultados"))
    criar_pasta(pasta_uf(sigla, "dados"))
  }

  criar_pasta(pasta_brasil("graficos"))
  criar_pasta(pasta_brasil("resultados"))
}


# Opções da linha de comando -----------------------------------------------

# Lê o que foi passado ao rodar o script:
#   Rscript R/01_populacao.R             todas as UFs
#   Rscript R/01_populacao.R PB PE       só as UFs indicadas
#   Rscript R/01_populacao.R --refazer   lê os microdados de novo
#
# `siglas_padrao` são as UFs usadas quando nenhuma sigla é informada.
ler_opcoes <- function(siglas_padrao = ufs$sigla) {
  argumentos <- commandArgs(trailingOnly = TRUE)

  refazer <- "--refazer" %in% argumentos
  siglas  <- toupper(setdiff(argumentos, "--refazer"))

  if (length(siglas) == 0) {
    siglas <- siglas_padrao
  }

  desconhecidas <- setdiff(siglas, ufs$sigla)
  if (length(desconhecidas) > 0) {
    stop("UF desconhecida: ", paste(desconhecidas, collapse = ", "))
  }

  # O zip do IBGE fica na raiz do projeto, sem descompactar.
  zip_censo <- list.files(pattern = "^microdados_censo_amostra_2022.*\\.zip$")[1]

  list(siglas = siglas, refazer = refazer, zip_censo = zip_censo)
}


# Cache das bases por UF ---------------------------------------------------

# Ler os microdados é a parte demorada. Por isso o resultado de cada UF é
# salvo em ufs/<sigla>/dados/<nome_arquivo> e só é calculado de novo se o
# arquivo não existir ou se o script for rodado com --refazer.
#
# `calcular` é a função que recebe o código da UF e o zip e devolve a tabela.
# A função devolve as siglas de todas as UFs que já têm o arquivo pronto.
atualizar_cache <- function(opcoes, nome_arquivo, calcular) {
  for (sigla in opcoes$siglas) {
    arquivo <- pasta_uf(sigla, "dados", nome_arquivo)

    if (file.exists(arquivo) && !opcoes$refazer) {
      next
    }

    if (is.na(opcoes$zip_censo)) {
      stop("Zip dos microdados não encontrado na raiz do projeto.")
    }

    criar_pastas(sigla)
    inicio <- Sys.time()

    tabela <- calcular(codigo_da_uf(sigla), opcoes$zip_censo)

    if (endsWith(arquivo, ".parquet")) {
      arrow::write_parquet(tabela, arquivo)
    } else {
      write_rds(tabela, arquivo)
    }

    segundos <- as.numeric(Sys.time() - inicio, units = "secs")
    message(sprintf("%s: %s salvo (%.0f s)", sigla, nome_arquivo, segundos))
  }

  ufs$sigla[file.exists(pasta_uf(ufs$sigla, "dados", nome_arquivo))]
}

# Junta as bases .rds das UFs indicadas em uma só tabela, com a coluna sigla.
ler_cache <- function(siglas, nome_arquivo) {
  tabelas <- list()

  for (sigla in siglas) {
    tabelas[[sigla]] <- read_rds(pasta_uf(sigla, "dados", nome_arquivo))
  }

  bind_rows(tabelas, .id = "sigla")
}


# Salvar tabelas -----------------------------------------------------------

# Salva uma tabela que tem a coluna `sigla` em dois lugares:
#   brasil/resultados/<nome>_ufs.csv   a tabela completa, com todas as UFs
#   ufs/<sigla>/resultados/<nome>.csv  só as linhas de cada UF
salvar_tabela <- function(tabela, nome) {
  write_csv(tabela, pasta_brasil("resultados", paste0(nome, "_ufs.csv")))

  siglas_na_tabela <- intersect(unique(tabela$sigla), ufs$sigla)

  for (sigla_uf in siglas_na_tabela) {
    linhas_da_uf <- filter(tabela, sigla == sigla_uf)
    arquivo_uf   <- pasta_uf(sigla_uf, "resultados", paste0(nome, ".csv"))
    write_csv(linhas_da_uf, arquivo_uf)
  }
}

# Escreve um arquivo de texto (como um README). No Windows, o antivírus ou
# o indexador às vezes seguram o arquivo por um instante e a escrita falha;
# por isso tenta de novo algumas vezes antes de desistir.
escrever_texto <- function(linhas, arquivo, tentativas = 5) {
  for (tentativa in seq_len(tentativas)) {
    ok <- tryCatch({
      write_lines(linhas, arquivo)
      TRUE
    }, error = function(erro) {
      if (tentativa == tentativas) stop(erro)
      FALSE
    })

    if (ok) return(invisible(arquivo))
    Sys.sleep(0.5)
  }
}

# Lê uma das tabelas salvas por salvar_tabela() com todas as UFs.
ler_tabela_brasil <- function(nome) {
  read_csv(pasta_brasil("resultados", nome), show_col_types = FALSE)
}

# Confere se a população de uma tabela bate com a calculada em
# R/01_populacao.R (diferença de no máximo 1 pessoa, por arredondamento).
conferir_populacao <- function(tabela) {
  referencia <- ler_tabela_brasil("indicadores_ufs.csv") |>
    select(sigla, populacao_referencia = populacao)

  comparacao <- inner_join(tabela, referencia, by = "sigla")
  diferenca  <- abs(comparacao$populacao - comparacao$populacao_referencia)

  stopifnot(all(diferenca <= 1))
}


# Formatação de números ----------------------------------------------------

# No padrão brasileiro: 1.234.567 e 12,3.

formatar_milhar <- function(x) {
  format(round(x), big.mark = ".", decimal.mark = ",",
         scientific = FALSE, trim = TRUE)
}

formatar_decimal <- function(x) {
  format(round(x, 1), nsmall = 1, decimal.mark = ",", trim = TRUE)
}
