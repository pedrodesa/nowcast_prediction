calcular_intensidade <- function(nowcast_uf, res_limiares, config = NOWCAST_CONFIG) {
  
  log_info('Iniciando cálculo de intensidade por UF...')
  .check_required_pkgs(c(config$required_pkgs, 'dplyr', 'tidyr'))
  
  df_intensidade <- .calcular_intensidade_por_recorte(
    nowcast_uf = nowcast_uf,
    limiares   = res_limiares$serie_final,
    config     = config
  )
  
  log_success('Intensidade por UF calculada.')
  
  df_intensidade
}