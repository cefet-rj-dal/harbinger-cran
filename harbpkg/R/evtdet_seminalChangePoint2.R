evtdet.seminalChangePoint2 <- function(data,...){
  if(is.null(data)) stop("No data was provided for computation",call. = FALSE)

  changepoints_v2 <- function(data,mdl,w=100,na.action=na.omit,...){
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

    #===== Creating sliding windows ======
    ts.sw <- function(x,k)
    {
      ts.lagPad <- function(x, k)
      {
        c(rep(NA, k), x)[1 : length(x)]
      }

      n <- length(x)-k+1
      sw <- NULL
      for(c in (k-1):0){
        t  <- ts.lagPad(x,c)
        sw <- cbind(sw,t,deparse.level = 0)
      }
      col <- paste("t",c((k-1):0), sep="")
      rownames(sw) <- NULL
      colnames(sw) <- col
      return (sw)
    }

    serie <- data.frame(ts.sw(serie, w))
    serie <- serie[complete.cases(serie), ]

    #===== Function to analyze each data window ======
    analyze_window <- function(data,mdl_fun,...) {
      error_func <- function(x) mean(x^2)
      #Window W = {x_i:i=u,u+1,...,t} = {x_u, x_u+1, ..., x_t}, Where t=u+w-1 and |W| = w
      #Creating dataframe with W
      W <- as.data.frame(t(data))
      colnames(W) <- "x"

      #Adjusting an AR(P) model to the whole window W
      mdl <- tryCatch(mdl_fun(W,...), error = function(e) NULL)
      if(is.null(mdl)) mdl <- tryCatch(mdl_fun(W), error = function(e) NULL)
      if(is.null(mdl)) return(NULL)

      #Adjustment error on the whole window
      err <- error_func(residuals(mdl))

      #for each candidate event point x_v  (v = u+k-1,...,t-k ?)
      u <- 1
      t <- length(data)
      err_ad <- NULL

      for( v in u:t ){

        #Adjusting an AR(P) model to {x_u,...,x_v}
        #Data before the candidate event point
        W_a <- W[u:(v-1),]
        mdl_a <- tryCatch(mdl_fun(W_a), error = function(e) NULL)
        if(is.null(mdl_a)) mdl_a <- tryCatch(mdl_fun(W_a,k), error = function(e) NULL)

        #Adjusting an AR(P) model to {x_(v+1),...,x_t}
        #Data after the event point
        W_d <- W[(v+1):t,]
        mdl_d <- tryCatch(mdl_fun(W_d), error = function(e) NULL)
        if(is.null(mdl_d)) mdl_d <- tryCatch(mdl_fun(W_d,k), error = function(e) NULL)

        #Combined adjustment error on the window data before and after the event
        e_ad <- ifelse(is.null(mdl_a) | is.null(mdl_d), NA, error_func(c(residuals(mdl_a),residuals(mdl_d))))

        #return 1-error on whole window; 2-error on window parts (before & after); 3-error difference
        err_ad <- rbind(err_ad, data.frame(mdl=err, mdl_ad=e_ad, mdl_dif=err-e_ad))
      }

      return(err_ad)
    }

    #===== Boxplot analysis of results ======
    outliers.index <- function(data, alpha = 1.5){
      org = length(na.omit(data))
      index.cp = NULL

      if (org >= 30) {
        q = quantile(data,na.rm=TRUE)

        IQR = q[4] - q[2]
        lq1 = q[2] - alpha*IQR
        hq3 = q[4] + alpha*IQR

        cond = data > hq3 #data < lq1 | data > hq3

        index.cp = which(cond)
      }
      else  warning("Insufficient data (< 30)")

      return (index.cp)
    }


    #===== Analyzing all data windows ======
    outliers <- NULL
    for(i in 1:nrow(serie)){
      win_error <- analyze_window(serie[i,],mdl,...)

      out <- outliers.index(win_error$mdl_dif) + (i-1)

      outliers <- c(outliers, out)
    }

    out_freq <- as.data.frame(table(outliers))

    detection_freq <- cbind.data.frame(outliers=1:nrow(data))
    detection_freq <- merge(detection_freq,out_freq,all.x=TRUE,all.y=TRUE)
    detection_freq[is.na(detection_freq$Freq), "Freq"] <- 0

    #Returns index of observations with outlier detection frequences
    index.cp <- outliers.index(detection_freq$Freq)
    index.cp <- detection_freq$outliers[index.cp]

    if(omit) index.cp <- non_nas[index.cp]

    anomalies <- cbind.data.frame(time=data[index.cp,"time"],serie=serie_name,type="change point")
    names(anomalies) <- c("time","serie","type")

    return(anomalies)
  }

  events <- evtdet(data,changepoints_v2,...)

  return(events)
}
