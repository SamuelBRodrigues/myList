#' Extrai o conteúdo dos Cards
#' 
#' Essa função é responsável por ler a tabela da URL passada no argumeto `sheets_url` e retornar as informações usadas para construir os cartões de itens.
#'
#' @param id_lista String contendo o nome da id de um dos carrosséis de cartões.
#' @param sheets_url Url com as informações dos itens que alimentarão os cartões
#' 
#' @returns Uma lista nomeada.
#'
#' @export
#' @examples
#' \dontrun(
#' 
#'  url = "sheets.google.com"
#'  id_lista = "itens_simbolicos"
#' 
#'  cards_itens_simbolicos = get_card_content(id_lista, url)
#' 
#' )
#' @noRd
get_card_content <- function(id_lista, sheets_url){  
  stopifnot("id_lista deve ser uma string" = is.character(id_lista))
  stopifnot("id_lista deve ser: \"itens_simbolicos\", \"itens_cozinha\", \"itens_cama_mesa_banho\", \"itens_alto_valor\"" = id_lista %in% c("itens_simbolicos", "itens_cozinha", "itens_cama_mesa_banho", "itens_alto_valor"))

  lista_itens <- googlesheets4::read_sheet(
    sheets_url
  )

  lista_itens_filtrado <- lista_itens |> 
    dplyr::mutate(
      simbolico = stringr::str_extract(simbolico, "\\w+")
    ) |> 
    dplyr::filter(
      id == id_lista
    )

  i = nrow(lista_itens_filtrado)

  cards_content <- purrr::map(
    1:i,
    ~{
      n = .x
      if(lista_itens_filtrado$simbolico[n] == "TRUE"){
        card_content <- list(
          simbolico = lista_itens_filtrado$simbolico[n],
          id = lista_itens_filtrado$id[n],
          nome = lista_itens_filtrado$nome[n],
          valor = lista_itens_filtrado$valor[n],
          descricao = lista_itens_filtrado$descricao[n],
          imagem = lista_itens_filtrado$imagem[n]
        )
      } else{
        card_content <- list(
          simbolico = lista_itens_filtrado$simbolico[n],
          id = lista_itens_filtrado$id[n],
          nome = lista_itens_filtrado$nome[n],
          valor = lista_itens_filtrado$valor[n],
          descricao = lista_itens_filtrado$descricao[n],
          imagem = lista_itens_filtrado$imagem[n],
          link_amazon = lista_itens_filtrado$link_amazon[n],
          link_ml = lista_itens_filtrado$link_ml[n]
        )
      }
    }
  )

  return(cards_content)
}
