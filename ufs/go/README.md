# Goiás (GO)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **7.056.495** pessoas.

## Estrutura etária

![Pirâmide etária de Goiás](graficos/piramide_etaria.png)

| Indicador | GO | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 28,8 | 28,5 |
| Razão de dependência idosa | 13,1 | 15,8 |
| Razão de dependência total | 41,8 | 44,4 |
| Índice de envelhecimento | 45,4 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 70,8% |
| Nascidos em outra UF | 28,8% |
| Nascidos no exterior | 0,3% |
| Entradas de outras UFs (últimos 10 anos) | 762.381 |
| Saídas para outras UFs (últimos 10 anos) | 414.974 |
| Saldo migratório entre UFs | +347.407 |
| Saldo por 1.000 habitantes | +49,2 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| DF | 218.369 | DF | 61.510 |
| MA | 92.615 | MG | 52.192 |
| PA | 68.344 | TO | 42.031 |
| MG | 56.445 | MT | 40.287 |
| BA | 56.035 | SP | 38.096 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | GO | Brasil |
|---|--:|--:|
| Óbitos no período | 43.787 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,2 | 6,6 |
| Esperança de vida ao nascer, total | 76,3 | 77,4 |
| Esperança de vida ao nascer, homens | 73,5 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,3 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,7 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Goiás](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
