# Santa Catarina (SC)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **7.610.361** pessoas.

## Estrutura etária

![Pirâmide etária de Santa Catarina](graficos/piramide_etaria.png)

| Indicador | SC | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 26,4 | 28,5 |
| Razão de dependência idosa | 14,8 | 15,8 |
| Razão de dependência total | 41,2 | 44,4 |
| Índice de envelhecimento | 56,1 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 75,6% |
| Nascidos em outra UF | 23,2% |
| Nascidos no exterior | 1,1% |
| Entradas de outras UFs (últimos 10 anos) | 869.750 |
| Saídas para outras UFs (últimos 10 anos) | 361.268 |
| Saldo migratório entre UFs | +508.482 |
| Saldo por 1.000 habitantes | +66,8 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| RS | 230.872 | PR | 129.673 |
| PR | 185.424 | RS | 94.812 |
| SP | 110.259 | SP | 46.407 |
| PA | 67.340 | BA | 9.955 |
| BA | 35.006 | MG | 9.664 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | SC | Brasil |
|---|--:|--:|
| Óbitos no período | 43.191 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 5,7 | 6,6 |
| Esperança de vida ao nascer, total | 79,0 | 77,4 |
| Esperança de vida ao nascer, homens | 76,2 | 74,3 |
| Esperança de vida ao nascer, mulheres | 81,7 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,5 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade de Santa Catarina](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
