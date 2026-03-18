.calcular_intensidade_recorte <- function(trajectories, limiar_uf, config = NOWCAST_CONFIG) {
  
  int    <- config$intensadores
  niveis <- config$intensidade$niveis
  window <- config$intensidade$window
  
  inten <- trajectories |>
    dplyr::group_by(sample, Time, dt_event) |>
    dplyr::summarise(Y = sum(Y), .groups = 'drop') |>
    dplyr::filter(dt_event > max(dt_event) - window * 7) |>
    dplyr::summarise(
      !!niveis$baixo_risco := mean(Y < limiar_uf$baixo),
      !!niveis$seguranca := mean(Y >= limiar_uf$baixo   & Y < limiar_uf$moderado),
      !!niveis$alerta := mean(Y >= limiar_uf$moderado & Y < limiar_uf$alto),
      !!niveis$risco := mean(Y >= limiar_uf$alto     & Y < limiar_uf$muito_alto),
      !!niveis$alto_risco := mean(Y >= limiar_uf$muito_alto)
    ) |>
    tidyr::pivot_longer(
      everything(),
      names_to  = 'intensidade',
      values_to = 'prob'
    ) |>
    dplyr::mutate(prob = round(prob * 100, 1))
  
  inten[which.max(inten$prob), ]
}


.calcular_intensidade_por_recorte <- function(nowcast_uf, limiares, config = NOWCAST_CONFIG) {
  
  col_uf <- config$vars$col_uf
  saida  <- list()
  
  for (uf in names(nowcast_uf$por_uf)) {
    
    traj   <- nowcast_uf$por_uf[[uf]]$nowcast$trajectories
    lim_uf <- dplyr::filter(limiares, .data[[config$vars$col_uf_pop]] == uf)
    
    if (is.null(traj) || nrow(lim_uf) == 0) {
      log_warn(sprintf('Intensidade ignorada para "%s": trajectories ou limiar ausente.', uf))
      next
    }
    
    sem_rec  <- .extrair_semana_recente(nowcast_uf, uf, config)
    
    resultado <- .calcular_intensidade_recorte(traj, lim_uf, config)
    resultado[[col_uf]] <- uf
    resultado[['ANO_EPI']]   <- sem_rec$ano
    resultado[['SEMANA_EPI']] <- sem_rec$semana 
    
    saida[[uf]] <- resultado
  }
  
  dplyr::bind_rows(saida)
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