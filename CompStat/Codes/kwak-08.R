# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang M.Sc.Datenwissenschaft  *
# *          Uebungsblatt Nr.8                   *
# *          Uebung am Freitag                   *
# ************************************************

rm(list=ls())
library(testthat)
library(mvtnorm)

##### Aufgabe 1)

# quadraticInterpolation - estimates where the minimum value of the input
#                          function might be, based on lecture slides p.393.
# Inputs : 
#  f           - a function of which the minimum value is searched.
#  upper       - Real number. Initial value of upper bound of search interval
#  lower       - Real number. Initial value of lower bound of search interval.
#
# Outputs:
#   best       - Real number. The best guess of x to find the global minimum
#                of the input function.

## Formula from the Uebungsblatt Nr.8
new <- function(f, upper, lower, best){
  return(0.5 * (f(upper)*(lower^2 - best^2) + f(best)*(upper^2 - lower^2) + 
                f(lower)*(best^2 - upper^2)) / 
               (f(upper)*(lower - best) + f(best)*(upper - lower) +
                f(lower)*(best - upper))) }


quadraticInterpolation <- function(f, lower, upper){
  ## The code is based on the lecture slide p.393.
  precision <- 0.5
  best <- (lower + upper) / 2
  new  <- new(f, upper, lower, best)
  i <- 0
  
  while (abs(upper-lower) >= precision*(abs(best) + abs(new)) ) {
    if (f(new) < f(best)){
      temp.new <- new
      new <- best
      best <- temp.new
    }
    if (new < best){
      lower <- new
    }
    else{
      upper <- new
    }
    new.strich <- new
    
    ## The algorithm from the lecture slide p.393 needs to be partly modified 
    ## with this if-statement, because there are cases of occuring "NaN"s
    ## due to division by 0 when getting "new" through the formula.
    ## When denominator is 0, the algorithm terminates and returns the value of
    ## new, which is so far the best guess of the position of the global
    ## minimum of the input function.
    if ((f(upper)*(lower - best) + 
         f(best)*(upper - lower) +
         f(lower)*(best - upper)) == 0 ){
      return(new)
    }
    new  <- new(f, upper, lower, best)
    if (new == new.strich || new <= lower || new >= upper){
      return(best)
    }
  } ## end while
  return(best)
}

## Tests
testMyQuadraticInterpolation <-function(){
  
  ## 4 Test functions:
  f1 <- function(x){return(x^2 - 2*x+1)}          ## global minimum when x = 1
  f2 <- function(x){return(exp(x) + exp(-x))}     ## global minimum when x = 0
  f3 <- function(x){
    return(abs(x-3)+abs(x-6)+abs(x-9))}           ## global minimum when x = 6
  
  f4 <- function(x){                              ## glboal minimum when x = 1
    stopifnot(x <= 2 && x >=0)                    ## domain of x is [0, 2],
    return(-sqrt(-x+2)-sqrt(x))}
  
  Tolerance <- 0.01
  test_that("Quadratic Interpolation test", {
    expect_true(abs(1 - quadraticInterpolation(f1, -10, 30)) < Tolerance)
    expect_true(abs(0 - quadraticInterpolation(f2, -10, 30)) < Tolerance)
    expect_true(abs(1 - quadraticInterpolation(f4, 0, 2)) < Tolerance)
  })
  
  Tolerance <- 0.05
  test_that("one more Quadratic Interpolation test", {
    ## The performance of Quadratic Interpolation is slightly not satisfactory 
    ## when it comes to testing f4.
    expect_true(abs(6 - quadraticInterpolation(f3, -30, 30)) < Tolerance)
    })
}
testMyQuadraticInterpolation()



##### Aufgabe 2)

#### Aufgabe 2-a)
# absOptimierung - the function of optimization problem. 
# Inputs : 
#  theta       - a numeric Skalar.
#  x           - a (here as 'default' designated) numeric vector. 
#                We need to find median of this vector. 
# Outputs:
#              - function value(sum of absolute values of x-theta) at the 
#                point of theta.

absOptimierung <- function(theta, x=c(15, 51, 33, 20, 66, 35, 72, 3, 34)){
  return(sum(abs(x - theta)))
}

# randomThetaWithinInterval - a function that generates a random value of an
#                             Interval. I've chosen the distance of each value, 
#                             0.1.
# Inputs : 
#  theta.lower       - a numeric Skalar. Lower bound of an interval.
#  theta.upper       - a numeric Skalar. Upper bound of an interval.
#
# Outputs:
#              - function value(sum of absolute values of x-theta) at the 
#                point of theta.
randomThetaWithinInterval <- function(theta.lower, theta.upper){
  
  ## if there are only three elements within the interval, the middle of them
  ## will be returned.
  if (length((10*theta.lower):(10*theta.upper)/10) == 3 ){
    return (((10*theta.lower):(10*theta.upper)/10)[2])
  }
  
  ## random value within the interval return.
  else if (length((10*theta.lower):(10*theta.upper)/10) > 3 ){
    n <- length((10*theta.lower):(10*theta.upper)/10)
    return (sample(((10*theta.lower):(10*theta.upper)/10)[-c(1, n)], 1))
  }
  ## if there are 2 or less elements, return the lower bound.
  else{
    return(c(theta.lower))
  }
}

# plotting       - Visualization at the end of each iteration. plots updated 
#                  values of theta.left, theta.right, theta.new, and theta.best.
#                  Please note: theta.new is the value which was selected at
#                  the beginning of each iteration.
#
#                - further details of inputs in 'MedianSearch'                        
## plotting
plotting <- function(theta.left, theta.right, theta.new, theta.best){
  ## lines visualization
  abline(v=theta.left, col="blue")
  abline(v=theta.right, col="blue")
  abline(v=theta.new, col="blue")
  abline(v=theta.best, col="blue")
  
  ## texts
  text(theta.left, 300, "theta.left", col = "red")
  text(theta.right, 300, "theta.right", col = "red")
  text(theta.new, 200, "theta.new", col = "red")
  text(theta.best, 200, "theta.best", col = "red")  
}

# MedianSearch       - a function that finds the Median of an input vector
#                      (here the vector is as default given.) from the lecture
#                      slides p.362-364.
# Inputs :
#  theta.left       - a numeric Skalar. Lower bound of an interval.
#  theta.right      - a numeric Skalar. Upper bound of an interval.
#  theta.new        - a numeric Skalar. One suggested value at the beginning
#                     of each iteration, which could be the best new value
#                     to minimize the function.
#  theta.best       - a numeric Skalar. Currently the best guess that minimizes
#                     the function.
#
# Outputs:
#                    - plot.
#                    - shortend interval of the bounds, in which values the
#                      minimize the function 

MedianSearch <- function(){
  ## the vector of interest:
  x <- c(15, 51, 33, 20, 66, 35, 72, 3, 34)
  
  
  ## Initial values of lower and upper bounds of an interval.
  theta.left <- min(x)
  theta.right <- max(x)
  theta.best <- randomThetaWithinInterval(theta.left, theta.right)
  
  ## For plotting, background data computation
  memory.vec <- rep(0, 100)
  for(i in 1:100){
    memory.vec[i] <- absOptimierung(i)
  }
  
  ## theta.new, theta.left, and theta.right update
  while ((theta.right - theta.left) > 1){
    theta.new <- randomThetaWithinInterval(theta.left, theta.right)
    
    if(theta.left > theta.best || theta.best > theta.right){
      break
    }
    if(absOptimierung(theta.best) > absOptimierung(theta.new)){
      temp.theta.best<- theta.best
      theta.best <- theta.new
      theta.new <- temp.theta.best
    }
    if(theta.new > theta.best){
      theta.right <- randomThetaWithinInterval(theta.new, theta.right)
    }
    else{
      theta.left <- randomThetaWithinInterval(theta.left, theta.new)
    }
    
    ## plotting. Please [enter] to continue each iteration and visualize
    ## the updated values of thetas.
    plot(seq(100), memory.vec, 
         main = "Search Interval and Positions of theta after this iteration")
    plotting(theta.left, theta.right, theta.new, theta.best)
    readline(prompt="Press [enter] to continue")
    plot.new()
  }
  return(c(theta.left, theta.right))
}

## Aufgabe 2-a)
## Hinschaulich kann man sagen, dass die Median 34 ist.
MedianSearch()

################################################################################
#### Aufgabe 2-b) Sorry. I spent to much time debugging my codes. Took too much
#### Aufgabe 2-c) Time. I'll see what I can do to do faster next time.
#### Aufgabe 2-d)
#### Aufgabe 2-3)
################################################################################



##### Aufgabe 3)
# bivariateNormal      - probability density function of negative bivariate 
#                        normal distribution.
# Inputs:
#   x          - a numeric Skalar. One value of the two random variables.
#   y          - a numeric Skalar. The other value of the two random variables.
#   mu.x       - a numeric Skalar. Mean value of random variable x.
#   mu.y       - a numeric Skalar. Mean value of random variable y.
#   var.x      - a numeric Skalar, variance of x
#   var.y      - a numeric Skalar, variance of y
#   rho        - a numeric Skalar, korrelation of the two variables. must belong
#                to [-1, 1].
# Outputs:
#   f(x, y)      - probability density at the point (x, y).

## Please note that I've chosen mu.x, mu.y, var.x, var.y as default,
## in order to test the function which refers to Aufgabe 3-b).

bivariateNormal <- function(x, y, mu.x = 3 , mu.y = 10, var.x = 1, 
                            var.y =4, rho = 0.5){
  z <- ((x - mu.x)^2)/var.x + 
       ((y - mu.y)^2)/var.y - 
       ((2*rho)*(x - mu.x)*(y - mu.y))/sqrt(var.x*var.y)
  
  return(-(1/(2*pi*sqrt(var.x*var.y)*(sqrt(1 - rho^2))))*
           exp(-z/(2*(1-rho^2))))
}



# innereMinimierung     - computes the initial value of search intervall 
#                         [v.left, v.right]. This interval will be minimized
#                         through quadraticInterpolation later on, in order to
#                         find the right v(=stepsize).
# Inputs:
#   f                   - a function of optimization problem. 
#   E                   - positive real number. very small number, epsilon.
# Outputs:
#   c(v.left, v.right)  - a numeric vector. initial search interval.

innereMinimierung<- function(f, E){
  if ( f(E) < f(0) ){
    v.left <- 0
    v.right <- 0.01
    while ( f(v.right) < f(v.right - E) ){
      v.right <- v.right + 0.01
    }
  }
  else{
    v.right <- 0
    v.left <- -0.01
    while(f(v.left) < f(v.left + E)){
      v.left <- v.left - 0.01
    }
  }
  return(c(v.left, v.right))
}

# koordinatenAbstieg - Coordinate Descent process from the lecture slides 
#                      p.418-425. This function is implemented to find the 
#                      global minimum of an input function. In this example
#                      it is implemented to find the global minimum of negative
#                      density function of bivariate normal distribution.
#                      Please note that the function is not fully automatized.
# Inputs : 
#  n           -   Natural Number. The number of Iteration.
#  E           -   small number, Epsilon.
#  f           -   the function of which we'd like to find it's minimum points.
#                  As default I've chosen the probability density function of
#                  negative bivariate normal distribution.
#
# Outputs:
#   new.theta  - a numeric vector of two estimated values, where the the the 
#                input function is minimized.

## Please note: I've tried my best to avoid "copy-and-paste"! If you can give
##              me comments about this, it could be my pleasure: whether 
##              there's more room for possible improvements. 

koordinatenAbstieg <- function(n=100, E = 0.001, f=bivariateNormal){
  ## Initial value of new.theta. Here I've chosen c(0, 0)
  new.theta <- c(0, 0)
  
  ## The process will be iterated n times.
  for (k in 1:n){ ## Abbruchkriterien 4: if it reaches designated number
                  ##                     of iteration number, it stops.
    
    ## 3 ideas were introduced during the lecture to choose the unit vector.
    ## All of them might work, but here I've decided to choose them randomly
    ## for each iteration. Especially I think that the way using Modulo to 
    ## choose the unit vector is pretty risky, because it could take more 
    ## iteration than we expected when the problem is not good conditioned.
    
    m <- sample(1:2, 1) ## to random number among 1, 2
    
    if (m == 1){ ## if m == 1, choose unit vector of e = c(1, 0).
      e <- c(1, 0)
      
      ## definition of the target function. It's now a function of v.
      ## x, y values are fixed.
      f.x.v <- function(v, target.function = f){
        return (target.function(new.theta[1]+v, new.theta[2])) 
      }
      
      ## v.left and v.right calculation
      v.lr.vec <- innereMinimierung(f.x.v, E)
      
      ## using quadraticInterpolation from Aufgabe 1 to compute v.
      ## (according to the notations of lecture note, it is v*.)
      ## v is the stepsize and will be needed at the end of this iteration,
      ## in order to update new.theta.
      v <- quadraticInterpolation(f.x.v, v.lr.vec[1], v.lr.vec[2])
    }
    
    else { ## if m == 2, e = c(0, 1)
      e <- c(0, 1)
      f.y.v <- function(v, target.function = f){
        return (target.function(new.theta[1], new.theta[2] + v))
      }
      v.lr.vec <- innereMinimierung(f.y.v, E)
      v <- quadraticInterpolation(f.y.v, v.lr.vec[1], v.lr.vec[2])
    }
    
    ## Abbruchkriterien 1: 
    ## if sqrt(sum((k+p)th.new.theta^2 - (k)th.new.theta^2)) < E, then 
    ## the iteration stops. The problem is, in Aufgabe 3-a) " p = n ".
    ## When p = n, there's no point to use p = n.
    ## For example, it is impossible compare 1st new.theta with 101st updated
    ## new.theta , because the algorithm stopswhen k reaches 100. 
    ## (Abbruchkriterien 4)
    
    
    ## new.theta update
    new.theta <- new.theta + e*v
  }
  return(new.theta)
}
## Testen
testMyCoordinateDescent <-function(){
  test_that("coordinate descent test test", {
    A <- koordinatenAbstieg()[1]
    B <- koordinatenAbstieg()[2]
    expect_true(bivariateNormal(A, B) < bivariateNormal(A+0.001, B))
    expect_true(bivariateNormal(A, B) < bivariateNormal(A, B+0.001))
    expect_true(bivariateNormal(A, B) < bivariateNormal(A-0.001, B))
    expect_true(bivariateNormal(A, B) < bivariateNormal(A, B-0.001))
    expect_true(bivariateNormal(A, B) < bivariateNormal(A-0.001, B-0.001))
    expect_true(bivariateNormal(A, B) < bivariateNormal(A+0.001, B+0.001))
    expect_true(bivariateNormal(A, B) < bivariateNormal(A+0.001, B-0.001))
    expect_true(bivariateNormal(A, B) < bivariateNormal(A-0.001, B+0.001))
  })
}
testMyCoordinateDescent()

## after 100 iterations it seems that coordinate descent reaches global
## minimum, where x = 3, y = 10. The value of the function is smaller
## than any other points within the range of 0.001.

