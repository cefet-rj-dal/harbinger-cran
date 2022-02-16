#==== evtdet: Função para detecção de eventos ====
# Função fundamental do pacote. Normalmente, não é chamada diretamente mas pode ser usada para integrar novos métodos.
# input:
#   data: data.frame com uma ou mais variáveis (série temporal) onde a primeira referencia tempo.
#   func: função para detecção de eventos tendo 'data' como input e um data.frame com 3 variáveis:
#         tempo (índices ou tempo de evento), série (correspondente a uma série temporal) e
#    tipo (tipo do evento) como output.
#
# output:
#    events --> data.frame com 3 variáveis:
#               tempo (indíces ou tempo de evento), série (correspondente a uma série temporal) e
#               Tipo (tipo do evento) como output.

evtdet <- function(data,func,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  events <- do.call(func,c(list(data),list(...)))

  return(events)
}
