#####################################
####          Appendix           ####
#####################################

# bitFlipping   - a function that flips the bits with probability.
#
# Input:
#   x           - a binary vector. Each element is flipped with probability of
#                 1/length(x)
# Output:
#   x           - a flipped binary vector. 

bitFlipping <- function(x){

  if.flip.indicator <- rbinom(n=length(x), 1, p=1/length(x))
  
  one.to.zero.index <- which(if.flip.indicator == 1 & x == 1)
  zero.to.one.index <- which(if.flip.indicator == 1 & x == 0)
  
  x[one.to.zero.index] <- 0
  x[zero.to.one.index] <- 1
  return(x)
}

# varSelectorEA - evolutionary Algorithm for variable selection
#
# Input:
#   f           - a function of an optimization problem
#   mu          - a numeric matrix, the size of parents in an evolutionary 
#                 Algorithm
#  lambda       - a numeric matrix, the children of children
#  lower(upper) - a numeric vector, lower(upper) bound of the solution(vector) 
#                 of the function f.
#  stopp        - an integer, the number of generation.
#
# Output:
# best.vector   - a solution vector that minimizes f, after iterating until
#                 stopp reaches the limit.
#
#   f.value     - the value of the function when applying best.vector.
# how.many.variables 
#               - shows how many variables are supposed to be used as it this 
#                 algorithm for variable selection.

varSelectorEA <- function(f, mu, lambda, lower, upper, stopp){
  
  n <- length(lower) ## the number of dimension of input vectors
  
  ## parents
  parents.mat <- matrix(sample(0:1, n*mu, replace = TRUE), ncol = n, nrow = mu)
  
  ## make sure that there's no row of zeros, because it is impossible to fit
  ## a linear model with no variables.
  ## (it is very unlikely but there's still a slight chance to happen)
  ## if there are rows of zeros, replace them until it doesn't have one.
  while( sum(rowSums(parents.mat) == 0) >= 1){
    zeros <- which(rowSums(parents.mat) == 0) ## gathers indexes.
    parents.mat[zeros,] <- sample(0:1, n*length(zeros), replace = TRUE)
  }
  
  s.num <- 0
  repeat{
    ## 1. Rekombination: (1-Punkt Crossover)
    child.mat <- matrix(1, ncol = n, nrow = lambda)
    
    for (i in 1:(lambda/2)){
      paar <- parents.mat[sample(1:mu, 2), ]
      point <- round(n/2)
      
      child.mat[2*i-1, ] <- c(paar[1,][1:point], paar[2,][(point+1):n])
      child.mat[2*i, ] <- c(paar[2,][1:point], paar[1,][(point+1):n])
    }

    ## 2. Bit-Flipping(Mutation)
    child.mat <- t(apply(child.mat, 1, bitFlipping))
    ## make sure that there's no row of zeros once again.
    while( sum(rowSums(child.mat) == 0) >= 1){
      zeros <- which(rowSums(child.mat) == 0)
      child.mat[zeros,] <- t(apply(child.mat[zeros,], 1, bitFlipping))
    }
    
    ## parents and children make the next generation
    parents.child.mat <- rbind(parents.mat, child.mat)
    memory.vec <- apply(parents.child.mat, 1, f)
    
    ## next parents
    index.vec <- which(rank(memory.vec, ties.method = "first") <= mu)
    new.parents.mat <- parents.child.mat[index.vec,]
    
    ## 3. Stoppkriterium:
    A <- apply(parents.mat, 1, f)
    B <- apply(new.parents.mat, 1, f)
    
    if(s.num == stopp){break}
    ## if not, then keep going!
    parents.mat <- new.parents.mat
    s.num <- s.num + 1
  }
  ## best.value index
  index <- which.min(B)
  
  ## return
  return( list( best.vector = parents.mat[index,], 
                f.value = f(parents.mat[index,]),
                how.many.variables = sum(parents.mat[index,])
              ))
}
