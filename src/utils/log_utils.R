configurar_log <- function(config = NOWCAST_CONFIG) {
  
  require(logger)
  
  dir.create(here::here(config$paths$logs), showWarnings = FALSE, recursive = TRUE)
  
  path_log <- here::here(
    config$paths$logs,
    format(Sys.time(), 'run_%Y%m%d_%H%M%S.log')
  )
  
  logger::log_appender(logger::appender_tee(path_log))
  
  log_info(sprintf('Log iniciado: %s', path_log))
  
  invisible(path_log)
}