########################################
# ========== EXPORTAR DADOS ========== #
########################################

# Função para exportar os outputs em formato json
exportar_dados_json <- function(serie_combinada_df_br, df_limiar_nowcast) {
  
  require(jsonlite)
  
  serie_combinada_df_br$cod <- 'BR'
  serie_combinada_df_br$ymin <- NA
  serie_combinada_df_br$ymax <- NA
  serie_combinada_df_br$sem_risco <- NA
  serie_combinada_df_br$baixo <- NA
  serie_combinada_df_br$moderado <- NA
  serie_combinada_df_br$alto <- NA
  serie_combinada_df_br$muito_alto <- NA
  
  colnames(df_limiar_nowcast) <- c(
    'Registros',
    'Nowcast',
    'Lower', 
    'Upper',
    'Data', 
    'cod',
    'ymin',
    'ymax',
    'sem_risco',
    'baixo',
    'moderado',
    'alto',
    'muito_alto'
  )
  
  rownames(serie_combinada_df_br) <- NULL
  
  df_nowcast_final <- rbind(serie_combinada_df_br, df_limiar_nowcast)
  
  write_json(df_nowcast_final, "/app/data/output/dados_nowcast.json")
  
}

