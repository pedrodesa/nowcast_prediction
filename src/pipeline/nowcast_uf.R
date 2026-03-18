nowcast_uf <- function(data, config = NOWCAST_CONFIG) {
  
  log_info('Iniciando nowcast por UF...')
  .check_required_pkgs(config$required_pkgs)
  
  config$model_params$trajectories <- TRUE
  result <- .nowcast_por_recorte(data, coluna_recorte = 'UF_IBGE', config)
  
  log_success('Nowcast por UF finalizado.')
  
  list(
    por_uf = result,
    serie_final = dplyr::bind_rows(
      lapply(result, `[[`, 'serie_final')
    )
  )
}
