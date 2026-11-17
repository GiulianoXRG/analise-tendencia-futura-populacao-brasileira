# Amapá (AP)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **733.759** pessoas.

## Estrutura etária

![Pirâmide etária do Amapá](graficos/piramide_etaria.png)

| Indicador | AP | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 40,1 | 28,5 |
| Razão de dependência idosa | 8,1 | 15,8 |
| Razão de dependência total | 48,2 | 44,4 |
| Índice de envelhecimento | 20,3 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 74,5% |
| Nascidos em outra UF | 25,2% |
| Nascidos no exterior | 0,2% |
| Entradas de outras UFs (últimos 10 anos) | 45.663 |
| Saídas para outras UFs (últimos 10 anos) | 65.944 |
| Saldo migratório entre UFs | -20.282 |
| Saldo por 1.000 habitantes | -27,6 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| PA | 32.654 | PA | 28.201 |
| MA | 2.858 | SC | 8.212 |
| SP | 1.133 | PR | 4.657 |
| CE | 1.079 | MA | 3.745 |
| AM | 868 | SP | 2.913 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | AP | Brasil |
|---|--:|--:|
| Óbitos no período | 4.252 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 5,8 | 6,6 |
| Esperança de vida ao nascer, total | 72,7 | 77,4 |
| Esperança de vida ao nascer, homens | 69,8 | 74,3 |
| Esperança de vida ao nascer, mulheres | 75,9 | 80,4 |
| Esperança de vida aos 60 anos, total | 20,5 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Amapá](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
