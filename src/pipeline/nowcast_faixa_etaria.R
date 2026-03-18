nowcast_faixa_etaria <- function(data, config = NOWCAST_CONFIG) {
  
  log_info('Iniciando nowcast por faixa etária...')
  .check_required_pkgs(config$required_pkgs)
  
  result <- .nowcast_por_recorte(data, coluna_recorte = 'Faixa', config)
  
  log_success('Nowcast por faixa etária finalizado.')
  
  list(
    por_faixa_etaria = result,
    serie_final = dplyr::bind_rows(
      lapply(result, `[[`, 'serie_final')
    )
  )
}
