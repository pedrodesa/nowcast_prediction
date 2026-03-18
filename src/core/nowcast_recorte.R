.nowcast_por_recorte <- function(dados, coluna_recorte, config = NOWCAST_CONFIG) {
  
  recortes <- split(dados, dados[[coluna_recorte]])
  saida <- list()
  
  for (chave in names(recortes)) {
    
    dados_recorte <- recortes[[chave]]
    
    if (nrow(dados_recorte) < config$min_obs) {
      log_warn(sprintf('Recorte "%s" ignorado (poucos registros).', chave))
      next
    }
    
    nowcast <- tryCatch(
      .run_nowcast_inla(dados_recorte, config$vars, config$model_params),
      error = function(e) {
        log_warn(sprintf('Nowcast falhou para "%s": %s', chave, e$message))
        NULL
      }
    )
    
    if (is.null(nowcast)) next
    
    serie <- criar_serie_semanal(dados_recorte, config)
    serie_final <- combinar_serie_nowcast(serie, nowcast, config)
    serie_final[[coluna_recorte]] <- chave
    
    saida[[chave]] <- list(
      nowcast = nowcast,
      serie = serie,
      serie_final = serie_final
    )
  }
  
  saida
}