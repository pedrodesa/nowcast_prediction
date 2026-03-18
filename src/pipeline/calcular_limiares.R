calcular_limiares <- function(dados, config = NOWCAST_CONFIG) {
  
  log_info('Iniciando cálculo de limiares epidemiológicos...')
  
  .check_required_pkgs(c(config$required_pkgs, 'readxl', 'tidyr'))
  
  pop <- .ler_populacao(config$paths$pop,    config)
  limiares <- .ler_limiares(config$paths$limiar,  config)
  
  resultado <- .calcular_serie_limiar(dados, pop, limiares, config)
  
  log_success('Limiares calculados com sucesso.')
  
  list(
    populacao = pop,
    limiares = limiares,
    serie_final = resultado
  )
}