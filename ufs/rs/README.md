# Rio Grande do Sul (RS)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **10.882.965** pessoas.

## Estrutura etária

![Pirâmide etária do Rio Grande do Sul](graficos/piramide_etaria.png)

| Indicador | RS | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 25,6 | 28,5 |
| Razão de dependência idosa | 20,6 | 15,8 |
| Razão de dependência total | 46,2 | 44,4 |
| Índice de envelhecimento | 80,5 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 95,1% |
| Nascidos em outra UF | 4,2% |
| Nascidos no exterior | 0,7% |
| Entradas de outras UFs (últimos 10 anos) | 283.378 |
| Saídas para outras UFs (últimos 10 anos) | 384.872 |
| Saldo migratório entre UFs | -101.494 |
| Saldo por 1.000 habitantes | -9,3 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SC | 94.812 | SC | 230.872 |
| SP | 36.191 | SP | 35.476 |
| PR | 29.195 | PR | 33.906 |
| RJ | 19.862 | RJ | 14.096 |
| MG | 10.316 | MG | 9.279 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | RS | Brasil |
|---|--:|--:|
| Óbitos no período | 84.530 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 7,8 | 6,6 |
| Esperança de vida ao nascer, total | 77,8 | 77,4 |
| Esperança de vida ao nascer, homens | 74,5 | 74,3 |
| Esperança de vida ao nascer, mulheres | 81,0 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,2 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Rio Grande do Sul](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
