# Migração: filtro das variáveis de migração de cada pessoa
#
# Variáveis usadas (ver o Dicionário de Variáveis dos microdados do CD2022):
#
# Naturalidade
#   P0480  local de nascimento (1 neste município, 2 outro município do
#          Brasil, 3 outro país)
#   P0490  UF de nascimento
#   P0500  município de nascimento
#   P0510  país de nascimento
#
# Nacionalidade
#   P0520  nacionalidade (1 brasileiro nato, 2 naturalizado, 3 estrangeiro)
#   P0540  ano em que fixou residência no Brasil (estrangeiros e naturalizados)
#
# Residência anterior
#   P0530  já morou em outro município ou país (só para quem nasceu no
#          município atual; em branco para os demais)
#   P0550  anos morando sem interrupção no município atual (em branco para
#          quem nunca morou fora)
#   P0560  onde morava antes, para quem está há menos de 10 anos no
#          município (1 Brasil, 2 exterior, 9 ignorado)
#   P0570  UF anterior
#   P0580  município anterior
#   P0590  país anterior


# Códigos que o IBGE usa para "não sabe" e "ignorado".
codigos_uf_desconhecida        <- c(88, 99)
codigos_municipio_desconhecido <- c(8888888, 9999999)
codigos_pais_desconhecido      <- c(8000999000, 9999999999)

# Troca os códigos de "não sabe"/"ignorado" por NA.
desconhecido_para_na <- function(x, codigos) {
  replace(x, x %in% codigos, NA)
}


# Devolve uma linha por pessoa da UF, com as variáveis de migração já com
# nomes legíveis.
filtrar_migracao_uf <- function(cod_uf, zip_censo) {
  colunas_migracao <- c(
    P0480 = "integer",
    P0490 = "integer",
    P0500 = "integer",
    P0510 = "double",   # código de país tem 10 dígitos
    P0520 = "integer",
    P0530 = "integer",
    P0540 = "integer",
    P0550 = "integer",
    P0560 = "integer",
    P0570 = "integer",
    P0580 = "integer",
    P0590 = "double"    # código de país tem 10 dígitos
  )

  pessoas <- ler_pessoas_uf(cod_uf, zip_censo, colunas_migracao)

  pessoas |>
    transmute(
      cod_uf        = P0020,
      cod_municipio = P0080,
      sexo          = if_else(P0160 == 1, "Homens", "Mulheres"),
      idade         = P0181,
      peso          = P0111,

      # Naturalidade
      local_nascimento = case_when(
        P0480 == 1 ~ "Neste município",
        P0480 == 2 ~ "Outro município do Brasil",
        P0480 == 3 ~ "Outro país"
      ),
      # Quem nasceu no município onde mora tem UF e município de nascimento
      # em branco no arquivo do IBGE. Aqui eles recebem a UF e o município
      # de residência.
      uf_nascimento = if_else(
        P0480 == 1,
        P0020,
        desconhecido_para_na(P0490, codigos_uf_desconhecida)
      ),
      mun_nascimento = if_else(
        P0480 == 1,
        P0080,
        desconhecido_para_na(P0500, codigos_municipio_desconhecido)
      ),
      pais_nascimento = desconhecido_para_na(P0510, codigos_pais_desconhecido),

      # Nacionalidade
      nacionalidade = case_when(
        P0520 == 1 ~ "Brasileiro nato",
        P0520 == 2 ~ "Naturalizado brasileiro",
        P0520 == 3 ~ "Estrangeiro"
      ),
      ano_fixacao_brasil = P0540,

      # Residência anterior
      # P0530 fica em branco para quem nasceu em outro lugar, mas essas
      # pessoas, por definição, já moraram fora do município atual.
      ja_morou_fora = case_when(
        P0480 != 1 ~ TRUE,
        P0530 == 1 ~ TRUE,
        P0530 == 2 ~ FALSE
      ),
      anos_no_municipio = P0550,
      residencia_anterior = case_when(
        P0560 == 1 ~ "Brasil",
        P0560 == 2 ~ "Exterior"
      ),
      uf_anterior   = desconhecido_para_na(P0570, codigos_uf_desconhecida),
      mun_anterior  = desconhecido_para_na(P0580, codigos_municipio_desconhecido),
      pais_anterior = desconhecido_para_na(P0590, codigos_pais_desconhecido)
    )
}
