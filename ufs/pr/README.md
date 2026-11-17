# Paraná (PR)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **11.444.380** pessoas.

## Estrutura etária

![Pirâmide etária do Paraná](graficos/piramide_etaria.png)

| Indicador | PR | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 27,6 | 28,5 |
| Razão de dependência idosa | 16,4 | 15,8 |
| Razão de dependência total | 44,0 | 44,4 |
| Índice de envelhecimento | 59,5 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 83,4% |
| Nascidos em outra UF | 15,6% |
| Nascidos no exterior | 1,0% |
| Entradas de outras UFs (últimos 10 anos) | 661.826 |
| Saídas para outras UFs (últimos 10 anos) | 512.842 |
| Saldo migratório entre UFs | +148.983 |
| Saldo por 1.000 habitantes | +13,0 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 222.656 | SC | 185.424 |
| SC | 129.673 | SP | 141.020 |
| RS | 33.906 | RS | 29.195 |
| MS | 31.012 | MT | 29.075 |
| MT | 26.963 | MS | 28.370 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | PR | Brasil |
|---|--:|--:|
| Óbitos no período | 78.255 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,8 | 6,6 |
| Esperança de vida ao nascer, total | 77,2 | 77,4 |
| Esperança de vida ao nascer, homens | 74,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 80,2 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,9 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Paraná](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
