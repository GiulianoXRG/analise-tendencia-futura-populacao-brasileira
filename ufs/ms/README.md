# Mato Grosso do Sul (MS)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **2.757.013** pessoas.

## Estrutura etária

![Pirâmide etária de Mato Grosso do Sul](graficos/piramide_etaria.png)

| Indicador | MS | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 32,2 | 28,5 |
| Razão de dependência idosa | 14,1 | 15,8 |
| Razão de dependência total | 46,4 | 44,4 |
| Índice de envelhecimento | 43,8 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 75,9% |
| Nascidos em outra UF | 22,9% |
| Nascidos no exterior | 1,0% |
| Entradas de outras UFs (últimos 10 anos) | 214.351 |
| Saídas para outras UFs (últimos 10 anos) | 175.910 |
| Saldo migratório entre UFs | +38.441 |
| Saldo por 1.000 habitantes | +13,9 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 63.154 | SP | 48.717 |
| PR | 28.370 | PR | 31.012 |
| MT | 23.052 | MT | 24.417 |
| GO | 11.394 | SC | 13.861 |
| MG | 9.798 | GO | 9.153 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | MS | Brasil |
|---|--:|--:|
| Óbitos no período | 18.579 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,7 | 6,6 |
| Esperança de vida ao nascer, total | 75,7 | 77,4 |
| Esperança de vida ao nascer, homens | 72,9 | 74,3 |
| Esperança de vida ao nascer, mulheres | 78,7 | 80,4 |
| Esperança de vida aos 60 anos, total | 22,3 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Mato Grosso do Sul](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
