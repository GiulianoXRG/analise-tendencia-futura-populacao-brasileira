# Pará (PA)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **8.120.131** pessoas.

## Estrutura etária

![Pirâmide etária do Pará](graficos/piramide_etaria.png)

| Indicador | PA | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 36,0 | 28,5 |
| Razão de dependência idosa | 10,6 | 15,8 |
| Razão de dependência total | 46,6 | 44,4 |
| Índice de envelhecimento | 29,5 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 86,5% |
| Nascidos em outra UF | 13,3% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 357.809 |
| Saídas para outras UFs (últimos 10 anos) | 503.124 |
| Saldo migratório entre UFs | -145.315 |
| Saldo por 1.000 habitantes | -17,9 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| MA | 89.913 | GO | 68.344 |
| AM | 43.120 | SC | 67.340 |
| GO | 30.251 | MA | 65.516 |
| AP | 28.201 | MT | 39.249 |
| TO | 27.363 | SP | 34.804 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | PA | Brasil |
|---|--:|--:|
| Óbitos no período | 43.115 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 5,3 | 6,6 |
| Esperança de vida ao nascer, total | 76,1 | 77,4 |
| Esperança de vida ao nascer, homens | 73,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,4 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,6 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Pará](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
