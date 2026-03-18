NOWCAST_CONFIG <- list(
  
  required_pkgs = c(
    'dplyr', 
    'logger',
    'lubridate', 
    'INLA', 
    'nowcaster',
    'xts', 
    'zoo', 
    'aweek'
  ),
  
  validation = list(
    min_rows = 30,
    max_lag_dias = 100,
    max_pct_na = 20
  ),
  
  wrangling = list(
    
    cols_iniciais = c(
      'dataInicioSintomas', 'dataNotificacao', 'dataEncerramento',
      'dataRegistro', 'regiao', 'estadoIBGE', 'idade'
    ),
    
    cols_data = c(
      'dataInicioSintomas', 'dataNotificacao',
      'dataEncerramento',   'dataRegistro'
    ),
    
    cols_finais = c(
      'dataInicioSintomas', 'dataNotificacao', 'dataEncerramento',
      'dataRegistro', 'regiao', 'estadoIBGE', 'idade', 'Faixa', 'UF_IBGE'
    ),
    
    janela_semanas = 25,
    
    faixas_etarias = list(
      menor_que  = c(NA, 20),
      breaks     = c(20, 39, 40, 59, 60, 69, 70, 79),
      maior_que  = 80,
      labels     = c('menor que 20', '20 a 39', '40 a 59', '60 a 69', '70 a 79', '80 ou mais')
    ),
    
    tabela_ibge = tibble::tibble(
      estadoIBGE = c(11,12,13,14,15,16,17,21,22,23,24,25,26,27,28,29,31,32,33,35,41,42,43,50,51,52,53),
      UF_IBGE    = c('RO','AC','AM','RR','PA','AP','TO','MA','PI','CE','RN','PB',
                     'PE','AL','SE','BA','MG','ES','RJ','SP','PR','SC','RS','MS','MT','GO','DF')
    )
  ),
  
  vars = list(
    date_onset = 'dataInicioSintomas',
    date_report = 'dataRegistro',
    col_uf = 'UF_IBGE',
    col_uf_pop = 'estadoIBGE'
  ),
  
  model_params = list(
    data.by.week = TRUE,
    trajectories = FALSE,
    Dmax = 6,
    wdw = 12
  ),
  
  min_obs = 10,
  
  indicadores = list(
    anos_pop = as.character(2023:2025),
    skip_pop = 5,
    regioes_excluir = c('Norte', 'Nordeste', 'Centro-Oeste', 'Sudeste', 'Sul', 'Brasil'),
    sexo_pop = 'Ambos',
    escala_limiar = 'casos',
    media_movel_k = 3,
    fator_incidencia = 100000
  ),
  
  intensidade = list(
    window = 2,
    col_uf_geo = 'abbrev_state',
    niveis = list(
      baixo_risco = 'Baixo risco',
      seguranca = 'Segurança',
      alerta = 'Alerta',
      risco = 'Risco',
      alto_risco = 'Alto risco'
    )
  ),
  
  tendencia = list(
    window = 6,
    
    breaks = c(-1, -0.5, -0.01, 0.01, 0.5, 1),
    labels = c(
      'Prob. queda > 95%',
      'Prob. queda > 75%',
      'Estabilidade/oscilação',
      'Prob. cresc. > 75%',
      'Prob. cresc. > 95%'
    )
  ),
  
  paths = list(
    pop = 'data/external/projecoes_2024_tab1_idade_simples.xlsx',
    limiar = 'data/external/limiares_UF_COVID_inci_casos_18jan26.csv',
    cache     = 'data/raw/casos_cache.rds',
    cache_geo = 'data/raw/geometria_ufs.rds',
    logs = 'data/logs'
  )
)