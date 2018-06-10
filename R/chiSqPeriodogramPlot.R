#'Draw a graph of chi-square periodogram
#'
#'@param chiSqPrdgmDF data frame containing three column (testPerVec, Qp.act, Qp.sig)
#'
#'@return ggplot object
#'
#'@import ggplot2
#'@import reshape2
#'
#'@importFrom stats lm qchisq
#'
#'@examples
#'oscillation <- sin(seq(0, 2 * pi * 10, by = 2 * pi / 1440))
#'oscillation.df <- data.frame(dateTime = 1:length(oscillation), value = oscillation)
#'chiSqPeriodogramPlot(chiSqPeriodogram(oscillation.df))
#'
#'@export
chiSqPeriodogramPlot <- function(chiSqPrdgmDF) {
  testPeriod <- NULL
  value <- NULL
  variable <- NULL
  pos <- NULL

  df <- melt(chiSqPrdgmDF, id.vars="testPeriod")

  pk <- getPeak(chiSqPrdgmDF$testPeriod, chiSqPrdgmDF$Qp.act, chiSqPrdgmDF$Qp.sig, 2)
  .e <- environment()
  p <-  ggplot(df, environment=.e) + geom_line(aes(x=testPeriod, y=value, colour=variable))
  p <- p + scale_color_manual(values=c("deepskyblue2","red2"))
  p <- p + geom_vline(data=pk, aes(xintercept=pos), linetype="dotted")
  p <- p + scale_x_continuous(breaks=seq(4,36,by=4))
  p <- p + geom_text(aes(x=Inf, y=Inf, label=sprintf("Period: %2.2f[h]",pk$pos)), vjust=1, hjust=1)
  p + xlab("period [h]") + ylab("Qp")
}

#'find the peak value from chi-squared periodogram
#'
#'@param x times at which each chi-squared statistics is calculated
#'@param y chi-squared statistics calculated from an activity data
#'@param z chi-squared statistics calculated from a null-hypothesis
#'@param p number of points to be used for fitting a quadratic function
#'
#'@return data frame with five numerics
getPeak <- function(x, y, z, p){
  parStoreLen <- length((1+p):(length(x)-p))
  parMat <- data.frame(
    const =rep(0,parStoreLen),
    first =rep(0,parStoreLen),
    second=rep(0,parStoreLen),
    value =rep(0,parStoreLen),
    pos   =rep(0,parStoreLen))
  for (i in (1+p):(length(x)-p) ){
    fit <- lm(y~x+I(x^2),data.frame(x=x[(i-p):(i+p)], y=y[(i-p):(i+p)]))
    parMat[i,] = c(fit$coefficients[1],
                   fit$coefficients[2],
                   fit$coefficients[3],
                   fit$coefficients[1] + fit$coefficients[2]*x[i] + fit$coefficients[3]*x[i]^2 - z[i],
                   -fit$coefficients[2]/(2*fit$coefficients[3])
    )
  }
  parMatValid <- parMat[parMat[,3]<0,]
  peakFitPar <- parMatValid[order(parMatValid$value, decreasing=T)[1],c(1,2,3,4,5)]
  peakFitPar
}
