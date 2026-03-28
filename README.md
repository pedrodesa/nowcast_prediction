# Estimativas Nowcast — Síndrome Gripal pela COVID-19
 
```
_   _                               _     ____               _ _      _   _
| \ | | _____      _____ __ _ ___ _| |_  |  _ \ _ __ ___  __| (_) ___| |_(_) ___  _ __
|  \| |/ _ \ \ /\ / / __/ _` / __|_   _| | |_) | '__/ _ \/ _` | |/ __| __| |/ _ \| '_ \
| |\  | (_) \ V  V / (_| (_| \__ \ |_|   |  __/| | |  __/ (_| | | (__| |_| | (_) | | | |
|_| \_|\___/ \_/\_/ \___\__,_|___/ |_|   |_|   |_|  \___|\__,_|_|\___|\__|_|\___/|_| |_|
 
    _                _ _           _   _
   / \   _ __  _ __ | (_) ___ __ _| |_(_) ___  _ __
  / _ \ | '_ \| '_ \| | |/ __/ _` | __| |/ _ \| '_ \
 / ___ \| |_) | |_) | | | (_| (_| | |_| | (_) | | | |
/_/   \_\ .__/| .__/|_|_|\___\__,_|\__|_|\___/|_| |_|
        |_|   |_|
```
 
<img src="./docs/img/nowcast_covid19.png">
<img src="./docs/img/niveis_de_atividade.png">
<img src="./docs/img/mapa_tendencia.png">
 
---
 
## Objetivo
 
Gerar estimativas de nowcasting de casos de síndrome gripal pela COVID-19, corrigindo
o atraso de notificação inerente ao sistema de informação e-SUS Notifica do Ministério da Saúde.
 
---
 
## Descrição
 
O sistema desenvolvido em R estima em tempo real a curva real de casos a partir de dados
ainda incompletos, utilizando um modelo bayesiano via INLA implementado pelo pacote `nowcaster`.
 
O pipeline cobre todo o ciclo analítico: extração automatizada de dados brutos do SharePoint,
tratamento, validação, execução do nowcast em três recortes geográficos e demográficos
(Brasil, Unidades da Federação e faixas etárias), e cálculo de indicadores epidemiológicos
como limiares de risco, intensidade da atividade e tendência de crescimento. Os resultados
são consolidados e devolvidos automaticamente ao SharePoint ao fim de cada execução.
 
A arquitetura segue separação clara entre camadas de configuração, motores analíticos
reutilizáveis e pipelines de orquestração, com cobertura de testes automatizados via `testthat`.
O projeto é containerizado com Docker e agendado via cron em servidor Ubuntu.
 
---
 
## Dados
 
Os dados utilizados são do sistema de informação **e-SUS Notifica** do Ministério da Saúde.
 
| Coluna               | Tipo      | Descrição                        |
| :------------------- | :-------- | :------------------------------- |
| dataInicioSintomas   | Date      | Data de início dos sintomas      |
| dataNotificacao      | Date      | Data de notificação do caso      |
| dataRegistro         | Date      | Data de registro no sistema      |
| estadoIBGE           | Character | Sigla da UF                      |
| idade                | Integer   | Idade do paciente em anos        |
 
---
 
## Organização do projeto
 
```
.
├── config
│   └── config.yml                        # Configurações gerais do projeto
├── data
│   ├── external                          # Arquivos de referência (população, limiares)
│   ├── logs                              # Logs de execução
│   ├── outputs                           # Outputs intermediários
│   ├── processed                         # CSVs finais enviados ao SharePoint
│   └── raw                               # Dados brutos extraídos do SharePoint
├── docs
│   ├── img                               # Imagens da documentação
│   └── vega-lite                         # Especificações JSON dos visuais (Power BI / Deneb)
├── notebooks                             # Relatórios exploratórios em R Markdown
├── scripts
│   ├── run_nowcast.R                     # Ponto de entrada principal
│   └── setup.R                           # Configuração inicial (rodar uma vez)
├── src
│   ├── config
│   │   └── config_nowcast.R              # NOWCAST_CONFIG centralizado
│   ├── core                              # Motores analíticos reutilizáveis
│   │   ├── indicadores_engine.R
│   │   ├── indicadores_readers.R
│   │   ├── intensidade_engine.R
│   │   ├── nowcast_engine.R
│   │   ├── nowcast_recorte.R
│   │   ├── serie_combinada.R
│   │   ├── serie_semanal.R
│   │   └── tendencia_engine.R
│   ├── data                              # Tratamento e validação
│   │   ├── data_wrangling.R
│   │   └── validate_data.R
│   ├── extract                           # Conexão com SharePoint
│   │   ├── extract_data.R
│   │   └── load_data.R
│   ├── pipeline                          # Orquestradores de cada análise
│   │   ├── calcular_intensidade.R
│   │   ├── calcular_limiares.R
│   │   ├── calcular_tendencias.R
│   │   ├── consolidar_series.R
│   │   ├── nowcast_faixa_etaria.R
│   │   ├── nowcast_nacional.R
│   │   ├── nowcast_uf.R
│   │   └── salvar_outputs.R
│   └── utils
│       ├── log_utils.R
│       └── pkg_utils.R
├── tests                                 # Testes automatizados (testthat)
│   ├── testthat
│   │   ├── test_config.R
│   │   ├── test_consolidar_series.R
│   │   ├── test_data_wrangling.R
│   │   ├── test_indicadores.R
│   │   ├── test_nowcast_engine.R
│   │   ├── test_pkg_utils.R
│   │   └── test_tendencia_intensidade.R
│   └── testthat.R
├── Dockerfile
├── install_packages.R
├── nowcast_covid.Rproj
└── README.md
```
 
---
 
## Fluxo do pipeline
 
```
SharePoint
    │
    ▼
extract_data.R   →  data/raw/               (parquet bruto)
    │
    ▼
data_wrangling.R →  dados tratados          (seleção, datas, faixas, filtro temporal)
validate_data.R  →  validação               (volume, NAs, defasagem)
    │
    ├──► nowcast_nacional.R    →  nowcast BR
    ├──► nowcast_uf.R          →  nowcast por UF
    ├──► nowcast_faixa_etaria.R→  nowcast por faixa etária
    ├──► calcular_limiares.R   →  limiares epidemiológicos
    ├──► calcular_intensidade.R→  intensidade da atividade
    ├──► calcular_tendencias.R →  tendência de crescimento
    └──► consolidar_series.R   →  série consolidada com credibilidade
    │
    ▼
salvar_outputs.R →  data/processed/         (CSVs)
    │
    ▼
load_data.R      →  SharePoint              (envio dos resultados)
```
 
---
 
## Execução local
 
### Pré-requisitos
 
- R >= 4.2
- Pacotes listados em `install_packages.R`
- Credenciais do SharePoint configuradas (ver seção Credenciais)
 
### Instalação
 
```r
# Instalar todos os pacotes necessários
source('install_packages.R')
```
 
### Configurar credenciais
 
Crie um arquivo `.env` na raiz do projeto (nunca versionar):
 
```bash
SHAREPOINT_TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
SHAREPOINT_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
SHAREPOINT_CLIENT_SECRET=sua_secret_aqui
SHAREPOINT_SITE_URL=https://suaorg.sharepoint.com/sites/seusite
```
 
### Rodar o pipeline
 
```r
Rscript ./scripts/run_nowcast.R
```
 
### Rodar os testes
 
```r
testthat::test_dir('tests/testthat')
```
 
---
 
## Deploy com Docker
 
### Opção A — Build direto no servidor
 
```bash
# Instalar Docker
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker
 
# Clonar e configurar
git clone https://seu-repositorio/nowcast_covid.git
cd nowcast_covid
nano .env
 
# Build e execução
docker build -t nowcast-covid .
docker run --rm \
  --env-file .env \
  -v $(pwd)/data:/app/data \
  nowcast-covid
```
 
### Opção B — Build local e transferência para o servidor
 
```bash
# Local — build e empacotamento
docker build -t nowcast-covid .
docker save nowcast-covid | gzip > nowcast-covid.tar.gz
 
# Transferência
scp nowcast-covid.tar.gz usuario@ip-do-servidor:/home/usuario/
 
# Servidor — carregamento e execução
docker load < nowcast-covid.tar.gz
docker run --rm \
  --env-file .env \
  -v $(pwd)/data:/app/data \
  nowcast-covid
```
 
> O volume `-v $(pwd)/data:/app/data` persiste os outputs e logs no servidor após a execução do container.
 
---
 
## Agendamento automático (cron)
 
```bash
crontab -e
 
# Exemplo: toda segunda-feira às 6h
0 6 * * 1 cd /home/usuario/nowcast_covid && docker run --rm \
  --env-file .env \
  -v $(pwd)/data:/app/data \
  nowcast-covid >> data/logs/cron.log 2>&1
```
 
---
 
## Arquivos ignorados pelo Git
 
Adicionar ao `.gitignore`:
 
```
.env
data/raw/
data/processed/
data/logs/
```
 
---
 
## Tecnologias utilizadas
 
| Tecnologia   | Uso                                      |
| :----------- | :--------------------------------------- |
| R            | Linguagem principal                      |
| nowcaster    | Modelo bayesiano de nowcasting via INLA  |
| INLA         | Inferência bayesiana aproximada          |
| testthat     | Testes automatizados                     |
| logger       | Registro de logs estruturados            |
| Docker       | Containerização e deploy                 |
| Power BI     | Visualização dos resultados (Deneb)      |
| SharePoint   | Armazenamento e transferência de dados   |
 