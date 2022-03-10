# Harbinger Package
R package that contains the event detection methods, as well as their plotting and evaluation methods, presented in the article "Um framework para integração e análise de métodos de detecção de eventos em séries temporais."

[About](About) • [Example](Example) • [Documentation](Documentation) • [Development](Development) • [Credits](Credits) • [License](License)

cefet
About

This R package was made based in the article "Um framework para integração e análise de métodos de detecção de eventos em séries temporais". Because of this, it focuses on event detection, its methods, plottings and evaluation methods. The R package was Developed at CEFET/RJ for an academic work.

Throughout the following parts of this text, you may be able to study some examples of fundamental methods of the package, the documentation of each method, the steps followed based on the book "R packages" by Hadley Wickham and Jenny Bryan. Please feel free to make contributions and contact in case of bugs or suggestions.

Example

The following examples are the base methods used for the event detection, plotting, and evaluation of the event detection:

library("harbinger")

evtdet <- function(data,func,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  events <- do.call(func,c(list(data),list(...)))

  return(events)
}



Documentation

In this part all the methods are explained.

