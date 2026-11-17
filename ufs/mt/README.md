# Mato Grosso (MT)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **3.658.649** pessoas.

## Estrutura etária

![Pirâmide etária de Mato Grosso](graficos/piramide_etaria.png)

| Indicador | MT | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 32,5 | 28,5 |
| Razão de dependência idosa | 11,1 | 15,8 |
| Razão de dependência total | 43,6 | 44,4 |
| Índice de envelhecimento | 34,1 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 65,1% |
| Nascidos em outra UF | 34,2% |
| Nascidos no exterior | 0,5% |
| Entradas de outras UFs (últimos 10 anos) | 379.051 |
| Saídas para outras UFs (últimos 10 anos) | 225.022 |
| Saldo migratório entre UFs | +154.029 |
| Saldo por 1.000 habitantes | +42,1 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| MA | 62.560 | GO | 30.577 |
| GO | 40.287 | PR | 26.963 |
| PA | 39.249 | SP | 26.638 |
| RO | 34.576 | MS | 23.052 |
| SP | 29.733 | RO | 19.400 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | MT | Brasil |
|---|--:|--:|
| Óbitos no período | 19.647 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 5,4 | 6,6 |
| Esperança de vida ao nascer, total | 76,5 | 77,4 |
| Esperança de vida ao nascer, homens | 73,6 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,7 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,1 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Mato Grosso](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
