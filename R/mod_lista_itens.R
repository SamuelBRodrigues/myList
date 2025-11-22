# R/mod_lista_itens.R

# --- UI para um Único Item ---
# Esta função cria a estrutura visual de um único presente.
item_card_ui <- function(id, nome, valor, descricao, imagem_path) {
  # Nãop usamos ns() aqui pois o id será manipulado no módulo server, 
  # mas mantemos o ID único para identificação do botão.
  
  # Estrutura do card. Usando bslib/htmltools para a estrutura.
  shiny::div(
    class = "swiper-slide", # Importante: esta classe é requerida pelo swiper
    style = "border: 1px solid #eee; padding: 15px; border-radius: 8px; text-align: center; height: auto;",
    
    shiny::img(src = imagem_path, class = "item-photo", style = "width: 100%; height: 150px; object-fit: cover; border-radius: 4px; margin-bottom: 10px;"),
    
    shiny::div(
      class = "item-details",
      shiny::h3(nome, style = "font-size: 1.2em; margin-bottom: 5px;"),
      shiny::p(paste0("R$ ", format(valor, big.mark = ".", decimal.mark = ",")), style = "font-weight: bold; color: #E95460;"),
      shiny::p(descricao, class = "item-description", style = "font-size: 0.9em; height: 3em; overflow: hidden;"),
      
      # Botão que aciona o modal do Pix. O ID precisa ser único e reativo.
      shiny::actionButton(
        inputId = id, # Usamos o ID do item como ID do botão para fácil identificação
        label = "Contribuir com Pix",
        class = "btn-primary btn-pix mt-2",
        style = "background-color: #5cb85c; border-color: #4cae4c; width: 100%;"
      )
    )
  )
}

# --- UI para o Módulo Completo (A Roleta com Swiper) ---
mod_lista_itens_ui <- function(id, titulo, lista_dados) {
  ns <- shiny::NS(id)
  
  # Cria os cards de UI para cada item
  cards <- lapply(lista_dados, function(item) {
    # Usamos ns() para garantir que o ID do botão de cada item seja único no app
    item_card_ui(
      id = ns(item$id), 
      nome = item$nome,
      valor = item$valor,
      descricao = item$descricao,
      imagem_path = item$imagem
    )
  })
  
  shiny::tagList(
    shiny::h2(titulo, class = "text-center my-4"),
    
    # IMPLEMENTAÇÃO ATUALIZADA com SWIPER
    swipeR::swiper(
      swipeR::swiper_slides(cards), # Os cards de itens são passados como slides
      swiper_nav = TRUE,            # Adiciona setas de navegação
      swiper_params = list(
        slidesPerView = 1,          # Padrão: 1 slide visível
        spaceBetween = 10,
        breakpoints = list(         # Responsividade: mais slides em telas maiores
          "640" = list(slidesPerView = 2, spaceBetween = 20),
          "1024" = list(slidesPerView = 3, spaceBetween = 30)
        )
      )
    )
  )
}

# --- Lógica do Servidor para o Módulo ---
mod_lista_itens_server <- function(id, lista_dados) {
  moduleServer(id, function(input, output, session) {
    
    # Percorre a lista de dados para criar um observador para CADA botão de item
    lapply(lista_dados, function(item) {
      
      # O ID do botão é único devido ao NS() usado na UI: session$ns(item$id)
      button_id <- item$id # O ID do botão dentro do namespacing do módulo
      
      shiny::observeEvent(input[[button_id]], {
        
        # Simula a chave Pix e o QR Code
        chave_pix <- "noivos.casamento@pix.com.br" 
        qr_code_url <- "www/qr_code_placeholder.png"
        
        # Exibe o Modal (Pop-up) com o Pix
        shiny::showModal(
          shiny::modalDialog(
            title = paste("Contribuir com:", item$nome),
            shiny::h4(paste0("Valor sugerido: R$ ", format(item$valor, big.mark = ".", decimal.mark = ","))),
            shiny::p("Agradecemos sua contribuição! Use o QR Code ou a chave Pix:"),
            
            shiny::img(src = qr_code_url, alt = "QR Code Pix", style = "width: 100%; max-width: 250px; display: block; margin: 15px auto;"),
            shiny::p(paste("Chave Pix:", chave_pix), style = "text-align: center; font-weight: bold;"),
            
            easyClose = TRUE,
            footer = shiny::modalButton("Fechar", class = "btn-secondary")
          )
        )
      }, ignoreInit = TRUE)
    })
  })
}