#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
# R/app_ui.R

app_ui <- function(request) {
  shiny::tagList(
    golem_add_external_resources(),
    # Início da UI real: Usando bslib::page_fluid para tema e responsividade
    bslib::page_fluid(
      title = "Nossa Lista de Casamento 🥂",
      
      # 🎨 CONFIGURAÇÃO DO TEMA BSLIB (COM AS FONTES OVO e GREAT VIBES)
      theme = bslib::bs_theme(
        version = 5,
        bootswatch = "yeti",        # Tema base limpo e moderno
        bg = "#ffffffff",             # Cor de fundo: Branco
        fg = "#000000ff",             
        primary = "#000000ff",        # Cor primária (Botões): Tom de vermelho/rosa
        secondary = "#A0A0A0",      
        
        # DEFINIÇÃO DAS FONTES GOOGLE
        base_font = bslib::font_google("Ovo"),             # Fonte para corpo do texto
        heading_font = bslib::font_google("Great Vibes")  # Fonte elegante para títulos
      ),
      
      # Container principal com margens
      shiny::div( 
        class = "container-fluid",
        style = "max-width: 1200px; margin: 0 auto; padding-top: 30px; padding-bottom: 50px;",
        
        # 👰 Título Principal (Usará Great Vibes)
        shiny::h1(
          "Bem-Vindos à Nossa Lista de Presentes!", 
          class = "text-center my-5", 
          # Estilo customizado para garantir que a fonte Great Vibes seja elegante
          style = "font-size: 3.5rem; color: #7f4ca5; font-family: 'Great Vibes', cursive;"
        ),
        
        # Roleta de Presentes Simbólicos
        mod_lista_itens_ui(
          id = "itens_simbolicos",
          titulo = "☕ Mimos para o Nosso Novo Lar",
          lista_dados = golem::get_golem_options("lista_itens_simbolicos")
        ),

        shiny::hr(style = "margin: 60px 0; border-top: 2px solid #000000ff; opacity: 0.5;"),

        # Roleta de Roleta de Presentes Relacionado a Cozinha
        mod_lista_itens_ui(
          id = "itens_cozinha",
          titulo = "☕ Mimos para o Nosso Novo Lar",
          lista_dados = golem::get_golem_options("lista_itens_cozinha")
        ),

        shiny::hr(style = "margin: 60px 0; border-top: 2px solid #000000ff; opacity: 0.5;"),

        # Roleta de Presentes Relacionado a Cama, Mesa e Banho
        mod_lista_itens_ui(
          id = "itens_cama_mesa_banho",
          titulo = "☕ Mimos para o Nosso Novo Lar",
          lista_dados = golem::get_golem_options("lista_itens_cama_mesa_banho")
        ),

        shiny::hr(style = "margin: 60px 0; border-top: 2px solid #000000ff; opacity: 0.5;"),

        # Roleta de Presentes de Alto Valor
        mod_lista_itens_ui(
          id = "itens_cama_mesa_banho",
          titulo = "✈️ Presentes para a Lua de Mel",
          # A variável lista_itens_alto_valor é globalmente acessível
          lista_dados = golem::get_golem_options("lista_itens_alto_valor")
        ),
        
        # <footer> Rodapé/Notas Finais
        shiny::div(
          class = "text-center mt-5 p-3",
          style = "font-size: 0.9em; color: #777;",
          shiny::p("Agradecemos imensamente sua presença e carinho!"),
          shiny::p("Desenvolvido com 💖 em R Shiny e Golem.")
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  shiny::addResourcePath(
    "www",
    app_sys("app/www")
  )

  shiny::tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "myList"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
