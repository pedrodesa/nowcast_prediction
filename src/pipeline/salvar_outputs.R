salvar_outputs <- function(serie_consolidada, res_faixa_etaria, res_intensidade, res_tendencias, config = NOWCAST_CONFIG) {
  
  readr::write_csv2(serie_consolidada, here::here('data/processed/df_nowcast.csv'))
  readr::write_csv2(res_faixa_etaria, here::here('data/processed/df_faixa_etaria.csv'))
  readr::write_csv2(res_intensidade,   here::here('data/processed/df_intensidade.csv'))
  readr::write_csv2(res_tendencias,    here::here('data/processed/df_tendencias.csv'))
  
  log_success('Outputs salvos em data/processed/')
}