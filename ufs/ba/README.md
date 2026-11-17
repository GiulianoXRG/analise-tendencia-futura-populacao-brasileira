# Bahia (BA)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **14.141.626** pessoas.

## Estrutura etária

![Pirâmide etária da Bahia](graficos/piramide_etaria.png)

| Indicador | BA | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 29,3 | 28,5 |
| Razão de dependência idosa | 15,5 | 15,8 |
| Razão de dependência total | 44,8 | 44,4 |
| Índice de envelhecimento | 52,9 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 93,0% |
| Nascidos em outra UF | 6,8% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 667.296 |
| Saídas para outras UFs (últimos 10 anos) | 763.028 |
| Saldo migratório entre UFs | -95.732 |
| Saldo por 1.000 habitantes | -6,8 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 304.754 | SP | 288.940 |
| MG | 58.342 | MG | 75.484 |
| RJ | 40.301 | GO | 56.035 |
| PE | 38.672 | ES | 50.140 |
| DF | 33.562 | PE | 40.088 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | BA | Brasil |
|---|--:|--:|
| Óbitos no período | 93.697 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,6 | 6,6 |
| Esperança de vida ao nascer, total | 77,0 | 77,4 |
| Esperança de vida ao nascer, homens | 73,3 | 74,3 |
| Esperança de vida ao nascer, mulheres | 80,8 | 80,4 |
| Esperança de vida aos 60 anos, total | 24,2 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade da Bahia](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
