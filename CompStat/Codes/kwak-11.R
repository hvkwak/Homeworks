# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.11                  *
# *          (Weihnachtszettel)                  *
# *          Uebung am Freitag                   *
# ************************************************
rm(list = ls())
library(binaryLogic)

##### Aufgabe 1)

bitFlipping <- function(x){
  n <- length(x)
  p <- 1/length(x)
  index.vec <- which(rbinom(n, 1, p) == 1)
  
  if( length(index.vec) != 0){
    for(i in index.vec){
      if( x[i] ){
        x[i] <- 0
      }else{
        x[i] <- 1
      }       
    }
  }
  return(x)
}

bitRepresentation <- function(x){
  ## x ist ein Vektor.
  if(length(x) == 1){
    if( x < 0){
      a <- length( as.binary((-1*x)) )
      return( list( as.binary = c(0, as.binary(-1*x)), digits.until=a+1 ) )  
    }else{
      a <- length( as.binary(x) )
      return( list( as.binary = c(1, as.binary(x)), digits.until=a+1 ) )  
    }
    
  }else{
    
    result.bit.list <- list()
    result.digits.until.list <- list()
    
    for( i in 1:length(x) ){
      result.bit.list[[i]] <- bitRepresentation(x[i])$as.binary
      result.digits.until.list[[i]] <- bitRepresentation(x[i])$digits.until
    }
    
    result.vec <- as.numeric(unlist(result.bit.list))
    digits.vec <- as.numeric(unlist(result.digits.until.list))
    
    digits.until <- rep(0, length(digits.vec) )
    
    for(i in 1:length(digits.until) ){
      digits.until[i] <- sum(digits.vec[1:i])
    }
    
    return( list(bitRepresentation = result.vec, digits.until = digits.until) )
  }
}

bitRepresentation(c(1, 2))

IntegerEncoder <- function(x){
  s <- 0
  for( i in 1:(length(x)-1) ){
    if( x[length(x) - i + 1] == 1 ){
      s <- s + 2^( i-1 )
    }
  }
  if(x[1] == 1){
    return(s)  
  }else{
    return(-s)
  }
  
}

integerRepresentation <- function(bR, d.u){
  memory.vec <- rep(0, length(d.u) )
  start.pos <- 1
  for( i in 1:length(d.u) ){
    last.pos <- d.u[i]
    memory.vec[i] <- IntegerEncoder( bR[start.pos:last.pos] )
    start.pos <- last.pos+1
  }
  return( memory.vec )
}


evolutionaryAlgorithm <- function(f, mu, lambda, lower, upper){
  upper <- rep(1, 14)
  lower <- rep(0, 14)
  
  n <- length(lower)
  mu <- 100
  
  ## parents 
  parents <- list()
  for (i in 1:mu){
    memory.vec <- as.integer(rep(0, n))
    for (k in 1:n){
      memory.vec[k] <- sample(lower[k]:upper[k], 1)
      #print(typeof(memory.vec[k]))
    }
    parents[[i]] <- memory.vec
  }
  parents
  s.num <- 0
  
  repeat{
    print("b")
    ## Rekombination: (1-Punkt Crossover)
    child <- list()
    for (k in 1:(lambda/2)) {
      
      paar <- sample(parents, 2)
      point <- round( length(parents[[1]])/2 ) ## 1-point crossover
      
      child[[2*k-1]] <- c((paar[[1]])[1:point], (paar[[2]])[(point+1): n])
      child[[2*k]] <- c((paar[[2]])[1:point], (paar[[1]])[(point+1): n])
      
    }
    
    ## Mutation of Nachkommen: Bit-Flipping
    for(k in 1:length(child)){
      new.child <- bitRepresentation( child[[k]] )
      Flipped.child <- bitFlipping(new.child$bitRepresentation)
      child[[k]] <- integerRepresentation(Flipped.child, new.child$digits.until)
    }
    
    #########################################################
    ### mu from mu+lambda selection : the next generation ###
    mu.plus.lambda.candidate <- c(parents, child)
    candidate.memory.vec <- vector()
    
    ###
    
    for(i in 1:length(mu.plus.lambda.candidate)){
      ## if lower and upper is...
      if( sum( lower <= mu.plus.lambda.candidate[[i]] ) == n &&
          sum( upper >= mu.plus.lambda.candidate[[i]] ) == n  ){
        candidate.memory.vec <- c(candidate.memory.vec, i)
      }
    }
    mu.plus.lambda <- mu.plus.lambda.candidate[candidate.memory.vec]
    ######
    #print(length(mu.plus.lambda))
    
    
    memory.vec <- rep(0, length(mu.plus.lambda) )
    for( i in 1:length(mu.plus.lambda) ) {
      
      memory.vec[i] <- f( as.integer(mu.plus.lambda[[i]]) )
      
      
    }
    
    index <- which(rank(memory.vec, ties.method = "first") <= mu)
    
    new.parents <- mu.plus.lambda[index]
    ##########
    
    for(i in 1:length(new.parents)){
      new.parents[[i]] <- as.integer(new.parents[[i]])
      
    }
    
    ################################################################
    ################################################################
    
    s.num <- s.num + 1
    
    print("c")
    ## Stoppkriterium
    A <- mean( apply(do.call(rbind, parents), 1, f) )
    B <- mean( apply(do.call(rbind, new.parents), 1, f) )
    
    if(A - B < 1e-30){
      break
    }
    
    ## parents Update
    parents <- new.parents
    
    index <- which.min( apply( do.call(rbind, parents), 1, f))  
    print(f(parents[[index]]))
  }
  
  ## best.value index
  index <- which.min( apply( do.call(rbind, parents), 1, f))  
  
  ## return
  return( list( best.vector = parents[[index]], 
                f.value = f(parents[[index]]),
                repeated = s.num ) )
}

## Testen:
f <- function(x){
  if (sum(x == 0) == length(x)){
    return(2000000)
  }else{
    variable.index <- (1:14)[x==1]
    #lm.k.fold(bic.data[, variable.index], bic.data[, 15], 10)
    return(lm.k.fold(bic.data[, variable.index], bic.data[, 15], 5))  
  }
}
evolutionaryAlgorithm(f, 2000, 500, rep(0, 14), rep(1, 14))

f <- function(x){
  return(sum(x))
}






##### Aufgabe 3)
setwd("/home/hyobin/Documents/CS 1819/Uebungszettel/UB11")
load("blackbox.RData")

# f1: [−10, 10]^200 → R ist konvex. 
# Vorschlag: CG reicht, da die Funktion konvex ist.
f1.x <- rep(0, 200) ## Start-Schaetzer
optim(f1.x, f1, method = "CG")



## f2: ????????
# f2: [−10, 10]^10 → R ist stochastisch, d.h. wiederholte Auswertungen des gleichen Punktes führen
# zu unterschiedlichen Ergebnissen.
f2.x <- rep(0, 10)
optim(f2.x, f2, method = "L-BFGS-B", lower = -10, upper= 10)




# f3: [−10, 10]^5 → R hat viele lokale Optima.
# Simulated Annealing?
library(GenSA)
multiStarts1 <- function(zielFunktion, n, lower, upper){
  
  startingpoint <- runif(n, min = lower, max = upper)
  result.theta <- startingpoint
  result.value <- zielFunktion(startingpoint)
  s.num <- 0
  
  repeat{
    s.num <- s.num + 1
    startingpoint <- runif(n, min = lower, max = upper)
    A <- GenSA(startingpoint, zielFunktion, 
               lower = rep(lower, n), upper = rep(upper, n))
    
    if( s.num == 5 ){
      break
    }
    
    if(A$value < result.value){
        result.value <- A$value
        result.par <- A$par
    }
  }
  return( list( result.theta = result.theta, result.value = result.value) )
}

# Nelder-Mead with multiple Starts
multiStarts2 <- function(zielFunktion, n, times, lower, upper){
  
  startingpoint <- runif(n, min = lower, max = upper)
  result.theta <- startingpoint
  result.value <- zielFunktion(startingpoint)
  s.num <- 0
  
  for (i in 1:times){
    s.num <- s.num + 1
    startingpoint <- runif(n, min = lower, max = upper)
    A <- optim(runif(5, min = lower, max = upper), f3, method = "Nelder-Mead")

    if(A$value < result.value && A$convergence == 0){
      result.theta <- A$par
      result.value <- A$value
    }
  }
  return( list( result.theta = result.theta, 
                result.value = result.value,
                repeated = s.num) )
}
multiStarts2(f3, 5, 1000, -10, 10)



# f4: {−1000, −999, ..., 1000}^10 → R, d.h. die Funktion erwartet ganze Zahlen als Eingabe.
evolutionaryAlgorithm(f4, 200, 10000, rep(-1000, 10), rep(1000, 10))
