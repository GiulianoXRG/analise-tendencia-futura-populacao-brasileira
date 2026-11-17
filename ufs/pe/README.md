# Pernambuco (PE)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **9.058.931** pessoas.

## Estrutura etária

![Pirâmide etária de Pernambuco](graficos/piramide_etaria.png)

| Indicador | PE | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 30,4 | 28,5 |
| Razão de dependência idosa | 14,8 | 15,8 |
| Razão de dependência total | 45,2 | 44,4 |
| Índice de envelhecimento | 48,7 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 92,7% |
| Nascidos em outra UF | 7,1% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 342.863 |
| Saídas para outras UFs (últimos 10 anos) | 418.848 |
| Saldo migratório entre UFs | -75.985 |
| Saldo por 1.000 habitantes | -8,4 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 120.481 | SP | 122.920 |
| BA | 40.088 | PB | 50.743 |
| PB | 35.093 | BA | 38.672 |
| AL | 28.398 | AL | 31.518 |
| RJ | 20.138 | MG | 22.857 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | PE | Brasil |
|---|--:|--:|
| Óbitos no período | 61.935 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,8 | 6,6 |
| Esperança de vida ao nascer, total | 76,3 | 77,4 |
| Esperança de vida ao nascer, homens | 73,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,4 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,6 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Pernambuco](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
