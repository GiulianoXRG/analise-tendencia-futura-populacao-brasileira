# Paraíba (PB)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **3.974.687** pessoas.

## Estrutura etária

![Pirâmide etária da Paraíba](graficos/piramide_etaria.png)

| Indicador | PB | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 30,5 | 28,5 |
| Razão de dependência idosa | 16,2 | 15,8 |
| Razão de dependência total | 46,8 | 44,4 |
| Índice de envelhecimento | 53,2 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 90,5% |
| Nascidos em outra UF | 9,4% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 256.603 |
| Saídas para outras UFs (últimos 10 anos) | 206.813 |
| Saldo migratório entre UFs | +49.790 |
| Saldo por 1.000 habitantes | +12,5 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| SP | 61.889 | SP | 46.709 |
| PE | 50.743 | PE | 35.093 |
| RJ | 49.684 | RJ | 33.332 |
| RN | 25.177 | RN | 22.898 |
| CE | 11.783 | CE | 10.900 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | PB | Brasil |
|---|--:|--:|
| Óbitos no período | 27.647 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 7,0 | 6,6 |
| Esperança de vida ao nascer, total | 77,2 | 77,4 |
| Esperança de vida ao nascer, homens | 74,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 80,2 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,4 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade da Paraíba](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
