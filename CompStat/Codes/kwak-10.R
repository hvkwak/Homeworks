# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.10                  *
# *          Uebung am Freitag                   *
# ************************************************

rm(list=ls())
library(mvtnorm)
library(testthat)

load(file.choose())
#load("/home/hyobin/Documents/CS 1819/Uebungszettel/UB10/nlkq_data.RData")

##### Aufgabe 1)
# aufgabe1       - solves a non-linear optimization problem using optim()
#
# Ausgabe:
#  theta$par     - a numeric vector. estimated parameter, theta*. 
aufgabe1 <- function(){
  modell <- function(theta){
    return (sum((theta[1] + theta[2]*X[,1] + (theta[2]^2) * X[,2] - y)^2))
  }
  theta <- optim(c(0, 0), modell)
  return(theta$par)  
}
aufgabe1()


##### Aufgabe 2)
# myNelderMead   - NelderMead-Verfahren
# Eingabe:
#    f           - a target function, whose global optimum (minimum) is 
#                  searched, from R^K to R.
#    theta.start - a numeric vector, position of the starting point. 
#    t           - a numeric scalar, the size of the Simplex
#
# Ausgabe:
#  Liste mit 2 benannten Elementen:
#    pars        - estimated parameter theta, which shows the best solution
#                  (global optimum)
#    vals        - the value of the target function at 'par'

myNelderMead <- function(f, theta.start, t = 1){
  
  ## Startsimplex. 
  K <- length(theta.start)
  # Als erstes brauchen wir den Startsimplex:
  d1 <- t / K / sqrt(2) * (sqrt(K + 1) + K - 1)
  d2 <- t / K / sqrt(2) * (sqrt(K + 1) - 1)
  theta <- matrix(d2, ncol = K, nrow = K)
  diag(theta) <- d1
  theta <- cbind(0, theta) + theta.start
  
  ## Nelder und Mead's recommendations from the lecture notes p.536:
  alpha <- 1
  beta <- 0.5
  gamma <- 2
  
  ## Nelder-Mead Method
  repeat{
    l <- which.min( c(f(theta[,1]), f(theta[,2]), f(theta[,3])) )    
    h <- which.max( c(f(theta[,1]), f(theta[,2]), f(theta[,3])) )
    
    centroid <- c( (sum(theta[1,]) - theta[,h][1])/2, 
                   (sum(theta[2,]) - theta[,h][2])/2 )
    
    ### "Stoppkriterium" from the lecture notes p.523:
    if( ((sum((apply(theta, 2, f) - f(centroid))^2))/(K+1))^(0.5) <= 1e-20 ){
      break
    }
    
    ## Operation 1: Reflection
    first.candidate <- centroid + alpha*(centroid - theta[, h])
    
    ## Operation 2: Expansion
    if ( f(first.candidate) <= f(theta[, l]) ){
      second.candidate <- centroid + gamma*(first.candidate - centroid)
      if( f(second.candidate) < f(theta[, l]) ){
        theta[,h] <- second.candidate
        next
      }else{
        theta[,h] <- first.candidate
        next
        
      }
    }else if(sum(f(first.candidate) > apply(theta[,-h], 2, f)) == 2){ 
      ## Operation 3: Contraction
      third.candidate <- centroid + beta*(theta[,h] - centroid)
      if( f(third.candidate) <= f(theta[,h]) ){
        theta[,h] <- third.candidate
        next
      }else{ ## Operation 4: Reduction
        theta.l <- theta[,l]
        for(i in 1:K+1){
          theta[,i] <- theta.l + 0.5*(theta[,i] - theta.l)}
        next
      }
    }else{
      theta[,h] <- first.candidate
    }
  }
  ## Results
  best <- which.min(apply(theta, 2, f))
  return(list(pars = theta[, best], vals = f(theta[, best])))
}


## Testen ** noch zu verbessern.
testMyNelderMead <-function(){
  test_that("Nelder-Mead method test", {
    
    ## testing with different means and covariance matrix
    test.means <- list(c(1, 3), c(2, 7), c(-3, 9), c(10, -10))
    test.cov.mat <- list(matrix(c(1, 0.5, 0.5, 1), nrow=2), 
                         matrix(c(2, -0.2, -0.2, 2), nrow=2),
                         matrix(c(3, 0.3, 0.3, 4), nrow =2),
                         diag(3, 2))
    
    for ( i in 1:length(test.means) ){
      
      ## tests of negative bivariate Normal distribution
      mean.vector <- test.means[[i]]
      cov.mat <- test.cov.mat[[i]]
      ## the target function
      b.N. <- function(x, mean = mean.vector, sigma = cov.mat){
        return(-dmvnorm(x, mean, sigma))
      }
      ## creating starting points. Distance of each element is 1+i and -1-i.
      start.theta <- mean.vector + c(1+i, -1-i)
      
      ## estimated vector of two methods comparison
      D <- myNelderMead(b.N., start.theta)$par - optim(start.theta, b.N.)$par
      expect_true( sum(D^2) < 1e-5 )
    }
  })
}
testMyNelderMead()


##### Aufgabe 3)
# f               -     the target function.
f <- function(x, n = length(x)){ 
  summe <- 0
  for (i in 1:length(x)){
    summe <- summe + x[i]^2 - 200*cos(x[i])
  }
  return(summe)
}

### Aufgabe 3-a)
# multiStarts     - finds a global optimum of the target function using multiple
#                   starting points
# Eingabe:
#    zielFunktion - a target function, whose global optimum (minimum) is 
#                   searched
#    times        - a numeric scalar, the number of trying different starting
#                   points of each iteration.
#     n           - a numeric scalar, the number of the parameter.
#    s.num        - the number of simulation number. Here it is default, 100.
#  lower, upper   - a numeric scalar, lower and upper bounds on the variables 
#                   for the "L-BFGS-B" method. Due to numeric error, instead of
#                   [-Inf, Inf], it is set to be [-1000, 1000].
#
# Ausgabe:
#  result.vec     - a numeric vector. A vector of the values of the target
#                   function, which were obtained after solving the optimization
#                   problem with multiple starting points. 

multiStarts <- function(zielFunktion, times, n, s.num=100, 
                        lower = -1000, upper = 1000){
  result.vec <- rep(0, s.num)
  for (k in 1:s.num){
    
    for(i in 1:times){
      startingpoint <- runif(n, min = lower, max = upper)
      A <- optim(startingpoint, zielFunktion, lower = lower, 
                 upper = upper, method = "L-BFGS-B")
      
      ## Each element of this vector could be updated maximal "times"-times. 
      ## if the function value of the estimated parameter is better(lower),
      ## it is updated.
      if(A$value < result.vec[k]){
        result.vec[k] <- A$value
      }
    }
  }
  return(result.vec)
}

### Aufgabe 3-b)
# plotting     -   plots the function when n = 1.
plotting <- function(){
  x <- -100:100/10
  result.f <- rep(0, length(x))
  for(i in 1:length(x)){
    result.f[i]  <- f(x[i])
  }
  plot(x, result.f, ylab = "f")  
}
plotting()
## According to the visualization of the function, the function periodically 
## forms the local optimums(due to the term cos(x)), which is very be meaningful
## as the test conditions for Multi-Starts-Test.


### Aufgabe 3-c)
# multiStarts95     -   Multi-Starts-Test using different iteration values.
multiStarts95 <- function(){
  
  ## Multi-Starting Points: from 1 to 600.
  times.vec <- c(1, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600)
  result.vec <- rep(0, length(times.vec))
  
  for(i in 1:length(times.vec)){
    print(paste("times:", times.vec[i], ", max is 600."))
    
    times <- times.vec[i]
    result <- multiStarts(f, times, 2)
    
    ## Check if the result reached the global optimum, here it is -400.
    result.vec[i] <- sum(result == -400)/length(result)
  }
  
  plot(times.vec, result.vec)
  return(result.vec)
}

## Warning: it takes about 1-2 minutes to run this code.
multiStarts95()
abline(v = NULL, h=0.95, col="red")
## We need to try at least about 550 different starting values to reach 95% 
## success-rate of finding the global optimum of the target function.