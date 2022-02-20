evtdet.garch_volatility_outlier <- function(data,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  garch_volatility_outlier <- function(data,spec,value=c("var","sigma"),alpha=1.5,na.action=na.omit,...){
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

    #====== GARCH - volatility ======
    #GARCH fit function
    garch <- function(data,spec,...) rugarch::ugarchfit(spec=spec,data=data,solver="hybrid", ...)

    #Modeling
    g <- garch(serie,spec)@fit

    #Getting instantaneous volatilities
    value <- match.arg(value)
    volatilities <- g[[value]]

    #===== Boxplot analysis of results ======
    outliers.index <- function(data, alpha = 1.5){
      org = length(data)

      index.cp <- NULL
      if (org >= 30) {
        q = quantile(data)

        IQR = q[4] - q[2]
        lq1 = q[2] - alpha*IQR
        hq3 = q[4] + alpha*IQR
        cond = data < lq1 | data > hq3
        index.cp = which(cond)#data[cond,]
      }
      return (index.cp)
    }

    #Returns index of windows with outlier error differences
    index.cp <- outliers.index(volatilities,alpha)

    if(omit) index.cp <- non_nas[index.cp]

    anomalies <- cbind.data.frame(time=data[index.cp,"time"],serie=serie_name,type="volatility anomaly")
    names(anomalies) <- c("time","serie","type")

    return(anomalies)
  }

  events <- evtdet(data,garch_volatility_outlier,...)

  return(events)
}
