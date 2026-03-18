criar_serie_semanal <- function(data, config = NOWCAST_CONFIG) {
  
  log_info('Criando série temporal semanal...')
  .check_required_pkgs(config$required_pkgs)
  
  result <- data |>
    dplyr::mutate(
      semana_epi = lubridate::epiweek(.data[[config$vars$date_onset]]),
      ano_epi = lubridate::epiyear(.data[[config$vars$date_onset]]),
      dt_event = aweek::get_date(semana_epi, ano_epi, start = 7)
    ) |>
    dplyr::count(dt_event)
  
  log_success('Série semanal criada.')
  result
}