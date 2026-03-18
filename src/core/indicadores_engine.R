.calcular_serie_limiar <- function(dados, pop, limiares, config = NOWCAST_CONFIG) {
  
  ind <- config$indicadores
  vars <- config$vars
  col_uf <- vars$col_uf
  col_uf_pop <- vars$col_uf_pop
  
  # join dinâmico: c('estadoIBGE' = 'regiao')
  by_limiar <- setNames('regiao', col_uf_pop)
  
  dados |>
    dplyr::mutate(
      semana_epi = lubridate::epiweek(.data[[vars$date_onset]]),
      ano_epi = lubridate::epiyear(.data[[vars$date_onset]])
    ) |>
    dplyr::group_by(.data[[col_uf]], ano_epi, semana_epi) |>
    dplyr::summarise(casos = dplyr::n(), .groups = 'drop') |>
    dplyr::rename(!!col_uf_pop := !!col_uf) |>
    dplyr::left_join(pop, by = c(col_uf_pop, 'ano_epi')) |>
    dplyr::left_join(limiares, by = by_limiar) |>        # ← corrigido
    dplyr::mutate(
      incidencia  = casos * ind$fator_incidencia / populacao,
      media_movel = zoo::rollmean(casos, k = ind$media_movel_k, fill = NA, align = 'center')
    )
}
