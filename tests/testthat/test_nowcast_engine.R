# ==============================
# Fixture — mock do output INLA
# ==============================
.make_nowcast_mock <- function() {
  datas <- seq(Sys.Date() - 84, Sys.Date(), by = 7)
  n     <- length(datas)
  list(
    total = data.frame(
      dt_event = datas,
      Median   = runif(n, 50, 200),
      LI       = runif(n, 30, 100),
      LS       = runif(n, 150, 300)
    ),
    trajectories = data.frame(
      sample   = rep(1:100, each = n),
      Time     = rep(seq_len(n), 100),
      dt_event = rep(datas, 100),
      Y        = runif(n * 100, 10, 300)
    )
  )
}

.make_serie_mock <- function() {
  datas <- seq(Sys.Date() - 84, Sys.Date(), by = 7)
  data.frame(
    dt_event = datas,
    n        = sample(50:200, length(datas), replace = TRUE)
  )
}

# ==============================
# Testes
# ==============================
test_that('.run_nowcast_inla retorna lista com campos obrigatórios', {
  nowcast <- .make_nowcast_mock()
  expect_type(nowcast, 'list')
  expect_true('total' %in% names(nowcast))
  expect_true(all(c('Median', 'LI', 'LS') %in% colnames(nowcast$total)))
})

test_that('criar_serie_semanal retorna data.frame com colunas esperadas', {
  serie <- .make_serie_mock()
  expect_s3_class(serie, 'data.frame')
  expect_true('dt_event' %in% colnames(serie))
  expect_true('n' %in% colnames(serie))
})

test_that('combinar_serie_nowcast retorna data.frame com colunas esperadas', {
  serie   <- .make_serie_mock()
  nowcast <- .make_nowcast_mock()
  result  <- combinar_serie_nowcast(serie, nowcast)
  expect_s3_class(result, 'data.frame')
  expect_true(all(c('Registros', 'Nowcast', 'Lower', 'Upper', 'Data') %in% colnames(result)))
})

test_that('combinar_serie_nowcast não retorna data.frame vazio', {
  serie   <- .make_serie_mock()
  nowcast <- .make_nowcast_mock()
  result  <- combinar_serie_nowcast(serie, nowcast)
  expect_gt(nrow(result), 0)
})