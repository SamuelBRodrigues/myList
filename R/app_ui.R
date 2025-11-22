# R/app_ui.R

app_ui <- function(request) {
  # Pacote recomendado para UI moderna
  tagList(
    # Golem tags (não remover)
    golem_add_external_resources(),
    
    # Início da UI real (ex: usando bslib)
    bslib::page_fluid(
      title = "Nossa Lista de Casamento 🥂",
      
      # Título principal
      shiny::h1("Bem-Vindos à Nossa Lista de Presentes!", class = "text-center my-4"),
      
      # 1. Roleta de Presentes de Alto Valor
      mod_lista_itens_ui(
        id = "itens_alto_valor",
        titulo = "✈️ Presentes de Alto Valor (Lua de Mel, Eletros, etc.)",
        # Passa os dados para o UI para que a roleta seja renderizada
        lista_dados = lista_itens_alto_valor # Variável de dados definida abaixo
      ),
      
      shiny::hr(),
      
      # 2. Roleta de Presentes Simbólicos
      mod_lista_itens_ui(
        id = "itens_simbolicos",
        titulo = "☕ Presentes Simbólicos (Café da Manhã, Almoço, etc.)",
        # Passa os dados para o UI para que a roleta seja renderizada
        lista_dados = lista_itens_simbolicos # Variável de dados definida abaixo
      )
    )
  )
}