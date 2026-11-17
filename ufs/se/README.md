# Sergipe (SE)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **2.210.004** pessoas.

## Estrutura etária

![Pirâmide etária de Sergipe](graficos/piramide_etaria.png)

| Indicador | SE | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 30,6 | 28,5 |
| Razão de dependência idosa | 13,1 | 15,8 |
| Razão de dependência total | 43,7 | 44,4 |
| Índice de envelhecimento | 42,8 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 88,0% |
| Nascidos em outra UF | 11,9% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 116.668 |
| Saídas para outras UFs (últimos 10 anos) | 119.943 |
| Saldo migratório entre UFs | -3.275 |
| Saldo por 1.000 habitantes | -1,5 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| BA | 38.352 | BA | 28.491 |
| SP | 30.062 | SP | 27.807 |
| AL | 14.443 | AL | 12.395 |
| RJ | 6.760 | SC | 12.354 |
| PE | 4.718 | MG | 7.654 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | SE | Brasil |
|---|--:|--:|
| Óbitos no período | 13.758 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,2 | 6,6 |
| Esperança de vida ao nascer, total | 76,6 | 77,4 |
| Esperança de vida ao nascer, homens | 73,2 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,9 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,9 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Sergipe](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
