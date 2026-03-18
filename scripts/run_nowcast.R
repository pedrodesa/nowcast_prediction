source(here::here('.Rprofile'))

# === Configurar log ===
configurar_log()

config_paths <- yaml::read_yaml("./config/config.yml")

PATH_RAW_FILE <- config_paths$paths$path_data_input
PATH_RAW_DATA <- file.path(PATH_RAW_FILE, "dados_nowcast_covid.parquet")

# === Baixar arquivo de dados do Sharepoint ===
# baixar_parquet_sharepoint()

# === Dados brutos ===
dados <- arrow::read_parquet(PATH_RAW_DATA)

# === Validação de dados ===
validar_dados(dados)

# === Tratamento de dados ===
dados_tratados <- tratamento_de_dados(dados)

# === Resultados do nowcast ===
res_nacional <- nowcast_nacional(dados_tratados)

res_uf <- nowcast_uf(dados_tratados)

res_faixa_etaria <- nowcast_faixa_etaria(dados_tratados)

# === Resultados dos indicadores ===
res_limiares <- calcular_limiares(dados_tratados)

serie_consolidada <- consolidar_series(res_nacional, res_uf, res_limiares)

res_intensidade <- calcular_intensidade(res_uf, res_limiares)

res_tendencias <- calcular_tendencias(res_uf)

# === Exportar tabelas CSV ===
salvar_outputs(
  serie_consolidada,
  res_faixa_etaria$serie_final,
  res_intensidade,
  res_tendencias
)
