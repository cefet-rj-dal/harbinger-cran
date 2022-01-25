#==== soft_evaluate: Function for soft evaluating quality of event detection ====
# input:
#   events: output from 'evtdet' function regarding a particular times series.
#           A data.frame with three variables: time (events time/indexes), serie (corresponding time serie), type (event type)
#   reference: data.frame of the same length as the time series with two variables: time, event (boolean indicating true events)
#
# output:
#   calculated metric value.
soft_evaluate <- function(events, reference, k=15,
                          metric=c("confusion_matrix","accuracy","sensitivity","specificity","pos_pred_value","neg_pred_value","precision",
                                   "recall","F1","prevalence","detection_rate","detection_prevalence","balanced_accuracy"), beta=1){
  #browser()
  if(is.null(events) | is.null(events$time)) stop("No detected events were provided for evaluation",call. = FALSE)

  names(reference) <- c("time","event")
  detected <- cbind.data.frame(time=reference$time,event=0)
  detected[detected$time %in% events$time, "event"] <- 1
  reference_vec <- as.logical(reference$event)
  detected_vec <- as.logical(detected$event)


  softScores <- soft_scores(detected_vec, reference_vec, k=k)

  m <- length(which(reference_vec))
  n <- length(which(detected_vec))
  t <- length(reference_vec)

  softMetrics <- soft_metrics(softScores,m,n,t,beta=beta)

  metric <- match.arg(metric)

  metric_value <- switch(metric,
                         "confusion_matrix" = softMetrics$confMatrix,
                         "accuracy" = softMetrics$accuracy,
                         "sensitivity" = softMetrics$sensitivity,
                         "specificity" = softMetrics$specificity,
                         "pos_pred_value" = softMetrics$PPV,
                         "neg_pred_value" = softMetrics$NPV,
                         "precision" = softMetrics$precision,
                         "recall" = softMetrics$recall,
                         "F1" = softMetrics$F1,
                         "prevalence" = softMetrics$prevalence,
                         "detection_rate" = softMetrics$detection_rate,
                         "detection_prevalence" = softMetrics$detection_prevalence,
                         "balanced_accuracy" = softMetrics$balanced_accuracy)

  return(metric_value)
}
