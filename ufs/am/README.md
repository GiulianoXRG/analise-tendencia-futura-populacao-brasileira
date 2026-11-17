# Amazonas (AM)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **3.941.613** pessoas.

## Estrutura etária

![Pirâmide etária do Amazonas](graficos/piramide_etaria.png)

| Indicador | AM | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 41,0 | 28,5 |
| Razão de dependência idosa | 8,8 | 15,8 |
| Razão de dependência total | 49,8 | 44,4 |
| Índice de envelhecimento | 21,6 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 89,6% |
| Nascidos em outra UF | 8,8% |
| Nascidos no exterior | 1,5% |
| Entradas de outras UFs (últimos 10 anos) | 116.949 |
| Saídas para outras UFs (últimos 10 anos) | 189.635 |
| Saldo migratório entre UFs | -72.686 |
| Saldo por 1.000 habitantes | -18,4 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| PA | 31.351 | PA | 43.120 |
| RO | 16.643 | SP | 16.754 |
| RJ | 10.592 | SC | 16.227 |
| AC | 8.690 | RR | 14.127 |
| RR | 8.378 | PR | 13.990 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | AM | Brasil |
|---|--:|--:|
| Óbitos no período | 19.239 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 4,9 | 6,6 |
| Esperança de vida ao nascer, total | 75,5 | 77,4 |
| Esperança de vida ao nascer, homens | 72,6 | 74,3 |
| Esperança de vida ao nascer, mulheres | 78,4 | 80,4 |
| Esperança de vida aos 60 anos, total | 21,9 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Amazonas](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
