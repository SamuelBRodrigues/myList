# R/mod_lista_itens.R

# --- UI para um Único Item ---
# Esta função infere a necessidade dos botões de compra/redirecionamento a partir do item.
item_card_ui <- function(id, nome, valor, descricao, imagem_path, simbolico, link_amazon = NULL, link_ml = NULL) {
  
  # CRUCIAL: 'is_simbolico' é uma variável booleana que converte o campo de dados.
  is_simbolico <- (simbolico == "TRUE") 
  
  # 1. Botão de Contribuição PIX (Comum a ambos os tipos de lista)
  pix_button <- shiny::actionButton(
    inputId = id, # ID único para o botão.
    label = shiny::tagList(shiny::icon("qrcode"), "Contribuir com Pix"),
    class = "btn-primary btn-pix mt-2",
    style = "background-color: #5cb85c; border-color: #4cae4c; width: 100%;" # Estilo de largura total
  )
  
  #Botão de Pagamento com Cartão (Action Button)
  cartao_button <- shiny::actionButton(
    inputId = base::paste0(id, "_cartao"),
    label = shiny::tagList(shiny::icon("credit-card"), "Pagar com Cartão"),
    class = "btn-info mt-2",
    style = "width: 100%; background-color: #337ab7; border-color: #2e6da4;" # Estilo de largura total
  )
  
  if (is_simbolico) {
    # Lista de Itens Simbólicos: Apenas o botão Pix
    botoes <- shiny::tagList(
      pix_button,
      cartao_button
    )
    
  } else {
    # Lista de Itens de Alto Valor: Pix e Cartão + 2 botões de redirecionamento
    
    separador_texto <- shiny::p(
      shiny::strong("Ou compre o item diretamente:"), 
      style = "margin-top: 15px; margin-bottom: 5px; font-size: 0.9em; color: #555;"
    )
    
    # 2. Botão de Redirecionamento para Amazon (Link <a>)
    amazon_button <- shiny::tags$a(
      href = link_amazon,
      target = "_blank", 
      class = "btn btn-secondary mt-2",
      role = "button",
      style = "width: 100%; margin-top: 5px; background-color: #ff9900; border-color: #e68a00;",
      shiny::tagList(shiny::icon("shopping-basket"), "Ver na Amazon")
    )
    
    # 3. Botão de Redirecionamento para Mercado Livre (Link <a>)
    ml_button <- shiny::tags$a(
      href = link_ml,
      target = "_blank", 
      class = "btn btn-secondary mt-2",
      role = "button",
      style = "width: 100%; margin-top: 5px; background-color: #ffe600; border-color: #ccb300; color: #000; font-weight: bold;",
      shiny::tagList(shiny::icon("shopping-basket"), "Ver no Mercado Livre")
    )
    
    # Agrupa todos os botões e o separador
    botoes <- shiny::tagList(
      pix_button,
      cartao_button,
      separador_texto,
      amazon_button,
      ml_button
    )
  }

  return(
    shiny::div(
      class = "item-presente-card", 
      style = "border: 1px solid #eee; padding: 15px; border-radius: 8px; text-align: center; height: auto; background-color: white;",
      
      shiny::img(src = imagem_path, class = "item-photo item-native-size", style = "height: 200px; object-fit: cover; border-radius: 4px; margin-bottom: 10px;"),
      
      shiny::div(
        class = "item-details",
        # Informações
        shiny::h3(nome, style = "font-size: 1.2em; margin-bottom: 5px;"),
        shiny::p(base::paste0("R$ ", base::format(valor, big.mark = ".", decimal.mark = ",")), style = "font-weight: bold; color: #E95460;"),
        shiny::p(descricao, class = "item-description", style = "font-size: 0.9em; height: 3em; overflow: hidden;"),
        
        # Botões Condicionais
        botoes
      )
    )
  )
}

# --- UI do Módulo Completo (A Roleta) ---
# Não precisa de argumento 'is_simbolico', pois a UI é inferida item a item.
mod_lista_itens_ui <- function(id, titulo, lista_dados) {
  ns <- shiny::NS(id)
  
  # 1. Cria os cards de UI para cada item.
  cards <- base::lapply(lista_dados, function(item) {
    # item_card_ui recebe todos os campos necessários do 'item'
    item_card_ui(
      id = ns(item$id), 
      nome = item$nome,
      valor = item$valor,
      descricao = item$descricao,
      imagem_path = item$imagem,
      simbolico = item$simbolico, # <--- Passa o campo do dado
      link_amazon = item$link_amazon, 
      link_ml = item$link_ml
    )
  })
  
  # 2. USA O WRAPPER PARA ENVOLVER OS CARDS
  wrapped_cards <- base::do.call(swipeR::swipeRwrapper, cards)
  
  shiny::tagList(
    
    # 🎨 CSS CUSTOMIZADO (Mantido o Flexbox para posicionamento do botão)
    shiny::tags$head(
      shiny::tags$style(
        HTML(base::paste0("
          /* Garante que o item-presente-card use Flexbox para empurrar o botão para baixo */
          #", ns("carrossel"), " .item-presente-card {
            height: 100%; 
            display: flex;
            flex-direction: column;
            justify-content: space-between; 
            padding-bottom: 15px;
          }
          /* O container do slide não precisa mais de padding extra */
          #", ns("carrossel"), " .swiper-slide {
            padding-bottom: 15px !important; 
          }
          /* Permite que a área de detalhes cresça e separe o botão */
          #", ns("carrossel"), " .item-details {
            flex-grow: 1; 
          }
          /* Anula a regra responsiva do Bootstrap para renderização 1:1 */
          .item-native-size {
            width: auto !important;
            max-width: none !important;
            height: auto !important;
          }
        "))
      )
    ),
    
    shiny::h2(titulo, class = "text-center my-4", style = "color: #546240; font-family: 'Great Vibes', cursive;"),

    # 3. USA O SWIPER PRINCIPAL PARA APLICAR AS CONFIGURAÇÕES
    swipeR::swipeR(
      # O conteúdo do wrapper é o primeiro argumento
      wrapped_cards,
      # Parâmetros de Container (elementId e dimensões)
      elementId = ns("carrossel"),
      width = 400, # Ajuste para ser responsivo dentro da coluna
      height = 800,
      autoplay = T,
      navigationColor = "black",
      rewind = T
    )
  )
}

# --- Lógica do Servidor para o Módulo ---
mod_lista_itens_server <- function(id, lista_dados) {
  shiny::moduleServer(id, function(input, output, session) {
    
    base::lapply(lista_dados, function(item) {
      
      # 1. Lógica do Botão PIX (Sempre presente)
      button_id <- item$id # ID do botão Pix
      
      shiny::observeEvent(input[[button_id]], {
        
        chave_pix <- "ravane.cabral82@gmail.com" 
        qr_code_url <- "www/qrcode-pix.png"
        
        shiny::showModal(
          shiny::modalDialog(
            title = base::paste("Contribuir com:", item$nome),
            shiny::h4(base::paste0("Valor sugerido: R$ ", base::format(item$valor, big.mark = ".", decimal.mark = ","))),
            shiny::p("Agradecemos sua contribuição! Use o QR Code ou a chave Pix:"),
            
            shiny::img(src = qr_code_url, alt = "QR Code Pix", style = "width: 100%; max-width: 250px; display: block; margin: 15px auto;"),
            shiny::p(base::paste("Chave Pix:", chave_pix), style = "text-align: center; font-weight: bold;"),
            
            easyClose = TRUE,
            footer = shiny::modalButton("Fechar") 
          )
        )
      }, ignoreInit = TRUE)
      
      cartao_button_id <- base::paste0(item$id, "_cartao")
      shiny::observeEvent(input[[cartao_button_id]], {
        shiny::showModal(
          shiny::modalDialog(
            title = base::paste("Pagamento com Cartão para:", item$nome),
            shiny::p("Em desenvolvimento: Aqui você adicionaria o link de pagamento ou um formulário de gateway (ex: PagSeguro, Stripe)."),
            easyClose = TRUE
          )
        )
      }, ignoreInit = TRUE)
    })
  })
}