# Minas Gerais (MG)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **20.539.989** pessoas.

## Estrutura etária

![Pirâmide etária de Minas Gerais](graficos/piramide_etaria.png)

| Indicador | MG | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 26,0 | 28,5 |
| Razão de dependência idosa | 17,9 | 15,8 |
| Razão de dependência total | 43,8 | 44,4 |
| Índice de envelhecimento | 68,8 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 91,4% |
| Nascidos em outra UF | 8,3% |
| Nascidos no exterior | 0,2% |
| Entradas de outras UFs (últimos 10 anos) | 906.498 |
| Saídas para outras UFs (últimos 10 anos) | 720.516 |
| Saldo migratório entre UFs | +185.982 |
| Saldo por 1.000 habitantes | +9,1 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 340.942 | SP | 276.222 |
| RJ | 117.352 | RJ | 72.273 |
| BA | 75.484 | ES | 64.220 |
| ES | 52.827 | BA | 58.342 |
| GO | 52.192 | GO | 56.445 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | MG | Brasil |
|---|--:|--:|
| Óbitos no período | 141.253 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,9 | 6,6 |
| Esperança de vida ao nascer, total | 78,3 | 77,4 |
| Esperança de vida ao nascer, homens | 75,4 | 74,3 |
| Esperança de vida ao nascer, mulheres | 81,2 | 80,4 |
| Esperança de vida aos 60 anos, total | 24,1 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Minas Gerais](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
