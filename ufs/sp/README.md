# São Paulo (SP)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **44.411.238** pessoas.

## Estrutura etária

![Pirâmide etária de São Paulo](graficos/piramide_etaria.png)

| Indicador | SP | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 25,6 | 28,5 |
| Razão de dependência idosa | 17,1 | 15,8 |
| Razão de dependência total | 42,8 | 44,4 |
| Índice de envelhecimento | 66,8 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 79,7% |
| Nascidos em outra UF | 19,4% |
| Nascidos no exterior | 0,8% |
| Entradas de outras UFs (últimos 10 anos) | 1.684.787 |
| Saídas para outras UFs (últimos 10 anos) | 1.839.025 |
| Saldo migratório entre UFs | -154.238 |
| Saldo por 1.000 habitantes | -3,5 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| BA | 288.940 | MG | 340.942 |
| MG | 276.222 | BA | 304.754 |
| PR | 141.020 | PR | 222.656 |
| RJ | 136.118 | PE | 120.481 |
| PE | 122.920 | SC | 110.259 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | SP | Brasil |
|---|--:|--:|
| Óbitos no período | 298.527 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,7 | 6,6 |
| Esperança de vida ao nascer, total | 78,3 | 77,4 |
| Esperança de vida ao nascer, homens | 75,3 | 74,3 |
| Esperança de vida ao nascer, mulheres | 81,0 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,5 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de São Paulo](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
