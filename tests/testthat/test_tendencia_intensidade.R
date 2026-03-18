# ==============================
# Fixtures
# ==============================
.make_trajectories_mock <- function(n_semanas = 12, n_samples = 100) {
  datas <- seq(Sys.Date() - (n_semanas - 1) * 7, Sys.Date(), by = 7)
  data.frame(
    sample   = rep(seq_len(n_samples), each = n_semanas),
    Time     = rep(seq_len(n_semanas), n_samples),
    dt_event = rep(datas, n_samples),
    Y        = runif(n_semanas * n_samples, 10, 300),
    stringsAsFactors = FALSE
  )
}

.make_limiar_uf_mock <- function() {
  data.frame(
    estadoIBGE = 'SP',
    sem_risco  = 10,
    baixo      = 50,
    moderado   = 100,
    alto       = 200,
    muito_alto = 400,
    stringsAsFactors = FALSE
  )
}

# ==============================
# Testes — Intensidade
# ==============================
test_that('.calcular_intensidade_recorte retorna data.frame com 1 linha', {
  traj   <- .make_trajectories_mock()
  limiar <- .make_limiar_uf_mock()
  result <- .calcular_intensidade_recorte(traj, limiar)
  expect_s3_class(result, 'data.frame')
  expect_equal(nrow(result), 1)
})

test_that('.calcular_intensidade_recorte tem colunas obrigatórias', {
  traj   <- .make_trajectories_mock()
  limiar <- .make_limiar_uf_mock()
  result <- .calcular_intensidade_recorte(traj, limiar)
  expect_true(all(c('intensidade', 'prob') %in% colnames(result)))
})

test_that('prob da intensidade está entre 0 e 100', {
  traj   <- .make_trajectories_mock()
  limiar <- .make_limiar_uf_mock()
  result <- .calcular_intensidade_recorte(traj, limiar)
  expect_gte(result$prob, 0)
  expect_lte(result$prob, 100)
})

test_that('intensidade retorna nível válido', {
  traj    <- .make_trajectories_mock()
  limiar  <- .make_limiar_uf_mock()
  result  <- .calcular_intensidade_recorte(traj, limiar)
  niveis  <- unlist(NOWCAST_CONFIG$intensidade$niveis)
  expect_true(result$intensidade %in% niveis)
})

# ==============================
# Testes — Tendência
# ==============================
test_that('.classificar_tendencia adiciona coluna levels', {
  df <- data.frame(
    UF_IBGE   = c('SP', 'RJ', 'MG', 'BA', 'CE'),
    tendencia = c(-1.0, -0.5, 0.0, 0.5, 1.0)
  )
  result <- .classificar_tendencia(df)
  expect_true('levels' %in% colnames(result))
})

test_that('.classificar_tendencia classifica corretamente', {
  labels <- NOWCAST_CONFIG$tendencia$labels
  df <- data.frame(
    UF_IBGE   = c('AC', 'AL', 'AM', 'AP', 'BA'),
    tendencia = c(-1.0, -0.3, 0.0, 0.3, 1.0)
  )
  result <- .classificar_tendencia(df)
  expect_equal(as.character(result$levels[1]), labels[1])  # queda > 95%
  expect_equal(as.character(result$levels[5]), labels[5])  # cresc. > 95%
})

test_that('.classificar_tendencia não gera NAs inesperados', {
  df <- data.frame(
    UF_IBGE   = c('SP', 'RJ', 'MG'),
    tendencia = c(-1.0, 0.0, 1.0)
  )
  result <- .classificar_tendencia(df)
  expect_false(any(is.na(result$levels)))
})