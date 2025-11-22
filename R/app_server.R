# R/app_server.R

# --- Dados Estáticos de Exemplo ---
# Estes dados seriam normalmente lidos de um arquivo .csv ou banco de dados
lista_itens_alto_valor <- list(
  list(id = "tv", nome = "Smart TV 55''", valor = 3500, descricao = "Para maratonar séries no novo apê!", imagem = "www/tv.png"),
  list(id = "geladeira", nome = "Geladeira Inverter", valor = 6000, descricao = "Com espaço para todas as compras do mês.", imagem = "www/geladeira.png")
)

lista_itens_simbolicos <- list(
  list(id = "jantar", nome = "Jantar Romântico", valor = 200, descricao = "Um brinde na nossa primeira noite!", imagem = "www/jantar.png"),
  list(id = "cinema", nome = "Ingressos de Cinema", valor = 80, descricao = "Um presente de pipoca e filme!", imagem = "www/cinema.png")
)


app_server <- function(input, output, session) {
  
  # Chama o servidor do módulo para a primeira roleta
  mod_lista_itens_server(
    id = "itens_alto_valor", 
    lista_dados = lista_itens_alto_valor
  )
  
  # Chama o servidor do módulo para a segunda roleta
  mod_lista_itens_server(
    id = "itens_simbolicos", 
    lista_dados = lista_itens_simbolicos
  )
  
  # O restante da lógica de servidor (ex: navegação, logging, etc.) iria aqui.
}