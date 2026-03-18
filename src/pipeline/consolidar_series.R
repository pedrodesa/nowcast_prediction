consolidar_series <- function(res_nacional, res_uf, res_limiares, config = NOWCAST_CONFIG) {
  
  log_info('Iniciando consolidação das séries...')
  .check_required_pkgs(c(config$required_pkgs, 'dplyr'))
  
  # Adiciona coluna UF_IBGE = 'BR' no resultado nacional
  res_nacional_br <- res_nacional$serie_final |>
    dplyr::mutate(!!config$vars$col_uf := 'BR')
  
  log_info('Coluna UF_IBGE adicionada ao resultado nacional.')
  
  # Empilha nacional (BR) com UFs
  serie_empilhada <- rbind(res_nacional_br, res_uf$serie_final)
  
  log_info('rbind entre série nacional e séries por UF realizado.')
  
  # Colunas de limiares a agregar — renomeia para alinhar com col_uf
  cols_limiares <- c(config$vars$col_uf_pop, 'sem_risco', 'baixo', 'moderado', 'alto', 'muito_alto')
  
  limiares_lookup <- res_limiares$serie_final |>
    dplyr::select(dplyr::all_of(cols_limiares)) |>
    dplyr::distinct() |>
    dplyr::rename(!!config$vars$col_uf := config$vars$col_uf_pop)  # ← correção
  
  # Agrega limiares e cria coluna credibilidade
  serie_final <- serie_empilhada |>
    dplyr::left_join(limiares_lookup, by = config$vars$col_uf) |>
    dplyr::mutate(
      credibilidade = dplyr::case_when(
        !is.na(Registros) & !is.na(Nowcast) ~ Nowcast,
        !is.na(Registros) &  is.na(Nowcast) ~ Registros,
        TRUE                                ~ NA_real_
      )
    ) |>
    as.data.frame()
  
  log_success('Consolidação das séries finalizada.')
  
  serie_final
}