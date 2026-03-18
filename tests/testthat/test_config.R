test_that('NOWCAST_CONFIG existe e tem estrutura completa', {
  expect_true(exists('NOWCAST_CONFIG'))
  expect_type(NOWCAST_CONFIG, 'list')
})

test_that('NOWCAST_CONFIG$vars tem campos obrigatórios', {
  expect_true(!is.null(NOWCAST_CONFIG$vars$date_onset))
  expect_true(!is.null(NOWCAST_CONFIG$vars$date_report))
  expect_true(!is.null(NOWCAST_CONFIG$vars$col_uf))
  expect_true(!is.null(NOWCAST_CONFIG$vars$col_uf_pop))
})

test_that('NOWCAST_CONFIG$model_params tem campos obrigatórios', {
  expect_true(!is.null(NOWCAST_CONFIG$model_params$Dmax))
  expect_true(!is.null(NOWCAST_CONFIG$model_params$wdw))
  expect_true(!is.null(NOWCAST_CONFIG$model_params$data.by.week))
  expect_type(NOWCAST_CONFIG$model_params$Dmax, 'double')
  expect_type(NOWCAST_CONFIG$model_params$wdw,  'double')
})

test_that('NOWCAST_CONFIG$paths aponta para arquivos existentes', {
  expect_true(file.exists(here::here(NOWCAST_CONFIG$paths$pop)))
  expect_true(file.exists(here::here(NOWCAST_CONFIG$paths$limiar)))
})

test_that('NOWCAST_CONFIG$wrangling tem colunas definidas', {
  expect_true(length(NOWCAST_CONFIG$wrangling$cols_iniciais) > 0)
  expect_true(length(NOWCAST_CONFIG$wrangling$cols_finais)   > 0)
  expect_true(length(NOWCAST_CONFIG$wrangling$cols_data)     > 0)
  expect_true(NOWCAST_CONFIG$wrangling$janela_semanas > 0)
})

test_that('NOWCAST_CONFIG$tendencia tem breaks e labels corretos', {
  breaks <- NOWCAST_CONFIG$tendencia$breaks
  labels <- NOWCAST_CONFIG$tendencia$labels
  expect_equal(length(labels), length(breaks) - 1)
  expect_true(all(diff(breaks) > 0))  # breaks em ordem crescente
})

test_that('NOWCAST_CONFIG$indicadores tem campos obrigatórios', {
  expect_true(!is.null(NOWCAST_CONFIG$indicadores$anos_pop))
  expect_true(!is.null(NOWCAST_CONFIG$indicadores$fator_incidencia))
  expect_true(!is.null(NOWCAST_CONFIG$indicadores$media_movel_k))
  expect_gt(NOWCAST_CONFIG$indicadores$fator_incidencia, 0)
})