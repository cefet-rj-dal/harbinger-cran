#função evtdet === função para detecção de eventos

evtdet <- function(data,func,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  events <- do.call(func,c(list(data),list(...)))

  return(events)
}
