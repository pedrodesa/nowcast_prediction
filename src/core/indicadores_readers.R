.ler_populacao <- function(path, config = NOWCAST_CONFIG) {
  
  ind  <- config$indicadores
  anos <- ind$anos_pop
  
  readxl::read_xlsx(path, skip = ind$skip_pop) |>
    dplyr::filter(
      !LOCAL %in% ind$regioes_excluir,
      SEXO == ind$sexo_pop
    ) |>
    dplyr::select(SIGLA, IDADE, dplyr::all_of(anos)) |>
    dplyr::group_by(SIGLA) |>
    dplyr::summarise(
      dplyr::across(dplyr::all_of(anos), \(x) sum(x, na.rm = TRUE))
      ) |>
    tidyr::pivot_longer(
      dplyr::all_of(anos),
      names_to  = 'ano_epi',
      values_to = 'populacao'
    ) |>
    dplyr::mutate(ano_epi = as.integer(ano_epi)) |>
    dplyr::rename(!!config$vars$col_uf_pop := SIGLA)
}

.ler_limiares <- function(path, config = NOWCAST_CONFIG) {
  
  read.csv(path) |>
    dplyr::filter(escala == config$indicadores$escala_limiar) |>
    dplyr::select(regiao, sem_risco, baixo, moderado, alto, muito_alto)
}