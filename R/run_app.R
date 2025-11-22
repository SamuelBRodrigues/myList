# R/run_app.R

#' Run the application
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  on_load = NULL, 
  options = list(), 
  enable_devmode = TRUE,
  ...
) {
  # Definindo os dados de exemplo no ambiente global da função para que o app_ui.R 
  # possa acessá-los diretamente, conforme o código UI gerado anteriormente.
  # Em um projeto golem grande, estes dados seriam definidos em R/data.R ou lidos de BD.
  lista_itens_alto_valor <- list(
    list(id = "tv", nome = "Smart TV 55''", valor = 3500, descricao = "Para maratonar séries no novo apê!", imagem = "www/tv.png"),
    list(id = "geladeira", nome = "Geladeira Inverter", valor = 6000, descricao = "Com espaço para todas as compras do mês.", imagem = "www/geladeira.png")
  )
  
  lista_itens_simbolicos <- list(
    list(id = "jantar", nome = "Jantar Romântico", valor = 200, descricao = "Um brinde na nossa primeira noite!", imagem = "www/jantar.png"),
    list(id = "cinema", nome = "Ingressos de Cinema", valor = 80, descricao = "Um presente de pipoca e filme!", imagem = "www/cinema.png"),
    list(id = "cafe", nome = "Café da Manhã", valor = 100, descricao = "Para começar o dia com o pé direito.", imagem = "www/cafe.png")
  )
  
  with_golem_options(
    app = shinyApp(
      ui = app_ui, 
      server = app_server,
      options = options
    ),
    golem_options = list(
      # Passa os dados para o app_ui/app_server
      lista_itens_alto_valor = lista_itens_alto_valor,
      lista_itens_simbolicos = lista_itens_simbolicos
    )
  )
}