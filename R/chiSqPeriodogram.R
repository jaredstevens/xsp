#'Calculate chi-square periodogram
#'Edits:
  #'Uses 6 min rather than 1 min bins
  #'Allows user to choose period range tested
  #'Uses purrr::map_dbl rather than apply
#'
#'@param activityDF data frame containing time and activity values
#'@param periodRange a vector of two values indicating the range of periods to be tested
#'@param res time resolution for calculating chi-squared statistics
#'
#'@return data frame of two columns (dateTime (min), Qp value)
#'
#'@export
chiSqPeriodogram <- function(activityDF, periodRange = c(5, 35), res = 0.1){
  testPerVec <- seq(periodRange[1],periodRange[2],by=res)
  qpArray <- map_dbl(testPerVec, ~ calcQp(activityDF$value, .x))
  sigArray <- map_dbl(testPerVec, ~ qchisq(0.99^(1/length(testPerVec)),
                                           round(.x * 10)))
  data.frame(testPeriod=testPerVec, Qp.act=qpArray, Qp.sig=sigArray)
}

#'calculate Qp (Uses 6 min rather than 1 min bins)
#'
#'@param values activity values (each value represents the measured activity in a minute)
#'@param varPer a period at which the chi-squared statistics is to be calculated
#'
#'@return a numeric of the calculated chi-squared statistics at the given varPer
calcQp <- function(values, varPer){
  colNum <- round(varPer*10)
  rowNum <- floor(length(values)/colNum)
  foldedValues <- matrix(values[1:(colNum*rowNum)], ncol=colNum, byrow=T)
  avgAll <- mean(foldedValues);
  avgP <- apply(foldedValues, 2, mean)
  numerator <- sum((avgP-avgAll)^2)
  denom <- sum((values-avgAll)^2)/(rowNum*colNum*rowNum)
  qp <- numerator/denom
  return(qp)
}
