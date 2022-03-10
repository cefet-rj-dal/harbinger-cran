# Harbinger Package
R package that contains the event detection methods, as well as their plotting and evaluation methods, presented in the article "Um framework para integração e análise de métodos de detecção de eventos em séries temporais".

[About](https://github.com/cefet-rj-pratica-pesquisa/tema4#About) • [Example](https://github.com/cefet-rj-pratica-pesquisa/tema4#Example) • [Documentation](https://github.com/cefet-rj-pratica-pesquisa/tema4#Documentation) • [Development](https://github.com/cefet-rj-pratica-pesquisa/tema4#Development) • [Credits](https://github.com/cefet-rj-pratica-pesquisa/tema4#Credits) • [License](https://github.com/cefet-rj-pratica-pesquisa/tema4#!License)

![cefet](https://user-images.githubusercontent.com/79878761/157667895-d4374249-4d21-46a2-a1f9-aae80bb208dc.jpg)

## [About](https://github.com/cefet-rj-pratica-pesquisa/tema4#About)

This R package was made based in the article "Um framework para integração e análise de métodos de detecção de eventos em séries temporais". Because of this, it focuses on event detection, its methods, plottings and evaluation methods. The R package was Developed at CEFET/RJ for an academic work.

Throughout the following parts of this text, you may be able to study some examples of fundamental methods of the package, the documentation of each method, the steps followed based on the book "R packages" by Hadley Wickham and Jenny Bryan. Please feel free to make contributions and contact in case of bugs or suggestions.

## [Example](https://github.com/cefet-rj-pratica-pesquisa/tema4#Example)

The following examples are the base methods used for the event detection, plotting, and evaluation of the event detection:
````
library("harbinger")

# evtdet <- function(data,func,...){
#  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)
#
#  events <- do.call(func,c(list(data),list(...)))
#
#  return(events)
# }
````


## [Documentation](https://github.com/cefet-rj-pratica-pesquisa/tema4#Documentation)

In this part all the methods are explained.

## evaluate
````
#==== evaluate: Function for evaluating quality of event detection ====
# The evaluate function uses a diverse number of metrics for the analysis of the quality of the many event detection methods. 
# Among these metric, are: true positive, false positive, true negative e false negative, which all compose the confusion matrix; 
# accuracy, which is the ratio between the number of true forecasts and total observations; sensitivity; specificity; prevalence; 
# pos_pred_value; neg_pred_value; detection rate; detection prevalence; balanced accuracy; precision; recall and F1.             
#
# input:
#   events: output from 'evtdet' function regarding a particular times series.
#   reference: data.frame of the same length as the time series with two variables: time, event (boolean indicating true events)
#   metric: String related to the evaluation metrics based on calculation that involve both the events detected, whether corretly 
#   or not, and their total number. Default values do not exist.
#   beta: beta value. Default value= 1
#
# output:
#   calculated metric value.
````

## evtdet
````
#==== evtdet: Function for event detection ====
# input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
#   func: function for event detection having 'data' as input and a data.frame with three variables:
#         time (events time/indexes), serie (corresponding time serie) and type (event type) as output.
#   ...: list of parameters for 'func'
# output:
#   data.frame with three variables: time (events time/indexes), serie (corresponding time serie), type (event type).
````

## evtdet_anomalize
````
#==== evdet_anomalize: Function for event detection  ====
# Anomalize is an event detection method that consists of evaluating and marking anomalies,
# basing itself on decomposition methods.
#
# input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
#   method_time_decompose: selected decomposition method. Default value:
#   frequency: frequency type mode. Default value: "auto"
#   trend:  trend type mode. Default value: "auto"
#   method_anomalize: anomalize method. Default value: "iqr"
#   alpha: alpha value. Default value: 0.05
#   max_anoms: maximum of anomalies. Default value: 0.2
````
