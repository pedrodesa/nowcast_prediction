.run_nowcast_inla <- function(data, vars, model_params) {
  
  args <- c(
    list(dataset = data, 
         date_onset = vars$date_onset, 
         date_report = vars$date_report
           ),
    model_params
  )
  
  result <- do.call(nowcaster::nowcasting_inla, args)
  
  if (!inherits(result, 'list')) {
    stop('Erro na execução do nowcast: retorno inesperado.')
  }
  
  result
}
