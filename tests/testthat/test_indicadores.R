# ==============================
# Fixtures
# ==============================
.make_pop_mock <- function() {
  data.frame(
    estadoIBGE = c('SP', 'RJ', 'MG'),
    ano_epi    = c(2024, 2024, 2024),
    populacao  = c(46649132, 17366189, 21411923),
    stringsAsFactors = FALSE
  )
}

.make_limiares_mock <- function() {
  data.frame(
    regiao     = c('SP', 'RJ', 'MG'),
    sem_risco  = c(10, 12, 8),
    baixo      = c(50, 55, 45),
    moderado   = c(100, 110, 90),
    alto       = c(200, 210, 180),
    muito_alto = c(400, 420, 360),
    stringsAsFactors = FALSE
  )
}

.make_dados_serie_mock <- function(n = 50) {
  data.frame(
    dataInicioSintomas = Sys.Date() - sample(1:150, n, replace = TRUE),
    UF_IBGE = sample(c('SP', 'RJ', 'MG'), n, replace = TRUE),
    stringsAsFactors = FALSE
  )
}

# ==============================
# Testes
# ==============================
test_that('.calcular_serie_limiar retorna data.frame', {
  dados    <- .make_dados_serie_mock()
  pop      <- .make_pop_mock()
  limiares <- .make_limiares_mock()
  result   <- .calcular_serie_limiar(dados, pop, limiares)
  expect_s3_class(result, 'data.frame')
})

test_that('.calcular_serie_limiar tem coluna incidencia positiva', {
  dados    <- .make_dados_serie_mock()
  pop      <- .make_pop_mock()
  limiares <- .make_limiares_mock()
  result   <- .calcular_serie_limiar(dados, pop, limiares)
  expect_true('incidencia' %in% colnames(result))
  valores  <- na.omit(result$incidencia)
  if (length(valores) > 0) expect_true(all(valores >= 0))
})

test_that('.calcular_serie_limiar tem coluna media_movel', {
  dados    <- .make_dados_serie_mock()
  pop      <- .make_pop_mock()
  limiares <- .make_limiares_mock()
  result   <- .calcular_serie_limiar(dados, pop, limiares)
  expect_true('media_movel' %in% colnames(result))
})

test_that('.calcular_serie_limiar tem colunas de limiares', {
  dados    <- .make_dados_serie_mock()
  pop      <- .make_pop_mock()
  limiares <- .make_limiares_mock()
  result   <- .calcular_serie_limiar(dados, pop, limiares)
  cols     <- c('sem_risco', 'baixo', 'moderado', 'alto', 'muito_alto')
  expect_true(all(cols %in% colnames(result)))
})