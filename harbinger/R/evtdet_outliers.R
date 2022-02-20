#==== evdet_outliers: Função para detecção de eventos ====
# Outliers é um método de detecção de eventos que consiste em avaliar o dataframe e marcar anomalias
# baseando-se em comparações dos valores do data.frame entre si.
# input:
#   data: data.frame com uma ou mais variáveis (série temporal) onde a primeira referência tempo.


evtdet.outliers <- function(data,...){

  outliers <- function(data,alpha=1.5){
    if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

    #browser()
    serie_name <- names(data)[-1]
    names(data) <- c("time","serie")

    serie <- data$serie

    #===== Boxplot analysis of results ======
    outliers.index <- function(data, alpha = 1.5){
      org = length(data)

      if (org >= 30) {
        q = quantile(data)

        IQR = q[4] - q[2]
        lq1 = q[2] - alpha*IQR
        hq3 = q[4] + alpha*IQR
        cond = data < lq1 | data > hq3
        index.out = which(cond)#data[cond,]
      }
      return (index.out)
    }

    #Returns index of windows with outlier error differences
    index.out <- outliers.index(serie,alpha)

    anomalies <- cbind.data.frame(time=data[index.out,"time"],serie=serie_name,type="anomaly")
    names(anomalies) <- c("time","serie","type")

    return(anomalies)
  }

  events <- evtdet(data,outliers,...)

  return(events)
}
