# Roraima (RR)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **636.707** pessoas.

## Estrutura etária

![Pirâmide etária de Roraima](graficos/piramide_etaria.png)

| Indicador | RR | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 44,6 | 28,5 |
| Razão de dependência idosa | 7,7 | 15,8 |
| Razão de dependência total | 52,3 | 44,4 |
| Índice de envelhecimento | 17,3 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 59,6% |
| Nascidos em outra UF | 27,5% |
| Nascidos no exterior | 12,8% |
| Entradas de outras UFs (últimos 10 anos) | 43.507 |
| Saídas para outras UFs (últimos 10 anos) | 58.532 |
| Saldo migratório entre UFs | -15.025 |
| Saldo por 1.000 habitantes | -23,6 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| AM | 14.127 | SC | 8.587 |
| PA | 7.271 | AM | 8.378 |
| MA | 6.442 | PR | 5.716 |
| RO | 2.050 | RS | 4.985 |
| SP | 1.507 | PA | 4.623 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | RR | Brasil |
|---|--:|--:|
| Óbitos no período | 2.978 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 4,7 | 6,6 |
| Esperança de vida ao nascer, total | 74,7 | 77,4 |
| Esperança de vida ao nascer, homens | 72,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 77,5 | 80,4 |
| Esperança de vida aos 60 anos, total | 21,8 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Roraima](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
