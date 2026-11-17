# Roda o projeto inteiro, na ordem certa
#
# Uso, com a raiz do projeto como diretório de trabalho:
#   Rscript R/rodar_tudo.R             todas as UFs
#   Rscript R/rodar_tudo.R PB PE       lê dos microdados só as UFs indicadas
#   Rscript R/rodar_tudo.R --refazer   lê os microdados de novo
#
# As opções valem para os passos 1 a 4. Sem siglas, os passos 1 a 3 rodam
# para todas as UFs e o passo 4 (municípios) para o Rio Grande do Norte.
# Cada passo roda separado dos outros, como se fosse chamado sozinho.

passos <- c(
  "R/01_populacao.R",   # população, pirâmides e dependência
  "R/02_migracao.R",    # migração
  "R/03_mortalidade.R", # óbitos, taxas e tábuas de vida
  "R/04_municipios.R",  # os mesmos resultados por município
  "R/05_readmes.R"      # README de cada UF e de cada município
)

for (passo in passos) {
  message("\n== ", passo)
  source(passo, local = new.env(), encoding = "UTF-8")
}
