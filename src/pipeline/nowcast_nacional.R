nowcast_nacional <- function(data, config = NOWCAST_CONFIG) {
  
  log_info('Iniciando nowcast nacional...')
  
  .check_required_pkgs(config$required_pkgs)
  log_info('Pacotes verificados com sucesso.')
  
  nowcast <- .run_nowcast_inla(
    data = data,
    vars = config$vars,
    model_params = config$model_params
  )
  
  serie <- criar_serie_semanal(data, config)
  
  serie_final <- combinar_serie_nowcast(serie, nowcast, config)
  
  log_success('Nowcast Brasil finalizado.')
  
  list(
    nowcast = nowcast,
    serie = serie,
    serie_final = serie_final
  )
}
