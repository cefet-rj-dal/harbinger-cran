evtdet.otsad <- function(data,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  otsad <- function(data,method=c("CpPewma","ContextualAnomalyDetector","CpKnnCad",
                                  "CpSdEwma","CpTsSdEwma","IpPewma","IpKnnCad"),na.action=na.omit,...){
    #browser()
    serie_name <- names(data)[-1]
    names(data) <- c("time","serie")

    serie <- data$serie
    len_data <- length(data$serie)

    serie <- na.action(serie)

    omit <- FALSE
    if(length(serie)<len_data){
      non_nas <- which(!is.na(data$serie))
      omit <- TRUE
    }

    method <- match.arg(method)
    require(otsad)

    func <-
      switch(method,
             "CpPewma" = function(data, ...) otsad::CpPewma(data,...)$is.anomaly,
             "ContextualAnomalyDetector" = function(data, reference, ...) otsad::ContextualAnomalyDetector(data,...)$is.anomaly,
             "CpKnnCad" = function(data, ...) otsad::CpKnnCad(data,...)$is.anomaly,
             "CpSdEwma" = function(data, ...) otsad::CpSdEwma(data,...)$is.anomaly,
             "CpTsSdEwma" = function(data, ...) otsad::CpTsSdEwma(data,...)$is.anomaly,
             "IpPewma" = function(data, ...) otsad::IpPewma(data,...)$is.anomaly,
             "IpKnnCad" = function(data, ...) otsad::IpKnnCad(data,...)$is.anomaly
      )

    index.outlier <- which(as.logical(func(data=serie,...)))

    if(omit) index.outlier <- non_nas[index.outlier]

    anomalies <- cbind.data.frame(time=data[index.outlier,"time"],serie=serie_name,type="anomaly")
    names(anomalies) <- c("time","serie","type")

    return(anomalies)
  }

  events <- evtdet(data,otsad,...)

  return(events)
}
