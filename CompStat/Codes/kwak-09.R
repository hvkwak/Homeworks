# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.9                   *
# *          Uebung am Freitag                   *
# ************************************************

rm(list=ls())
library(mvtnorm)
library(numDeriv)
library(testit) ## warning control

## Lieber Daniel und Hendrik,
## alles gut! Bitte immer vollstaendig kritisieren! Deshalb bin ich an der Uni, 
## d.h, um verbessern und trainieren zu koennen. Ich werde nie aufhoeren. 
## Insbesondere werde ich mein Bestes geben bei jedem Uebungsblatt, 
## um die so gennante dumme bzw. unglaubige Fehler nicht wieder zu machen. 
## Ich bin fuer euere Kommentare immer dankbar. Vielen Dank. 
## Viele Gruesse, Hyovin


##### Aufgabe 2)

# quasiNewtonBFGS - solves optimization problem using Quasi-Newton Method,
#                   which implements an updating algorithm of BFGS 
#                    in order to update Hessian Matrix.
# Inputs : 
#  theta        - a numeric vector. Starting point.
#  P            - a numeric matrix. Starting Hessian Matrix. This must be
#                 positive definite.
#  c1           - Real number. Armijo Bedingung condition number. Normally it is
#                 1e-4(default setting)
#  zielFunktion - a target function of an optimization problem.
#
# Outputs:
#   theta       - a numeric vector that indicates where the possible global 
#                 optimum could be.
# zielFunktionen(theta)
#               - a real number. Global optimum after iteration.
#   k           - an integer. The number of iteration.

quasiNewtonBFGS <- function(theta, P, c1=1e-4, zielFunktion){
  
  ## Check if start theta and P are the right type of values.
  ## Because P is supposed to be positive definite, 
  ## all eigenvalues of P could be checked if they are positive.
  stopifnot(
    is.vector(theta), is.numeric(theta), is.finite(theta),
    is.matrix(P), sum((eigen(P)$values) > 0 ) == length(eigen(P)$values),
    is.numeric(P), is.finite(P) 
  )
  
  ## number of iteration.
  k <- 1
  
  ## starting stepsize
  v <- 1
  repeat{
    
    ## Line Search to compute stepsize(=v)
    PG <- P%*%grad(zielFunktion, theta)
    A <- zielFunktion(as.vector(theta - v*PG))
    B <- as.numeric(zielFunktion(theta) - 
                      c1*v*t(grad(zielFunktion, theta))%*%PG)
    if(A <= B){
      v <- v
    } else{
      v <- 0.99*v
    }
    new.theta.candidate <- theta - as.vector(v*PG)
    
    ## Implementation of Line Search with "Wolfe Bedingungen"
    if(  
      t(grad(zielFunktion, new.theta.candidate))%*%P%*%grad(zielFunktion, theta)
      < t(grad(zielFunktion, theta))%*%P%*%grad(zielFunktion, theta) &&
      
      zielFunktion(new.theta.candidate) <= 
      (zielFunktion(theta) - c1*v*t(grad(zielFunktion, theta))%*%PG) &&
      
      t(grad(zielFunktion, new.theta.candidate))%*%PG <=
      0.9*t(grad(zielFunktion, theta))%*%PG
      
    ){
      new.theta <- new.theta.candidate
    } else{
      ## If Line Search is unsuccessful, additional optimization problem
      ## should be solved, in order to find the right stepsize(= v).
      
      f.v <- function(stepsize){
        input <- as.vector(theta - stepsize*P%*%grad(zielFunktion, theta))
        return(zielFunktion(input))
      }
      ## now v* is an alternative stepsize.
      v.stern <- optimize(f.v, c(-10, 10))$objective
      new.theta <- theta - as.vector(v.stern*PG)
    }
    delta.theta<- new.theta - theta
    if (sum(abs(delta.theta) < 1e-10) == 2){
      break
    }
    
    g <- grad(zielFunktion, new.theta) - grad(zielFunktion, theta) ## vector
    
    ## g could be 0 sometimes. instead of using 0, I tried with 
    ## rep(1e-10, length(g)).
    if( sum(g==0) == length(g) ){
      g <- rep(1e-10, length(g))
    }
    
    s <- as.vector(P%*%g) 
    e <- delta.theta - s 
    
    ## Matrix U of BFGS Method
    U.BFGS <- (e%*%t(delta.theta) + delta.theta%*%t(e))/
              as.numeric(delta.theta%*%g) -
              as.numeric(t(e)%*%g)*delta.theta%*%t(delta.theta)/
              as.numeric((t(delta.theta)%*%g)^2)
    
    P <- P + U.BFGS
    theta <- new.theta
    k <- k+1
  }
  results <- list(theta, zielFunktion(theta), k)
  return(list(theta, zielFunktion(theta), k))
}

## Testen:
## If I test my algorithm with starting-theta far away from the target theta, 
## my laptop was not capable of solving the problem. I think it's because
## of round-off errors, especially during computing gradients, because
## gradients are too small and automatically considered as 0 in R.

## I could try a mini example. Its target function is negative bivariate 
## normal distributed probability density function. The quasiNewtonBFGS 
## function is implemented to use starting value of c(2, 4), which is supposed 
## to reach c(3, 3).

## Results are to recorded, subject to different rho values. -0.9 to 0.9.
testMyBFGS <- function(){
  rho.vec <- (-9:9)/10
  
  ## memory matrix
  memory.mat <- matrix(0, nrow =3, ncol = length(rho.vec), byrow=TRUE)
  colnames(memory.mat) <- paste("rho=", rho.vec)
  rownames(memory.mat) <- c("if converges..(1 = TRUE, 0 = FALSE)", 
                            "eucklidean distance from true solution", 
                            "Iterations")
  
  ## iteration with different rho values:
  for (i in 1:length(rho.vec)){
    rho <- rho.vec[i]
    cov.mat <- diag(1, 2) + matrix(c(0, rho, rho, 0), nrow=2)  
    target <- c(3, 3)
    bivariateNormal <-function(x, mean = target, sigma = cov.mat){
      return(-dmvnorm(x, mean, sigma))
    }
    ## starting value c(2, 4)
    result.list <- quasiNewtonBFGS(c(2.0, 4.0), diag(1, 2), 
                                   zielFunktion = bivariateNormal)
    if(sum((result.list[[1]] - target)^2) < 1e-10){
      memory.mat[1,i] <- TRUE  
    }else{
      memory.mat[1,i] <- FALSE  
    }
    memory.mat[2,i]<- sum((c(3, 3) - result.list[[1]])^2)
    memory.mat[3,i]<- result.list[[3]]
    print(paste(length(rho.vec) - i, "more iterations to go."))
  }
  
  ## Results plotting and Warning signs:
  plot(rho.vec[-which(memory.mat[1,]==FALSE)], 
       memory.mat[3,-which(memory.mat[1,]==FALSE)], 
       xlab = "rho", ylab="iteration")
  
  print("WARNING With this rho it was unsuccessful to converge.")
  print("Iterations with this row won't be plotted: ")
  print(rho.vec[which(memory.mat[1,]==FALSE)])
  
  ## For more details, please remove "#" from return(memory.mat) below:
  #return(memory.mat)
}
testMyBFGS()


##### Aufgabe 3)
# CG.gegen.BFGS - performance comparison of optimization methods between
#                 CG and BFGS, based on the lecture notes p.476
# Inputs :      
#               - no inputs
# Outputs:
# result.df     - a data frame of results. columns are b, n, k, Suboptimalitaet
#                 and the name of the implemented method(CG or BFGS)

CG.gegen.BFGS <- function(){
  result.mat <- matrix(0, ncol = 5, nrow = 64*2)
  s <- 0
  
  for (b in c(100, 200, 500, 1000)){
    for (n in c(5, 10, 15, 20)){
      for (k in c(0, 0.25, 0.5, 1)){
        s <- s + 1
        s1 <- 2*s - 1
        s2 <- 2*s
        
        ## generate data
        X.hat <- matrix(0, ncol = n, nrow =b)
        for (i in 1:b){
          X.hat[i,] <- c(rnorm(n-1, mean = 0, sd = 1), 1) 
        }
        y <- sample(c(0,1), replace=TRUE, size=b)
        yt1 <- (y%*%t(rep(1, n)))
        yt1[,n] <- 0
        X <- X.hat + k*yt1
        
        ## Set initial value as null-vector. I was unable to find theta*. 
        ## Sorry!
        initial.theta <- rep(0, n)
        
        ## Optimization Problem, a function of theta.
        f.theta <- function(theta, data.mat = X, class.data = y){
          memory.vec <- rep(0, b)
          for(i in 1:b){
            memory.vec[i] <- (class.data[i]*data.mat[i, ]%*%theta - 
                                log(1+exp(data.mat[i, ]%*%theta)))
          }
          return(-sum(memory.vec))
        }
        
        ## solve optimization problem with three different methods:
        ## glm, BFGS and CG. Here I've chosen glm as the standard to compare 
        ## with.
        ## Unfortuneately glm fails to converge sometimes. Or warnings
        ## happen. Next iteration then. 
        if(has_warning(glm.logistic <- glm.fit(X, y, 
                                               family = binomial(link='logit'), 
                                               intercept = TRUE))){
          result.mat[s1,1] <- b
          result.mat[s1,2] <- n
          result.mat[s1,3] <- k
          result.mat[s1,4] <- NA
          result.mat[s1,5] <- "BFGS"
          
          result.mat[s2,1] <- b
          result.mat[s2,2] <- n
          result.mat[s2,3] <- k
          result.mat[s2,4] <- NA
          result.mat[s2,5] <- "CG"
          next
        } else {
          glm.logistic <- glm.fit(X, y, family = binomial(link='logit'), 
                                  intercept = TRUE)
        }
        
        BFGS <- optim(initial.theta, f.theta, method = "BFGS")
        CG <- optim(initial.theta, f.theta, method = "CG")
        
        ## Suboptimalitaet comparison: CG and BFGS with glm
        Subopt.BFGS <- f.theta(glm.logistic$coefficients) - BFGS$value
        Subopt.CG <- f.theta(glm.logistic$coefficients) - CG$value
        
        ## Results
        result.mat[s1,1] <- b
        result.mat[s1,2] <- n
        result.mat[s1,3] <- k
        result.mat[s1,4] <- Subopt.BFGS
        result.mat[s1,5] <- "BFGS"
        
        result.mat[s2,1] <- b
        result.mat[s2,2] <- n
        result.mat[s2,3] <- k
        result.mat[s2,4] <- Subopt.CG
        result.mat[s2,5] <- "CG"
        
        print(paste(64 - s, "more iterations to go"))
      }
    }
  }
  result.df <- as.data.frame(result.mat)
  colnames(result.df) <- c("b", "n", "k", "Suboptimalitaet", "Method")
  return(result.df)
}
# CG.gegen.BFGS()
## As the function takes about 4 minutes to run, it is deactivated.


## Further Comments:
## 1. I couldn't find theta*.
## 2. A suitable visualization of my result.df is needed.