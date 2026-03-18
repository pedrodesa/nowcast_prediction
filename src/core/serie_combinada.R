combinar_serie_nowcast <- function(serie_semanal, nowcast, config = NOWCAST_CONFIG) {
  
  log_info('Combinando série temporal com nowcast...')
  .check_required_pkgs(config$required_pkgs)
  
  serie_xts <- xts::xts(serie_semanal$n, order.by = serie_semanal$dt_event)
  
  .alinhar <- function(x) {
    xts::xts(
      c(rep(NA, length(serie_xts) - length(x)), x),
      order.by = zoo::index(serie_xts)
    )
  }
  
  serie_combinada <- cbind(
    Registros = serie_xts,
    Nowcast = .alinhar(nowcast$total$Median),
    Lower = .alinhar(nowcast$total$LI),
    Upper = .alinhar(nowcast$total$LS)
  )
  
  result <- as.data.frame(serie_combinada)
  result$Data <- as.Date(rownames(result))
  
  log_success('Série temporal combinada.')
  result
}
