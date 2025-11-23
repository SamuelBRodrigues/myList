app_server <- function(input, output, session) {
  
  # 1. Acessa as variáveis de dados definidas no run_app.R
  # Usamos get_golem_options() para buscar os dados de forma limpa
  lista_simbolicos <- golem::get_golem_options("lista_itens_simbolicos")
  lista_itens_cozinha <- golem::get_golem_options("lista_itens_cozinha")
  lista_itens_cama_mesa_banho <- golem::get_golem_options("lista_itens_cama_mesa_banho")
  lista_alto_valor <- golem::get_golem_options("lista_itens_alto_valor")

  # 2. Chama o Servidor do Módulo para a Roleta de Presentes Simbólicos
  mod_lista_itens_server(
    id = "itens_simbolicos", # O id deve corresponder ao id usado no app_ui.R
    lista_dados = lista_simbolicos
  )

  # 3. Chama o Servidor do Módulo para a Roleta de Presentes Relacionado a Cozinha
  mod_lista_itens_server(
    id = "itens_cozinha", # O id deve corresponder ao id usado no app_ui.R
    lista_dados = lista_itens_cozinha
  )

  # 4. Chama o Servidor do Módulo para a Roleta de Presentes Relacionado a Cama, Mesa e Banho
  mod_lista_itens_server(
    id = "itens_cama_mesa_banho", # O id deve corresponder ao id usado no app_ui.R
    lista_dados = lista_itens_cama_mesa_banho
  )

  # . Chama o Servidor do Módulo para a Roleta de Alto Valor
  mod_lista_itens_server(
    id = "itens_alto_valor", # O id deve corresponder ao id usado no app_ui.R
    lista_dados = lista_alto_valor
  )
  
  
  
  # Inclua aqui qualquer lógica de servidor que não pertença a um módulo (ex: logging, navegação principal).
}