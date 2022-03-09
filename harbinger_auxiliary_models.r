##====== Auxiliary Model definitions ======
garch11 <- rugarch::ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(1, 1), include.mean = TRUE),
  distribution.model = "norm")
ARIMA <- function(data) forecast::auto.arima(data)
AR <- function(data,p) forecast::Arima(data, order = c(p, 0, 0), seasonal = c(0, 0, 0))
garch <- function(data,spec,...) rugarch::ugarchfit(spec=spec,data=data,solver="hybrid", ...)@fit
ets <- function(data) forecast::ets(ts(data))
linreg <- function(data) {
  #browser()
  data <- as.data.frame(data)
  colnames(data) <- "x"
  data$t <- 1:nrow(data)
  #Adjusting a linear regression to the whole window
  lm(x~t, data)
}