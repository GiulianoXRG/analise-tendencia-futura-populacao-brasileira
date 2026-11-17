# Rondônia (RO)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **1.581.196** pessoas.

## Estrutura etária

![Pirâmide etária de Rondônia](graficos/piramide_etaria.png)

| Indicador | RO | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 31,5 | 28,5 |
| Razão de dependência idosa | 11,6 | 15,8 |
| Razão de dependência total | 43,1 | 44,4 |
| Índice de envelhecimento | 36,7 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 63,6% |
| Nascidos em outra UF | 35,7% |
| Nascidos no exterior | 0,6% |
| Entradas de outras UFs (últimos 10 anos) | 97.904 |
| Saídas para outras UFs (últimos 10 anos) | 135.243 |
| Saldo migratório entre UFs | -37.339 |
| Saldo por 1.000 habitantes | -23,6 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| MT | 19.400 | MT | 34.576 |
| AC | 15.103 | AM | 16.643 |
| AM | 11.766 | PR | 14.665 |
| SP | 7.574 | SP | 9.865 |
| PR | 7.163 | AC | 6.910 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | RO | Brasil |
|---|--:|--:|
| Óbitos no período | 8.566 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 5,4 | 6,6 |
| Esperança de vida ao nascer, total | 76,8 | 77,4 |
| Esperança de vida ao nascer, homens | 74,8 | 74,3 |
| Esperança de vida ao nascer, mulheres | 78,8 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,8 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Rondônia](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
