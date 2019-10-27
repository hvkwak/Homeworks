# ************************************************
# *          CStat 18-19  Quellcode              *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.13                  *
# *          Uebung am Freitag                   *
# ************************************************
rm(list=ls())
setwd("/home/hyobin/Documents/CS 1819/Uebungszettel/UB13")
load("crunchigkeit.RData")
load("bic_data.RData")
setwd("/home/hyobin/Documents/CS 1819/Abgaben/UB13")
source("Kwak-13-EA.R") # Appendix
library(microbenchmark)
set.seed(2238)

##### Aufgabe 1)

#### Aufgabe 1-a)
# lm.k.fold     - estimates Mean Sqaured Error(MSE) of a linear model 
#                 using k-cross-validation
#
# Input:
#   data        - a numeric data frame with several variables. 
#   target      - a numeric vector, target of estimation.
#   k           - the number of folds of cross-validation
#
# Output:
# mean(MSE.vec) - mean value of estimated MSEs of each 
#                 iteration of cross-validation

lm.k.fold <- function(data, target, k){
  
  S <- length(target) ## sample size
  E <- ceiling(S/k) ## the number of elements in a fold.
  
  ## as.data.frame() is needed because sometimes the input is a 1-D.
  data <- as.data.frame(data)
  
  ## index.mat indicates how the elements are divided into folds.
  ## each row indicates a fold.
  index.mat <- matrix(c(sample(1:S, S), rep(NA, E*k-S)), 
                      nrow = k, ncol= E, byrow=TRUE)
  MSE.vec <- rep(0, k) ## memory vector.
  
  ## Linear Model
  for(i in 1:k){
    ## leave this out: x, y
    x <- data[ index.mat[i,][!is.na(index.mat[i,])], ] ## (E x Vars) Matrix
    y <- target[ index.mat[i,][!is.na(index.mat[i,])] ]
    
    ## These X and target.y are used to estimate coefficients of the model.
    X <- data[-index.mat[i,][!is.na(index.mat[i,])],]
    target.y <- target[-index.mat[i,][!is.na(index.mat[i,])]]
    
    ## create formula
    var.name <- paste(colnames(data), collapse = "+")
    form <- as.formula(paste("target.y", var.name, sep = " ~ "))
    
    ## when X is 1-D, it should be declared one more time as.data.frame.
    if(is.vector(X)){
      X <- as.data.frame(X)
      colnames(X) <- colnames(data)  
    }
    
    fit.lm <- lm(formula = form, data = cbind(X, target.y) )
    
    y.hat.vec <- as.matrix(cbind(1, x))%*%fit.lm$coef
    MSE.vec[i] <- sum((y.hat.vec - y)^2) / length(y.hat.vec)
  }
  return(mean(MSE.vec))
}
## Testen:
lm.k.fold(bic.data[,-ncol(bic.data)], bic.data[, ncol(bic.data)], 10)


#### Aufgabe 1-b)
# f             - a function of an optimization problem.
#
# Input:
#   x           - a binary vector. Each element indicates if the variables
#                 of corresponding positions in this vector are to be included 
#                 or not, to fit a linear model.
#                 ex) c(1, 0, 1) : the first and the last variables
#                                  are used.
#   k           - the number of folds of cross-validation
#
# Output:
#               - returns the mean(MSE.vec), using activated variables.

f <- function(x, k=10){
  return(lm.k.fold(bic.data[ ,(1:length(x))[x==1]], 
                   bic.data[ ,ncol(bic.data)], k))
}

## Variable Selection:
varSelectorEA(f, mu = 50, lambda=50, 
               lower = rep(0, 14), 
               upper = rep(1, 14), 
               stopp=20)

## The function above takes more than a minute. The result of the function
## is as follows:
###########################################################################
## $best.vector
## [1] 1 0 0 1 1 1 0 0 1 1 1 1 1 0

## $f.value
## [1] 53451.92

## $how.many.variables
## [1] 9
############################################################################
## Comments:
## Selecting 9 variables of V1, V4, V5, V5, V9, V10, V11, V12 and V13 could be 
## a good idea to fit the model which reaches to the mean(MSE.vec) of 53451.92.
## Different settings of parameter is also applicable to get better f.value. 



##### Aufgabe 2)
#### Aufgabe 2-a)
# bootstrapTest - execute a bootstrap-test to check if there's difference
#                 of a mean value between two data sets.
#                 (H0: mean(X) = mean(Y) vs. H1: mean(X) ≠ mean(Y))
# Input:
#   x           - a numeric vector, a data set
#   y           - a numeric vector, the other data set
#
# Output:
#  p.value      - returns p-value of the test.
bootstrapTest<- function(x, y){
  
  r.mean <- mean(x)
  l.mean <- mean(y)
  start.mean <- r.mean - l.mean
  
  B <- 1000 ## Instead of using: B <- factorial(length(two.sample))
  two.sample <- c(x, y)
  
  shuffled.vec <- sample(two.sample, length(two.sample)*B, replace =TRUE )
  shuffled.mat <- matrix(shuffled.vec, nrow = B, ncol = length(two.sample))
  
  r.shuffled.mat <- shuffled.mat[,1:length(x)]
  l.shuffled.mat <- shuffled.mat[,-(1:length(x))]
  
  memory.vec <- apply(r.shuffled.mat, 1, mean) - apply(l.shuffled.mat, 1, mean)
  
  return(list(p.value = mean(memory.vec > start.mean) ) )
}
## Testen: all p-values are around 0.500, H0 could not be rejected.
bootstrapTest(right.day1, left.day1)
bootstrapTest(right.day2, left.day2)
bootstrapTest(right.day3, left.day3)

#### Aufgabe 2-b)
# bootstrapPower - measures the power of test
# Input:
#   x           - a numeric vector, a data set
#   y           - a numeric vector, the other data set
#   f           - a function that tests.
#   delta       - a numeric skalar of adjustment.
#   S           - the number of iteration.
#
# Output:
#  mean(ob.H0.Ablehnen)
#               - returns the probability of rejecting H0 of the test.

bootstrapPower <- function(x, y, f, delta, S=200){
  ## memory vector
  ob.H0.Ablehnen <- rep(0, S)
  
  for(i in 1:S){
    new.x <- sample(x, 100, replace = TRUE)
    new.y <- sample(y, 100, replace = TRUE) - delta ## Verschiebung: y - delta
    
    ob.H0.Ablehnen[i] <- f(new.x, new.y)$p.value < 0.05
  }
  return(mean(ob.H0.Ablehnen))
}

## Power of test-comparison with other tests, applying different values of 
## delta. bootstraptest is compared with t.test and wilcox.test.
## delta.vec = seq(0, 0.7, by = 0.05) seems to be enough for the comparison.
powerWithDelta <- function(x, y, delta.vec = seq(0, 0.7, by = 0.05)){
  
  result.mat <- matrix(0, ncol=length(delta.vec), nrow=3)
  colnames(result.mat) <- paste("delta =", delta.vec)
  rownames(result.mat) <- c("bootstrapTest", "t.test", "wilcox.test")
  
  for(i in 1:length(delta.vec)){
    result.mat[1,i] <- bootstrapPower(x, y, bootstrapTest, delta.vec[i])
    result.mat[2,i] <- bootstrapPower(x, y, t.test, delta.vec[i])
    result.mat[3,i] <- bootstrapPower(x, y, wilcox.test, delta.vec[i])
  }
  return(result.mat)
}
# powerWithDelta(right.day1, left.day1) 
# powerWithDelta(right.day2, left.day3) 
# powerWithDelta(right.day3, left.day3) 
## It takes more than a minute to run the code above. bootstrapTest shows 
## generally but slightly better "power" of testing than the other two tests. 
## I like it better because no assumption is needed on how the dataset is 
## distributed.


#### Aufgabe 2-c)
## one more test, without applying delta.
whichFunctionMorePowerful <- function(){
  
  R <- c('right.day1', 'right.day2', 'right.day3')
  L <- c('left.day1', 'left.day2', 'left.day3')
  result.mat <- matrix(0, ncol = length(R), nrow = 3)
  colnames(result.mat) <- c("Day 1", "Day 2", "Day 3")
  rownames(result.mat) <- c("bootstrapTest", "t.test", "wilcox.test")
  
  for(i in 1:3){
    x <- eval(parse(text = R[i]))
    y <- eval(parse(text = L[i]))
    
    result.mat[1,i]<- bootstrapPower(x, y, bootstrapTest, 0)
    result.mat[2,i]<- bootstrapPower(x, y, t.test, 0) 
    result.mat[3,i]<- bootstrapPower(x, y, wilcox.test, 0) 
  }
  return(result.mat)
}
whichFunctionMorePowerful()


##### Aufgabe 3)
## Erste Aufgabe: Erzeugen Sie eine 1000 x 1000 Matrix mit standardnormal-
## verteilten Eintraegen.
microbenchmark({
  X <- matrix(rnorm(1000*1000), nrow = 1000, ncol = 1000)  
}, times = 10L)
# median : 95.1074 (milliseconds)

## Zweite Aufgabe (b): Bestimmen Sie die Zeilensummen von X
microbenchmark({
  res <- rowSums(X)
}, times = 10L)
# median : 4.123 (milliseconds)

## Naechste Aufgabe (c): Jedes Element aus res soll zwischen -100 und 100
## liegen, d.h. wir wollen Ausreisser eliminieren.
microbenchmark({
  if( sum(res > 100) >= 1 ){
    res[res > 100] <- rep(100, length(res[res > 100]) )
  }
  if( sum(res < -100) >=1 ){
    res[res < -100] <- rep(-100, length(res[res < -100]) )
  }
  res2 <- res
}, times = 10L)
# median : 10.119 (microseconds)

## Letzte Aufgabe (d): Bestimmen sie die 2-Norm von res2
microbenchmark({
  res3 <- sqrt(sum( (res2^2) ) )
}, times = 10L)
# median : 4.043 (microseconds)
