# Piauí (PI)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **3.271.199** pessoas.

## Estrutura etária

![Pirâmide etária do Piauí](graficos/piramide_etaria.png)

| Indicador | PI | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 30,5 | 28,5 |
| Razão de dependência idosa | 15,6 | 15,8 |
| Razão de dependência total | 46,0 | 44,4 |
| Índice de envelhecimento | 51,1 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 90,6% |
| Nascidos em outra UF | 9,3% |
| Nascidos no exterior | 0,0% |
| Entradas de outras UFs (últimos 10 anos) | 208.798 |
| Saídas para outras UFs (últimos 10 anos) | 226.029 |
| Saldo migratório entre UFs | -17.231 |
| Saldo por 1.000 habitantes | -5,3 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 71.140 | SP | 62.948 |
| MA | 35.638 | MA | 39.608 |
| DF | 26.402 | DF | 21.988 |
| CE | 16.280 | GO | 21.316 |
| GO | 9.930 | CE | 16.901 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | PI | Brasil |
|---|--:|--:|
| Óbitos no período | 21.083 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,4 | 6,6 |
| Esperança de vida ao nascer, total | 77,3 | 77,4 |
| Esperança de vida ao nascer, homens | 74,3 | 74,3 |
| Esperança de vida ao nascer, mulheres | 80,3 | 80,4 |
| Esperança de vida aos 60 anos, total | 24,2 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Piauí](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
