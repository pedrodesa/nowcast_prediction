calcular_tendencias <- function(nowcast_uf, config = NOWCAST_CONFIG) {
  
  log_info('Iniciando cálculo de tendências por UF...')
  .check_required_pkgs(config$required_pkgs)
  
  df_tendencias <- .calcular_tendencia_por_recorte(nowcast_uf, config) |>
    .classificar_tendencia(config)
  
  log_success('Tendências por UF calculadas.')
  
  df_tendencias
}