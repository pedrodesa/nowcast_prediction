# ==== Instalação de pacotes ==== #
pacotes <- c(
  'dplyr',
  'tidyr',
  'purrr',
  'lubridate',
  'aweek', 
  'xts',
  'arrow',
  'geobr',
  'readxl',
  'httr',       # API Sharepoint
  'jsonlite',   # API Sharepoint
  'yaml',       # API Sharepoint
  'logger',     # Gerenciamento de logs
  'here',
  'testthat'
)

if (sum(as.numeric(!pacotes %in% installed.packages())) != 0) {
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for (i in 1:length(instalador)) {
    install.packages(instalador, dependencies = TRUE)
    break()
  }
  sapply(pacotes, require, character = TRUE)
} else {
  sapply(pacotes, require, character = TRUE)
}

# Instalqar Devtools
install.packages('devtools')
# library(devtools)

# 1. Instala BiocManager se necessário (INLA depende de pacotes da Bioconductor)
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# 2. Instala os pacotes auxiliares
BiocManager::install(c("graph", "Rgraphviz"), ask = FALSE, update = TRUE)
install.packages(c("Matrix", "lattice", "MCMCpack", "sf"), dependencies = TRUE)

# 3. Tenta instalar o INLA diretamente do repositório oficial
try({
  install.packages(
    "INLA",
    repos = c(getOption("repos"),
              INLA = "https://inla.r-inla-download.org/R/stable"),
    dep = TRUE
  )
}, silent = TRUE)

# 4. Tenta carregar o INLA
if (!require("INLA", character.only = TRUE)) {
  # Se falhar, tenta via GitHub
  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools")
  }
  
  message("Instalando via GitHub como fallback...")
  devtools::install_github("hrue/r-inla", subdir = "rinla", build = FALSE)
  # library(INLA)
}

# 5. Teste básico para confirmar instalação
if ("INLA" %in% rownames(installed.packages())) {
  message("INLA instalado e carregado com sucesso!")
} else {
  stop("Falha ao instalar o INLA. Verifique sua internet, permissões ou tente em outro R.")
}

# Instalar o pacote 'nowcaster' diretamente do GitHub
devtools::install_github('covid19br/nowcaster')
# library(nowcaster)
