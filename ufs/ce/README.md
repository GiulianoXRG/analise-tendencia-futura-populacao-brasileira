# Ceará (CE)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **8.794.957** pessoas.

## Estrutura etária

![Pirâmide etária do Ceará](graficos/piramide_etaria.png)

| Indicador | CE | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 29,7 | 28,5 |
| Razão de dependência idosa | 15,0 | 15,8 |
| Razão de dependência total | 44,7 | 44,4 |
| Índice de envelhecimento | 50,7 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 94,5% |
| Nascidos em outra UF | 5,4% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 316.551 |
| Saídas para outras UFs (últimos 10 anos) | 310.889 |
| Saldo migratório entre UFs | +5.662 |
| Saldo por 1.000 habitantes | +0,6 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 95.094 | SP | 85.872 |
| RJ | 48.908 | RJ | 30.444 |
| PE | 19.723 | PE | 18.988 |
| RN | 17.519 | MG | 17.561 |
| PI | 16.901 | RN | 16.375 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | CE | Brasil |
|---|--:|--:|
| Óbitos no período | 54.599 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,2 | 6,6 |
| Esperança de vida ao nascer, total | 78,1 | 77,4 |
| Esperança de vida ao nascer, homens | 75,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 81,1 | 80,4 |
| Esperança de vida aos 60 anos, total | 24,3 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Ceará](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
