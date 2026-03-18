# ==============================
# Fixtures
# ==============================
.make_serie_final <- function(ufs = c('SP', 'RJ'), n_semanas = 12) {
  datas <- seq(Sys.Date() - (n_semanas - 1) * 7, Sys.Date(), by = 7)
  do.call(rbind, lapply(ufs, function(uf) {
    data.frame(
      Data      = datas,
      Registros = c(sample(50:200, n_semanas - 4, replace = TRUE), rep(NA, 4)),
      Nowcast   = c(rep(NA, n_semanas - 4), runif(4, 100, 300)),
      Lower     = c(rep(NA, n_semanas - 4), runif(4, 50,  200)),
      Upper     = c(rep(NA, n_semanas - 4), runif(4, 200, 400)),
      UF_IBGE   = uf,
      stringsAsFactors = FALSE
    )
  }))
}

.make_res_nacional_mock <- function() {
  serie <- .make_serie_final(ufs = 'BR')
  serie$UF_IBGE <- NULL
  list(serie_final = serie)
}

.make_res_uf_mock <- function() {
  list(serie_final = .make_serie_final(ufs = c('SP', 'RJ', 'MG')))
}

.make_res_limiares_mock <- function() {
  list(
    serie_final = data.frame(
      estadoIBGE = c('SP', 'RJ', 'MG'),
      sem_risco  = c(10, 12, 8),
      baixo      = c(50, 55, 45),
      moderado   = c(100, 110, 90),
      alto       = c(200, 210, 180),
      muito_alto = c(400, 420, 360),
      stringsAsFactors = FALSE
    )
  )
}

# ==============================
# Testes
# ==============================
test_that('consolidar_series retorna data.frame', {
  result <- consolidar_series(
    .make_res_nacional_mock(),
    .make_res_uf_mock(),
    .make_res_limiares_mock()
  )
  expect_s3_class(result, 'data.frame')
})

test_that('consolidar_series tem coluna UF_IBGE com BR e UFs', {
  result <- consolidar_series(
    .make_res_nacional_mock(),
    .make_res_uf_mock(),
    .make_res_limiares_mock()
  )
  expect_true('UF_IBGE' %in% colnames(result))
  expect_true('BR' %in% result$UF_IBGE)
})

test_that('consolidar_series tem colunas de limiares', {
  result <- consolidar_series(
    .make_res_nacional_mock(),
    .make_res_uf_mock(),
    .make_res_limiares_mock()
  )
  cols_limiar <- c('sem_risco', 'baixo', 'moderado', 'alto', 'muito_alto')
  expect_true(all(cols_limiar %in% colnames(result)))
})

test_that('coluna credibilidade usa Nowcast quando ambos presentes', {
  result <- consolidar_series(
    .make_res_nacional_mock(),
    .make_res_uf_mock(),
    .make_res_limiares_mock()
  )
  linhas_ambos <- !is.na(result$Registros) & !is.na(result$Nowcast)
  if (any(linhas_ambos)) {
    expect_equal(
      result$credibilidade[linhas_ambos],
      result$Nowcast[linhas_ambos]
    )
  }
})

test_that('coluna credibilidade usa Registros quando Nowcast é NA', {
  result <- consolidar_series(
    .make_res_nacional_mock(),
    .make_res_uf_mock(),
    .make_res_limiares_mock()
  )
  linhas_so_reg <- !is.na(result$Registros) & is.na(result$Nowcast)
  if (any(linhas_so_reg)) {
    expect_equal(
      result$credibilidade[linhas_so_reg],
      result$Registros[linhas_so_reg]
    )
  }
})

test_that('coluna credibilidade é NA quando Registros é NA', {
  result <- consolidar_series(
    .make_res_nacional_mock(),
    .make_res_uf_mock(),
    .make_res_limiares_mock()
  )
  linhas_sem_reg <- is.na(result$Registros)
  if (any(linhas_sem_reg)) {
    expect_true(all(is.na(result$credibilidade[linhas_sem_reg])))
  }
})