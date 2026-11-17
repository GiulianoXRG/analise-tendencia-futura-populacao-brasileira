# Leitura dos microdados
#
# O zip do IBGE tem uma pasta por UF (11, 12, ..., 53), e cada pasta tem
# quatro arquivos CSV: Pessoas, Domicilios, Familia e Mortalidade.
#
# Para ser rápido:
#   - só o arquivo pedido é extraído do zip, e ele é apagado depois;
#   - o data.table::fread lê só as colunas pedidas, usando vários núcleos.


# Lê do arquivo `arquivo` da UF só as colunas em `colunas`.
# `colunas` é um vetor no formato c(NOME_DA_COLUNA = "tipo").
ler_arquivo_uf <- function(cod_uf, zip_censo, arquivo, colunas) {
  nome_no_zip <- sprintf("%d/%s_%d_controlado.csv", cod_uf, arquivo, cod_uf)
  pasta_temporaria <- file.path(tempdir(), "censo")

  unzip(zip_censo, files = nome_no_zip, exdir = pasta_temporaria)

  caminho <- file.path(pasta_temporaria, nome_no_zip)
  on.exit(unlink(caminho))  # apaga o CSV extraído ao sair da função

  tabela <- data.table::fread(
    caminho,
    sep          = ";",
    select       = colunas,
    showProgress = FALSE
  )

  as_tibble(tabela)
}


# Lê o arquivo de pessoas da UF. Sempre traz as cinco colunas básicas,
# mais as colunas extras pedidas em `colunas_extras`:
#   P0020  código da UF
#   P0080  código do município
#   P0160  sexo (1 = homem, 2 = mulher)
#   P0181  idade em anos completos
#   P0111  peso amostral (quantas pessoas cada registro representa)
ler_pessoas_uf <- function(cod_uf, zip_censo, colunas_extras = character()) {
  colunas_basicas <- c(
    P0020 = "integer",
    P0080 = "integer",
    P0160 = "integer",
    P0181 = "integer",
    P0111 = "double"
  )

  pessoas <- ler_arquivo_uf(
    cod_uf, zip_censo,
    arquivo = "Pessoas",
    colunas = c(colunas_basicas, colunas_extras)
  )

  # Conferências: o arquivo só tem pessoas desta UF, e todas têm idade.
  stopifnot(
    all(pessoas$P0020 == cod_uf),
    !anyNA(pessoas$P0181)
  )

  pessoas
}
