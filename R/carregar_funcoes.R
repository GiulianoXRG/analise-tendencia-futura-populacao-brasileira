# Carrega os pacotes e todas as funções do projeto
#
# Cada script começa com source("R/carregar_funcoes.R").

pacotes <- c("arrow", "censobr", "data.table", "geobr", "sf", "tidyverse")

faltando <- pacotes[!vapply(pacotes, requireNamespace, logical(1),
                            quietly = TRUE)]
if (length(faltando) > 0) {
  install.packages(faltando)
}

suppressPackageStartupMessages({
  library(tidyverse)
  library(sf)  # mapas dos municípios
})

for (arquivo in list.files("R/funcoes", pattern = "\\.R$", full.names = TRUE)) {
  source(arquivo, encoding = "UTF-8")
}
