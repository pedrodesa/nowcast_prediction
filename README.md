# Estimativas Nowcast - Síndrome gripal pela covid-19
---

1. Objetivo:
Estimar o atraso nos registros de notificação de síndrome gripal pela covid-19.

2. Usuários:
Área técnica e equipe de vigilância epidemiológica de covid-19.

3. Dados:
Os dados utilizados são do sistema de informação e-SUS Notifica do Ministério da Saúde.

4. Organização do projeto

```
.
├── config
│   └── config.yml
├── data
│   ├── external
│   │   ├── datas_de_atualizacao.csv
│   │   ├── datas_de_atualizacao.xlsx
│   │   ├── limiares_UF_COVID_inci_casos_18jan26.csv
│   │   ├── limiar_long_UF_media.csv
│   │   └── projecoes_2024_tab1_idade_simples.xlsx
│   ├── logs
│   │   ├── log_2026-01-09.log
│   │   ├── log_2026-02-24.log
│   │   ├── run_20260317_144600.log
│   │   ├── run_20260317_161843.log
│   │   ├── run_20260317_164411.log
│   │   ├── run_20260318_112302.log
│   │   └── run_20260318_112437.log
│   ├── outputs
│   ├── processed
│   │   ├── df_faixa_etaria.csv
│   │   ├── df_intensidade.csv
│   │   ├── df_nowcast.csv
│   │   └── df_tendencias.csv
│   └── raw
│       └── dados_nowcast_covid.parquet
├── Dockerfile
├── docs
│   └── img
│       └── tree.png
├── install_packages.R
├── notebooks
│   ├── report_nowcast_covid_Mari.Rmd
│   └── report_nowcast_covid.Rmd
├── nowcast_covid.Rproj
├── README.md
├── scripts
│   ├── run_nowcast.R
│   └── setup.R
├── src
│   ├── config
│   │   └── config_nowcast.R
│   ├── core
│   │   ├── indicadores_engine.R
│   │   ├── indicadores_readers.R
│   │   ├── intensidade_engine.R
│   │   ├── nowcast_engine.R
│   │   ├── nowcast_recorte.R
│   │   ├── serie_combinada.R
│   │   ├── serie_semanal.R
│   │   └── tendencia_engine.R
│   ├── data
│   │   ├── data_wrangling.R
│   │   └── validate_data.R
│   ├── extract
│   │   ├── extract_data.R
│   │   └── load_data.R
│   ├── pipeline
│   │   ├── calcular_intensidade.R
│   │   ├── calcular_limiares.R
│   │   ├── calcular_tendencias.R
│   │   ├── consolidar_series.R
│   │   ├── nowcast_faixa_etaria.R
│   │   ├── nowcast_nacional.R
│   │   ├── nowcast_uf.R
│   │   └── salvar_outputs.R
│   └── utils
│       ├── log_utils.R
│       └── pkg_utils.R
└── tests
    ├── testthat
    │   ├── test_config.R
    │   ├── test_consolidar_series.R
    │   ├── test_data_wrangling.R
    │   ├── test_indicadores.R
    │   ├── test_nowcast_engine.R
    │   ├── test_pkg_utils.R
    │   └── test_tendencia_intensidade.R
    └── testthat.R
```
