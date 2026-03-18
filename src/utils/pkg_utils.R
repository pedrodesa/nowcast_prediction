.check_required_pkgs <- function(pkgs) {
  invisible(lapply(pkgs, function(pkg) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop(sprintf("Pacote obrigatório não encontrado: %s", pkg))
    }
  }))
}
