#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  lista_itens_simbolicos <- get_card_content("itens_simbolicos", "https://docs.google.com/spreadsheets/d/1PibYkCPc-wpyUwWSMGYUPJEUP092VL62i31d9c3lv-A/edit?usp=sharing")

  lista_itens_cozinha <- get_card_content("itens_cozinha", "https://docs.google.com/spreadsheets/d/1PibYkCPc-wpyUwWSMGYUPJEUP092VL62i31d9c3lv-A/edit?usp=sharing")

  lista_itens_cama_mesa_banho <- get_card_content("itens_cama_mesa_banho", "https://docs.google.com/spreadsheets/d/1PibYkCPc-wpyUwWSMGYUPJEUP092VL62i31d9c3lv-A/edit?usp=sharing")

  lista_itens_alto_valor <- get_card_content("itens_alto_valor", "https://docs.google.com/spreadsheets/d/1PibYkCPc-wpyUwWSMGYUPJEUP092VL62i31d9c3lv-A/edit?usp=sharing")
  


  golem::with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(
      lista_itens_simbolicos = lista_itens_simbolicos,
      lista_itens_cozinha = lista_itens_cozinha,
      lista_itens_cama_mesa_banho = lista_itens_cama_mesa_banho,
      lista_itens_alto_valor = lista_itens_alto_valor
    )
  )
}
