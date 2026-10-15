# Análise da tendência futura da população brasileira

Projeto de Iniciação Científica em Ciências Atuariais que estuda a estrutura
etária da população brasileira a partir do Censo Demográfico 2022, como base
para analisar sua tendência futura.

A análise começa pelo **Rio Grande do Norte**, que é a etapa em andamento.

## Resultados do Rio Grande do Norte

### Pirâmide etária

![Pirâmide etária do Rio Grande do Norte, 2022](graficos/piramide_etaria_rn.png)

### Razões de dependência e índice de envelhecimento

| Indicador | Valor |
|---|---|
| Razão de dependência jovem | 28,5 |
| Razão de dependência idosa | 15,1 |
| Razão de dependência total | 43,6 |
| Índice de envelhecimento | 52,9 |

Valores por 100 pessoas. Jovens: 0 a 14 anos. Idade ativa: 15 a 64 anos.
Idosos: 65 anos ou mais.

## Estrutura

```
R/
  filtrar_rn.R                 # passo 1: filtra as pessoas do RN nos microdados
  piramide_etaria.R            # passo 2: pirâmide etária em grupos de 5 anos
  indicadores_dependencia.R    # passo 3: razões de dependência e envelhecimento
graficos/                      # gráficos gerados pelos scripts
```

## Como reproduzir

1. Solicite ao IBGE os microdados da amostra do Censo 2022 (acesso controlado)
   em formato CSV, em <https://microdados.ibge.gov.br/>.
2. Coloque o arquivo `.zip` recebido na raiz do projeto, sem descompactar.
3. Rode os scripts da pasta `R/` na ordem numérica dos passos, com a raiz do
   projeto como diretório de trabalho.

Pacotes utilizados: [censobr](https://ipeagit.github.io/censobr/) e
[tidyverse](https://www.tidyverse.org/).

## Sobre os dados

Os microdados de acesso controlado do Censo 2022 são sigilosos e **não fazem
parte deste repositório**. O `.gitignore` impede o envio do arquivo do IBGE e
das bases geradas a partir dele (pasta `dados_rn/`). Aqui são publicados apenas
o código e resultados agregados para o estado.

Fonte: IBGE, Censo Demográfico 2022.
