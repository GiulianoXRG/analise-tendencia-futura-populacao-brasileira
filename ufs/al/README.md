# Alagoas (AL)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **3.127.683** pessoas.

## Estrutura etária

![Pirâmide etária de Alagoas](graficos/piramide_etaria.png)

| Indicador | AL | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 33,3 | 28,5 |
| Razão de dependência idosa | 13,1 | 15,8 |
| Razão de dependência total | 46,3 | 44,4 |
| Índice de envelhecimento | 39,3 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 91,3% |
| Nascidos em outra UF | 8,5% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 171.491 |
| Saídas para outras UFs (últimos 10 anos) | 265.246 |
| Saldo migratório entre UFs | -93.755 |
| Saldo por 1.000 habitantes | -30,0 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 63.037 | SP | 84.776 |
| PE | 31.518 | MG | 30.893 |
| SE | 12.395 | PE | 28.398 |
| BA | 11.622 | MT | 25.347 |
| MG | 9.488 | GO | 14.796 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | AL | Brasil |
|---|--:|--:|
| Óbitos no período | 20.542 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,6 | 6,6 |
| Esperança de vida ao nascer, total | 75,4 | 77,4 |
| Esperança de vida ao nascer, homens | 72,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 78,6 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,2 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Alagoas](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
