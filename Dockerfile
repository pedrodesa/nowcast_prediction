FROM rocker/r-base:latest

# Instalar dependências do sistema
RUN apt update && apt install -y \
        libpq-dev \
        build-essential \
        libcurl4-openssl-dev \
        libxml2-dev \
        libssl-dev \
        libudunits2-dev \
        libgdal-dev \
        libgeos-dev \
        libproj-dev \
        gdal-bin \
        libsqlite3-dev \
        libfontconfig1-dev \
        cmake \
        libabsl-dev \
        libgsl-dev \
        jags \
        libjags-dev \
        gfortran \
        liblapack-dev \
        libblas-dev && \
        apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instala pacotes R antes de copiar o projeto
# (aproveita cache do Docker se install_packages.R não mudar)
COPY install_packages.R /app/install_packages.R
RUN Rscript install_packages.R

# Copia o projeto
COPY . .

# Cria pastas de dados que não estão no repositório
RUN mkdir -p data/raw data/processed data/logs data/outputs

# Corrigido: scripts (não script)
CMD ["Rscript", "scripts/run_nowcast.R"]
