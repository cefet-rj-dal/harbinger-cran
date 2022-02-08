#==== evdet_eventdetect: Função para detecção de eventos ====
#   eventdetect é um método de detecção de eventos que consiste em avaliar o dataframe e marcar anomalias
# implementando algoritmos do pacote EventDetectR. Esse pacote simula, detecta e classifica dados de séries temporais.
# input:
#   data: data.frame com uma ou mais variáveis (série temporal) onde a primeira referência tempo.
# output:
#   events --> data.frame com output de evtdet(data, eventdetect):
#               tempo (indíces ou tempo de evento),
#               série (correspondente a uma série temporal) e
#               tipo (tipo do evento) como output.

evtdet.eventdetect <- function(data,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  eventdetect <- function(data,windowSize=200,nIterationsRefit=150,
                          dataPrepators="ImputeTSInterpolation",buildModelAlgo="ForecastBats",
                          postProcessors="bedAlgo",postProcessorControl = list(nStandardDeviationsEventThreshhold = 5),...){

    require(EventDetectR)

    #browser()
    names(data) <- c("time",names(data)[-1])
    series_names <- ifelse(length(names(data)[-1])>1,"all",names(data)[-1])

    anomalies <-
      detectEvents(subset(data, select=-c(time)),windowSize=windowSize,nIterationsRefit=nIterationsRefit,
                   dataPrepators=dataPrepators,buildModelAlgo=buildModelAlgo,
                   postProcessors=postProcessors,postProcessorControl=postProcessorControl,...)$classification

    anomalies <- cbind.data.frame(time=data[anomalies$Event==TRUE,"time"],serie=series_names,type="anomaly")
    #anomalies$time <- as.POSIXct(as.numeric(anomalies$time),origin="1960-01-01")
    names(anomalies) <- c("time","serie","type")

    return(anomalies)
  }

  events <- evtdet(data,eventdetect,...)

  return(events)
}
