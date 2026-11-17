# Rio Grande do Norte (RN)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **3.302.729** pessoas.

## Estrutura etária

![Pirâmide etária do Rio Grande do Norte](graficos/piramide_etaria.png)

| Indicador | RN | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 28,5 | 28,5 |
| Razão de dependência idosa | 15,1 | 15,8 |
| Razão de dependência total | 43,6 | 44,4 |
| Índice de envelhecimento | 52,9 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 90,8% |
| Nascidos em outra UF | 9,0% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 136.812 |
| Saídas para outras UFs (últimos 10 anos) | 136.563 |
| Saldo migratório entre UFs | +249 |
| Saldo por 1.000 habitantes | +0,1 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 28.525 | PB | 25.177 |
| PB | 22.898 | SP | 20.609 |
| CE | 16.375 | CE | 17.519 |
| RJ | 15.772 | RJ | 11.717 |
| PE | 13.217 | PE | 9.059 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | RN | Brasil |
|---|--:|--:|
| Óbitos no período | 22.488 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,8 | 6,6 |
| Esperança de vida ao nascer, total | 77,2 | 77,4 |
| Esperança de vida ao nascer, homens | 74,5 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,7 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,4 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Rio Grande do Norte](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
- [`municipios/`](municipios/): os mesmos resultados para cada município da UF, com mapas
- [`roteiro/`](roteiro/): primeira etapa do projeto, a análise passo a passo feita só para esta UF
