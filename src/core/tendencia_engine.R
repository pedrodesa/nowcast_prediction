.calcular_tendencia_por_recorte <- function(nowcast_uf, config = NOWCAST_CONFIG) {
  
  col_uf <- config$vars$col_uf
  window <- config$tendencia$window
  saida <- list()
  
  for (uf in names(nowcast_uf$por_uf)) {
    
    traj <- nowcast_uf$por_uf[[uf]]$nowcast$trajectories
    
    if (is.null(traj)) {
      log_warn(sprintf('Tendência ignorada para "%s": trajectories ausente.', uf))
      next
    }
    
    slope <- nowcaster::slope.estimate.quant(
      trajectories = traj,
      window       = window
    )
    
    sem_rec  <- .extrair_semana_recente(nowcast_uf, uf, config)
    
    # ← setNames() em vez de := dentro de data.frame()
    saida[[uf]] <- setNames(
      data.frame(uf, slope, sem_rec$ano, sem_rec$semana),
      c(col_uf, 'tendencia', 'ANO_EPI', 'SEMANA_EPI')
    )
  }
  
  dplyr::bind_rows(saida)
}


.classificar_tendencia <- function(df_tendencias, config = NOWCAST_CONFIG) {
  
  breaks <- config$tendencia$breaks
  labels <- config$tendencia$labels
  col_uf <- config$vars$col_uf
  
  df_tendencias |>
    dplyr::mutate(
      levels = cut(
        tendencia,
        breaks         = breaks,
        labels         = labels,
        include.lowest = TRUE,
        right          = FALSE
      )
    )
}


.extrair_semana_recente <- function(nowcast_uf, uf, config = NOWCAST_CONFIG) {
  
  serie <- nowcast_uf$por_uf[[uf]]$serie_final
  
  if (is.null(serie) || nrow(serie) == 0) return(list(ano = NA_integer_, semana = NA_integer_))
  
  data_recente <- max(serie$Data, na.rm = TRUE)
  
  list(
    ano    = lubridate::epiyear(data_recente),
    semana = lubridate::epiweek(data_recente)
  )
}