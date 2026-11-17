# Espírito Santo (ES)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **3.833.712** pessoas.

## Estrutura etária

![Pirâmide etária do Espírito Santo](graficos/piramide_etaria.png)

| Indicador | ES | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 27,8 | 28,5 |
| Razão de dependência idosa | 16,3 | 15,8 |
| Razão de dependência total | 44,1 | 44,4 |
| Índice de envelhecimento | 58,4 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 81,8% |
| Nascidos em outra UF | 18,0% |
| Nascidos no exterior | 0,2% |
| Entradas de outras UFs (últimos 10 anos) | 217.998 |
| Saídas para outras UFs (últimos 10 anos) | 165.436 |
| Saldo migratório entre UFs | +52.562 |
| Saldo por 1.000 habitantes | +13,7 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| MG | 64.220 | MG | 52.827 |
| BA | 50.140 | BA | 33.507 |
| RJ | 47.305 | RJ | 28.626 |
| SP | 19.224 | SP | 17.767 |
| DF | 3.271 | RO | 3.756 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | ES | Brasil |
|---|--:|--:|
| Óbitos no período | 22.905 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,0 | 6,6 |
| Esperança de vida ao nascer, total | 79,0 | 77,4 |
| Esperança de vida ao nascer, homens | 76,0 | 74,3 |
| Esperança de vida ao nascer, mulheres | 81,9 | 80,4 |
| Esperança de vida aos 60 anos, total | 24,6 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Espírito Santo](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
