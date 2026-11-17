# Rio de Janeiro (RJ)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **16.055.174** pessoas.

## Estrutura etária

![Pirâmide etária do Rio de Janeiro](graficos/piramide_etaria.png)

| Indicador | RJ | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 25,9 | 28,5 |
| Razão de dependência idosa | 19,1 | 15,8 |
| Razão de dependência total | 45,0 | 44,4 |
| Índice de envelhecimento | 73,7 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 87,2% |
| Nascidos em outra UF | 12,2% |
| Nascidos no exterior | 0,5% |
| Entradas de outras UFs (últimos 10 anos) | 444.759 |
| Saídas para outras UFs (últimos 10 anos) | 662.273 |
| Saldo migratório entre UFs | -217.514 |
| Saldo por 1.000 habitantes | -13,5 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 79.356 | SP | 136.118 |
| MG | 72.273 | MG | 117.352 |
| BA | 39.548 | PB | 49.684 |
| PB | 33.332 | CE | 48.908 |
| CE | 30.444 | ES | 47.305 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | RJ | Brasil |
|---|--:|--:|
| Óbitos no período | 125.600 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 7,8 | 6,6 |
| Esperança de vida ao nascer, total | 76,6 | 77,4 |
| Esperança de vida ao nascer, homens | 73,7 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,2 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,3 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Rio de Janeiro](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
