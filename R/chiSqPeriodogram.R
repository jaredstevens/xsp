#'Calculate chi-square periodogram
#'
#'@param activityDF data frame containing time and activity values
#'@param res time resolution for calculating chi-squared statistics
#'
#'@return data frame of two columns (dateTime (min), Qp value)
#'
#'@export
chiSqPeriodogram <- function(activityDF, res=0.1){
  testPerVec <- seq(5,35,by=res)
  qpArray  <- apply(as.array(testPerVec), 1, function(x) calcQp(activityDF$value,x))
  sigArray <- apply(as.array(testPerVec), 1, function(x) qchisq(0.99^(1/length(testPerVec)), round(x*60)))

  data.frame(testPeriod=testPerVec, Qp.act=qpArray, Qp.sig=sigArray)
}

#'calculate Qp
#'
#'@param values activity values (each value represents the measured activity in a minute)
#'@param varPer a period at which the chi-squared statistics is to be calculated
#'
#'@return a numeric of the calculated chi-squared statistics at the given varPer
calcQp <- function(values, varPer){
  colNum <- round(varPer*60)
  rowNum <- floor(length(values)/colNum)
  foldedValues <- matrix(values[1:(colNum*rowNum)], ncol=colNum, byrow=T)
  avgAll <- mean(foldedValues);
  avgP <- apply(foldedValues, 2, mean)
  numerator <- sum((avgP-avgAll)^2)
  denom <- sum((values-avgAll)^2)/(rowNum*colNum*rowNum)
  qp <- numerator/denom
  return(qp)
}
