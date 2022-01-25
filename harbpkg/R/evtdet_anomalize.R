
evtdet.anomalize <- function(data,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  anomalize <- function(data,method_time_decompose="stl",frequency="auto",trend="auto",method_anomalize="iqr",alpha=0.05,max_anoms=0.2,na.action=na.omit,...){
    require(anomalize)
    require(magrittr)
    #browser()
    serie_name <- names(data)[-1]
    names(data) <- c("time","serie")

    e <- tryCatch(data$serie <- na.action(data$serie), error = function(e) NULL)
    if(is.null(e)) data <- na.action(data)

    anomalies <-   tibble::as.tibble(data)

    anomalies <-   anomalize::time_decompose(anomalies,serie, method=method_time_decompose, frequency=frequency, trend=trend)
    anomalies <-   anomalize::anomalize(anomalies, remainder, method=method_anomalize, alpha=alpha, max_anoms=max_anoms)
    anomalies <-   anomalize::time_recompose(anomalies)

    anomalies <- cbind.data.frame(time=anomalies[anomalies$anomaly=="Yes","time"],serie=serie_name,type="anomaly")
    names(anomalies) <- c("time","serie","type")

    return(anomalies)
  }

  events <- evtdet(data,anomalize,...)

  return(events)
}
