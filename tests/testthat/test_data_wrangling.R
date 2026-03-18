# ==============================
# Fixture — dado mínimo válido
# ==============================
.make_dados_brutos <- function(n = 100) {
  data.frame(
    dataInicioSintomas = Sys.Date() - sample(1:100, n, replace = TRUE),
    dataNotificacao    = Sys.Date() - sample(1:90,  n, replace = TRUE),
    dataEncerramento   = Sys.Date() - sample(1:80,  n, replace = TRUE),
    dataRegistro       = Sys.Date() - sample(1:70,  n, replace = TRUE),
    regiao             = sample(c('Sudeste', 'Sul', 'Nordeste'), n, replace = TRUE),
    estadoIBGE         = sample(c(35, 33, 29, 41), n, replace = TRUE),
    idade              = sample(1:90, n, replace = TRUE),
    stringsAsFactors   = FALSE
  )
}

# ==============================
# Testes
# ==============================
test_that('tratamento_de_dados retorna data.frame', {
  dados  <- .make_dados_brutos()
  result <- tratamento_de_dados(dados)
  expect_s3_class(result, 'data.frame')
})

test_that('tratamento_de_dados retorna colunas obrigatórias', {
  dados  <- .make_dados_brutos()
  result <- tratamento_de_dados(dados)
  cols_esperadas <- NOWCAST_CONFIG$wrangling$cols_finais
  expect_true(all(cols_esperadas %in% colnames(result)))
})

test_that('colunas de data são do tipo Date', {
  dados  <- .make_dados_brutos()
  result <- tratamento_de_dados(dados)
  cols_data <- NOWCAST_CONFIG$wrangling$cols_data
  tipos_ok  <- vapply(result[cols_data], inherits, logical(1), 'Date')
  expect_true(all(tipos_ok))
})

test_that('coluna Faixa não tem valores inesperados', {
  dados   <- .make_dados_brutos()
  result  <- tratamento_de_dados(dados)
  labels  <- NOWCAST_CONFIG$wrangling$faixas_etarias$labels
  valores <- unique(na.omit(result$Faixa))
  expect_true(all(valores %in% labels))
})

test_that('coluna UF_IBGE não tem valores inesperados', {
  dados    <- .make_dados_brutos()
  result   <- tratamento_de_dados(dados)
  ufs_validas <- NOWCAST_CONFIG$wrangling$tabela_ibge$UF_IBGE
  valores  <- unique(na.omit(result$UF_IBGE))
  expect_true(all(valores %in% ufs_validas))
})

test_that('filtro temporal limita a janela correta', {
  dados    <- .make_dados_brutos(n = 200)
  result   <- tratamento_de_dados(dados)
  data_max <- max(result$dataInicioSintomas)
  data_min <- min(result$dataInicioSintomas)
  janela   <- NOWCAST_CONFIG$wrangling$janela_semanas
  expect_gte(as.numeric(data_max - data_min), 0)
  expect_lte(as.numeric(data_max - data_min), janela * 7)
})

test_that('tratamento_de_dados falha com colunas ausentes', {
  dados_incompletos <- data.frame(idade = 1:10)
  expect_error(tratamento_de_dados(dados_incompletos), 'colunas obrigatórias ausentes')
})

test_that('tratamento_de_dados falha com dataInicioSintomas todo NA', {
  dados <- .make_dados_brutos()
  dados$dataInicioSintomas <- NA
  expect_error(tratamento_de_dados(dados))
})