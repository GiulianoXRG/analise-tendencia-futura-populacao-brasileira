# Maranhão (MA)

Resultados do Censo Demográfico 2022 (microdados da amostra) para esta UF. Gerado por `R/05_readmes.R`; veja o [README principal](../../README.md) para a metodologia.

População: **6.776.699** pessoas.

## Estrutura etária

![Pirâmide etária do Maranhão](graficos/piramide_etaria.png)

| Indicador | MA | Brasil |
|---|--:|--:|
| Razão de dependência jovem | 36,1 | 28,5 |
| Razão de dependência idosa | 12,6 | 15,8 |
| Razão de dependência total | 48,7 | 44,4 |
| Índice de envelhecimento | 34,9 | 55,5 |

Valores por 100 pessoas. Jovens: 0 a 14 anos; idade ativa: 15 a 64;
idosos: 65 ou mais.

## Migração

| Indicador | Valor |
|---|--:|
| Nascidos na própria UF | 92,3% |
| Nascidos em outra UF | 7,6% |
| Nascidos no exterior | 0,1% |
| Entradas de outras UFs (últimos 10 anos) | 310.766 |
| Saídas para outras UFs (últimos 10 anos) | 544.085 |
| Saldo migratório entre UFs | -233.319 |
| Saldo por 1.000 habitantes | -34,4 |

Principais origens de quem chegou e destinos de quem saiu (últimos 10
anos):

| Origem | Chegaram | Destino | Saíram |
|---|--:|---|--:|
| PA | 65.516 | GO | 92.615 |
| SP | 42.823 | PA | 89.913 |
| PI | 39.608 | SP | 70.534 |
| GO | 31.966 | MT | 62.560 |
| DF | 24.169 | PI | 35.638 |

## Mortalidade

Óbitos de agosto de 2021 a julho de 2022 informados no Censo.

| Indicador | MA | Brasil |
|---|--:|--:|
| Óbitos no período | 40.328 | 1.337.441 |
| Taxa bruta de mortalidade (por mil) | 6,0 | 6,6 |
| Esperança de vida ao nascer, total | 76,1 | 77,4 |
| Esperança de vida ao nascer, homens | 73,1 | 74,3 |
| Esperança de vida ao nascer, mulheres | 79,2 | 80,4 |
| Esperança de vida aos 60 anos, total | 23,1 | 23,4 |

**Atenção:** sem correção do sub-registro de óbitos do Censo; a mortalidade está subestimada e a esperança de vida, superestimada.

![Taxas específicas de mortalidade do Maranhão](graficos/curva_mortalidade.png)

## Arquivos

- [`resultados/indicadores.csv`](resultados/indicadores.csv): razões de dependência e índice de envelhecimento
- [`resultados/piramides.csv`](resultados/piramides.csv): população por sexo e grupo de idade (pirâmide)
- [`resultados/migracao.csv`](resultados/migracao.csv): naturalidade e saldo migratório
- [`resultados/naturalidade.csv`](resultados/naturalidade.csv): moradores por UF de nascimento
- [`resultados/fluxos_migracao.csv`](resultados/fluxos_migracao.csv): entradas e saídas por UF de origem/destino
- [`resultados/mortalidade.csv`](resultados/mortalidade.csv): óbitos, taxa bruta e esperança de vida
- [`resultados/tabuas_vida.csv`](resultados/tabuas_vida.csv): tábuas de vida abreviadas por sexo
- [`resultados/obitos_mensais.csv`](resultados/obitos_mensais.csv): óbitos por mês, jan/2019 a jul/2022
