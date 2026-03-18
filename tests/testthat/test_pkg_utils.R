test_that('.check_required_pkgs não dá erro com pacotes instalados', {
  expect_silent(.check_required_pkgs(c('dplyr', 'lubridate')))
})

test_that('.check_required_pkgs falha com pacote inexistente', {
  expect_error(
    .check_required_pkgs(c('dplyr', 'pacote_que_nao_existe_xyz')),
    'Pacotes não encontrados'
  )
})

test_that('.check_required_pkgs lista todos os pacotes ausentes', {
  expect_error(
    .check_required_pkgs(c('pacote_a_xyz', 'pacote_b_xyz')),
    regexp = 'pacote_a_xyz.*pacote_b_xyz|pacote_b_xyz.*pacote_a_xyz'
  )
})