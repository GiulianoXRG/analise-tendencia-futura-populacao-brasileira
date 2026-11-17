# Tocantins (TO)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **1.511.460** pessoas.

## Estrutura etária

![Pirâmide etária do Tocantins](graficos/piramide_etaria.png)

| Indicador | TO | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 34,2 | 28,5 |
| Razão de dependência idosa | 12,7 | 15,8 |
| Razão de dependência total | 46,9 | 44,4 |
| Índice de envelhecimento | 37,2 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 71,6% |
| Nascidos em outra UF | 28,2% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 151.221 |
| Saídas para outras UFs (últimos 10 anos) | 144.994 |
| Saldo migratório entre UFs | +6.227 |
| Saldo por 1.000 habitantes | +4,1 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| GO | 42.031 | GO | 50.698 |
| MA | 30.191 | PA | 27.363 |
| PA | 28.703 | MA | 17.089 |
| DF | 8.531 | SP | 7.366 |
| SP | 7.767 | MG | 6.748 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | TO | Brasil |
|---|--:|--:|
| Óbitos no período | 8.955 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 5,9 | 6,6 |
| Esperança de vida ao nascer, total | 76,7 | 77,4 |
| Esperança de vida ao nascer, homens | 73,8 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,9 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,3 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Tocantins](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
