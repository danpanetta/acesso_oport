#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
###### 0.1.1 Download de shape file de municipios e setores censitarios dos  municipios incluidos no projeto

# carregar bibliotecas
source('./R/fun/setup.R')


# 1. Funcao para download de shape file dos municipios e setores censitarios ------------------
download_muni_setores <- function(ano, munis = "all") {
  
  # Select the corerspondent munis_df
  munis_df <- get(sprintf("munis_df_%s", ano))
  
  download_muni_setores_un <- function(sigla_muni) {
    
    code <- munis_df[abrev_muni == sigla_muni]$code_muni
    
    
    # criar pasta do municipios
    dir.create(sprintf("../data-raw/municipios/%s", ano))  
    dir.create(sprintf("../data-raw/setores_censitarios/%s", ano))  
    
    
    # Download de arquivos
    muni_sf <- geobr::read_municipality(code_muni= code, year=2010)
    ct_sf <- geobr::read_census_tract(code_tract = code, year=2010)
    
    
    # salvar municipios
    readr::write_rds(muni_sf, sprintf("../data-raw/municipios/%s/municipio_%s_%s.rds", ano, sigla_muni, ano))
    
    # salvar setores censitarios
    readr::write_rds(ct_sf, sprintf("../data-raw/setores_censitarios/%s/setores_%s_%s.rds", ano, sigla_muni, ano))
  }
  
  # 2. Aplica funcao ------------------------------------------
  if (munis == "all") {
    
    x = munis_df$abrev_muni
    
  } else (x = munis)
  
  
  lapply(X=x, FUN=download_muni_setores_un)
  
  
}

