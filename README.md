# Harbinger Package
R package that contains the event detection methods, as well as their plotting and evaluation methods, presented in the article "Um framework para integração e análise de métodos de detecção de eventos em séries temporais".

[About](https://github.com/cefet-rj-pratica-pesquisa/tema4#About) • [Example](https://github.com/cefet-rj-pratica-pesquisa/tema4#Example) • [Documentation](https://github.com/cefet-rj-pratica-pesquisa/tema4#Documentation) • [Development](https://github.com/cefet-rj-pratica-pesquisa/tema4#Development) • [Credits](https://github.com/cefet-rj-pratica-pesquisa/tema4#Credits) • [License](https://github.com/cefet-rj-pratica-pesquisa/tema4#!License)

![cefet](https://user-images.githubusercontent.com/79878761/157667895-d4374249-4d21-46a2-a1f9-aae80bb208dc.jpg)

## [About](https://github.com/cefet-rj-pratica-pesquisa/tema4#About)

This R package was made based in the article "Um framework para integração e análise de métodos de detecção de eventos em séries temporais". Because of this, it focuses on event detection, its methods, plottings and evaluation methods. The R package was Developed at CEFET/RJ for an academic work.

Throughout the following parts of this text, you may be able to study some examples of fundamental methods of the package, the documentation of each method, the steps followed based on the book "R packages" by Hadley Wickham and Jenny Bryan. Please feel free to make contributions and contact in case of bugs or suggestions.

## [Example](https://github.com/cefet-rj-pratica-pesquisa/tema4#Example)

The following examples are some of the methods used for the event detection, in this case anomalize, plotting, and evaluation of the event detection:
(these codes can also be found in the [usage.R](https://github.com/cefet-rj-pratica-pesquisa/tema4/blob/main/usage.r) file in this repository)
```
library(tibble)
library(EventDetectR)

source("https://raw.githubusercontent.com/cefet-rj-dal/harbinger/master/harbinger.R")

#========= Data =========
# === WATER QUALITY ===
train <- geccoIC2018Train[16500:18000,]
test <- subset(train, select=c(Time, Trueb))
reference <- subset(train, select=c(Time, EVENT))

#====== Anomalize ======
#Detect
events_a <- evtdet.anomalize(test,max_anoms=0.2,na.action=na.omit)
#Evaluate
evaluate(events_a, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_a, reference))
```


## [Documentation](https://github.com/cefet-rj-pratica-pesquisa/tema4#Documentation)

In this part all the methods are explained in alphabetical order.

[evaluate](https://github.com/cefet-rj-pratica-pesquisa/tema4#evaluate) • [evtdet](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet) • [evtdet_anomalize](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_anomalize) • [evtdet_changeFinder](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_changeFinder) • [evdet_eventdetect](https://github.com/cefet-rj-pratica-pesquisa/tema4#eventdetect) • [evtdet.garch_volatility_outlier](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet.garch_volatility_outlier) • [evtdet_mdl_outlier](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_mdl_outlier) • [evtdet_otsad](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_otsad) • [evtdet_outliers](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_outliers) •  •

## [evaluate](https://github.com/cefet-rj-pratica-pesquisa/tema4#evaluate)
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

## [evtdet](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet)
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

## [evtdet_anomalize](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_anomalize)
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
## [evtdet_changeFinder](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_changeFinder)

````
#==== evtdet_changeFinder: Function for event detection  ====
# This method is composed by two steps: in the first, is the detection of anomalies. The adjustmentof an incremental learning model to 
# the series occurs. Then, a score is given for every observation occured. This said score is calculated according to its notions of learned model 
# deviance, based on quadratic errors. Higher scores can be understood as anomalies. Then, in the second and final step, the identification of change
# points happens. A new time series is then produced, one which consists of the scores' moving average obtained in the first step. Again, a new 
# incremental learning model is adjusted to the new series and a score given using the learned deviance 
# model. Through this method, the detection of change points is reduced to the task of finding anomalies inside a series.
#
# general input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
#   na.action. Default value= "na.omit"
# method specific input:
#   mdl (model). Default value= linreg (linear regression)
#   m (moving average size). Minimum value= 30
#   alpha (alpha value). Default value= 1.5 
````

## [evdet_eventdetect](https://github.com/cefet-rj-pratica-pesquisa/tema4#eventdetect)
````
#==== evdet_eventdetect: Function for event detection ====
#   eventdetect is an event detection method that consists of evaluating a dataframe and marking anomalies in the process, using
#   implemented algorithms from the EventDetectR package. This package can simulate, detect and classify the data from a time series.
# input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
# Not necessary for input:
#   windowSize: defines the size of the window. Default value = 200
#   nIterationsRefit: number of interactions. Default value = 150
#   dataPrepators:  prepares data. Default value = "ImputeTSInterpolation"
#   buildModelAlgo: model builder. Default value = "ForecastBats"
#   postProcessors: post processors. Default value = "bedAlgo"
#   postProcessorControl: Controller of post. Default value = list(nStandardDeviationsEventThreshhold = 5)
````

## [evtdet.garch_volatility_outlier](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet.garch_volatility_outlier)
````
# ==== evtdet.garch_volatility_outlier: Function for event detection  ====
# The models of the GARCH type consist of the estimation of volatility using knowledge from past observations. 
# They are a non-linear time series model that are used to treat the non-linearity of data. They can then be 
# used to study the volatility of time series.
#
# general input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
#   na.action. Default value= "na.omit"
# method specific input:
#   alpha: alpha value. Default value= 1.5  
#   spec (specifications):
#      distribution.model: conditional density model. Default value= "norm" (normal distribution)
#      variance.model. Default value for model = "sGARCH"
#                      Default value for garchOrder = (1, 1)
#      mean.model. Default value for include.mean = "TRUE"
#                  Default value:armaOrder = (1, 1)
#                  Default value:include.mean = "TRUE"
#   
````

## [evdet_mdl_outlier](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_mdl_outlier)
````
#==== evdet_mdl_outlier: Function for event detection ====
# In this outlier (Model Outliers method), the model (mdl) is used as a parameter.
# The value of this parameter is a linear regression. In general, this method helps to
# find divergence points using outliers which can be treated as anomalies.
# input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
#   mdl: model.
#   alpha: alpha value.
````

## [evdet_otsad](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_otsad)
````
#==== evdet_otsad: Function for event detection ====
#   Otsad is an events detection method that consists of evaluating a dataframe and mark anomalies for a
#   time series, implementing some flaws detector algorithms from the otsad package
# input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
#   method: the selected event detection method from the otsad package (Example: "CpPewma")
````

## [evdet_outliers](https://github.com/cefet-rj-pratica-pesquisa/tema4#evtdet_outliers)
````
#==== evdet_outliers: Function for event detection ====
# Outliers is an event detection method that consists of evaluating a data.frame and mark anomalies
# basing itself in comparisons between the values of the data.frame.
# input:
#   data: data.frame with one or more variables (time series) where the first variable refers to time.
#   alpha: alpha value. Default value= "1.5"
````

## 
````

````
##Credits

This package was made with the use of the following open source projects:

   [R](https://cran.r-project.org/sources.html)
   • [devtools](https://github.com/r-lib/devtools)
   • [roxygen2](https://github.com/r-lib/roxygen2)
   • [testthat](https://github.com/r-lib/testthat)
   • [knitr](https://github.com/yihui/knitr)

We would like to thank individually our teacher, Eduardo Ogasawara, for the time and atention, as well as the knowledge given for us during his classes.
We would also like to thank Janio de Souza Lima, who always showed all interest and passion during his help towards the success of our work.

## License

MIT

## Contributors 

   Diogo Conde • [@DiogoConde](https://github.com/DiogoConde)
   Eduardo Moura • [@EduMoura-debug](https://github.com/EduMoura-debug)
   Eduardo Ogasawara • [@eogasawara](https://github.com/eogasawara)
   Janio de Souza Lima• [@janiosl](https://github.com/janiosl)
