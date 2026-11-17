# Acre (AC)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **830.018** pessoas.

## Estrutura etária

![Pirâmide etária do Acre](graficos/piramide_etaria.png)

| Indicador | AC | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 39,8 | 28,5 |
| Razão de dependência idosa | 9,4 | 15,8 |
| Razão de dependência total | 49,3 | 44,4 |
| Índice de envelhecimento | 23,7 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 91,0% |
| Nascidos em outra UF | 8,6% |
| Nascidos no exterior | 0,4% |
| Entradas de outras UFs (últimos 10 anos) | 25.543 |
| Saídas para outras UFs (últimos 10 anos) | 61.488 |
| Saldo migratório entre UFs | -35.946 |
| Saldo por 1.000 habitantes | -43,3 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| AM | 8.188 | RO | 15.103 |
| RO | 6.910 | AM | 8.690 |
| SP | 1.339 | SC | 6.114 |
| MT | 1.094 | MT | 4.911 |
| RJ | 838 | SP | 4.299 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | AC | Brasil |
|---|--:|--:|
| Óbitos no período | 3.674 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 4,4 | 6,6 |
| Esperança de vida ao nascer, total | 77,3 | 77,4 |
| Esperança de vida ao nascer, homens | 75,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,7 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,3 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Acre](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
