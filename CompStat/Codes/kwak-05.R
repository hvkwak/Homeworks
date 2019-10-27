# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.5                   *
# *          Uebung am Freitag                   *
# ************************************************

rm(list=ls())
library(testthat)

##### Aufgabe 1

# youngsCramerVar - returns the sample variance of elements of an input vector.
#                 - Please note that this function computes the variance in an 
#                   updating manner. Index j in this function calls the
#                   elements of the input vector one by one. Those elements
#                   are step by step combined to compute the new variance(S),
#                   until index parameter j reaches to the end of the input
#                   vector.
#
# Inputs : 
#  x           - a numeric vector.
#
# Outputs:
#              - a numeric scalar. 

youngsCramerVar <- function(x){
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  for (j in 1:length(x)){
    ## Initial value setting. The first T.value is the first element of the
    ## input vector, S.value starts with 0.
    if(j == 1){
      T.value <- x[1]
      S.value <- 0
    }
    ## T.value is updated by adding the existing T.value and the next element
    ## of the input vector.
    ## The next S.value is the sum of existing S.value and the term combined
    ## with j, jth value of the input vector and T.value.
    else{
      T.value <- T.value + x[j]
      S.value <- S.value + 
        1/(j*(j-1)) * (j*x[j] - T.value)^2
    }
  }
  ## S.value divided by n-1 (length(x)-1) finally gives you the 
  ## sample variance of the input vector.
  return(S.value/(length(x)-1))
}

## Test with var()
testyoungsCramerVar <- function() {
  test_that("Test with var()", {
    expect_equal(youngsCramerVar(sample(100)), var(sample(100)))
    expect_equal(youngsCramerVar(sample(1000)), var(sample(1000)))
    expect_equal(youngsCramerVar(sample(10000)), var(sample(10000)))
    expect_equal(youngsCramerVar(seq(100)-50), var(seq(100)-50))
    expect_equal(youngsCramerVar(seq(1000)-500), var(seq(1000)-500))
    test.eingabe.1 <- rnorm(100, 5, 10)
    expect_equal(youngsCramerVar(test.eingabe.1), var(test.eingabe.1))
    ## Results show no big difference between youngsCramerVar() and var().
    
    ## If the elements in the input vector are too big, the round-off error
    ## causes a problem, for example, when the elements of input vector
    ## bigger than 1e+13.
    expect_equal(youngsCramerVar(1e+12+sample(1000)), var(1e+12+sample(1000)))
    expect_equal(youngsCramerVar(1e+13+sample(1000)) == var(1e+13+sample(1000)), 
                FALSE)
  })
}
testyoungsCramerVar()




##### Aufgabe 2

#### Aufgabe 2-a)
# textbook    - returns the sample variance of elements of an input vector.
#               Please note that the elements of the input vector are shifted
#               by the mean value of selected elements with its size of m, and
#               then the variance of of those shifted elements is computed.
#               The Textbook algorithm is implemented. 
#               (S = (sum(x^2) - ((sum(x))^2)/length(x))/(length(x)-1),
#               where S is sample variance.)
#
# twoPass     - same as the textbook function above, the shifted elements of 
#               the input vector are used to compute sample variance. 
#               Please note that the Two-Pass algorithm is implemented.
#               (S = (sum((x-mean(x))^2))/(length(x)-1),
#               where S is sample variance.)
#                
# Inputs : 
#  x           - a numeric vector.
#  m           - a numeric scalar. With this parameter, m elements of the input
#                vector are selected to compute the mean value, in order to 
#                shift the elements of the input vector. This, of course,
#                should be a non negative integer.
#
# Outputs:
#              - a numeric scalar. 

textbook <- function(x, m){
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  
  ## if m == 0, there are no changes in the input vector. Textbook algorithm
  ## is implemented for further computations.
  if (m==0){
    return(
    (sum(x^2) - 1/length(x)*(sum(x))^2)/(length(x)-1)
    )
  }
  ## if m > 0, m elements of the input vector are selected and mean value
  ## of them is subtracted from the elements of input to shift the input 
  ## elements.
  else{
    ## shifted elements of the input vector
    x <- (x - mean(sample(x, m)))
    return(
    (sum(x^2) - 1/length(x)*(sum(x))^2)/(length(x)-1)
    )
  }
}

twoPass <- function(x, m){
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  ## if m == 0, there are no changes in the input vector.
  if (m==0){
    return(sum((x - mean(x))^2))
  }
  ## if m > 0, yes, the elements input vector are shifted.
  else{
    x <- (x - mean(sample(x, m)))
    return(sum((x - mean(x))^2) / (length(x)-1))
  }
}

#### Aufgabe 2-b)
# wahreVarianz  - Analytically derived function which computes the sample 
#                 variance.
# Inputs : 
#  x          - a numeric vector, with its form [1, 2, ... n].
#               Please note that it is also applicable when the vector is
#               [1e+16 + 1, ... ,1e+16 + 1000], because the sample variance of
#               this vector is analytically equivalent to [1, 2, 3, ... , 1000].
# Outputs:
#              - a numeric scalar. 

wahreVarianz <- function(x){
  n <- length(x)
  return(n*(n+1)/12)
}

# absoluteAbweichung  - Absolute distance computation for m = 0, 1, 2, ... 10.
# Inputs : 
#  x     - a numeric vector, [1e+16 + 1, ... ,1e+16 + 1000]
#
# Outputs:
#  [[1]] - a numeric vector, computed sample variance of textbook(x, m).
#  [[2]] - a numeric vector, computed absolute deviance between textbook(x, m) 
#          and true (sample) variance.
            
#  [[3]] - a numeric vector, computed sample variance of twoPass(x, m).
#  [[4]] - a numeric vector, computed absolute deviance between twoPass(x, m) 
#          and true (sample) variance.
#                
#  plot  - visualization of the results.
#                

absoluteAbweichung <- function(){
  x <- 1e+16 + seq(1000)
  Varianz <- wahreVarianz(seq(1000))
  
  ## two matrices for computation results 
  result.mat.textbook <- matrix(0, nrow = 11, ncol = 2)
  result.mat.twoPass <- matrix(0, nrow = 11, ncol = 2)
  
  for (m in 0:10){
    result.mat.textbook[m+1,1] <- textbook(x, m)
    ## absolute deviation from the true (sample) variance are computed by
    ## absolute value of subtraction of result and the true (sample)variance.
    result.mat.textbook[m+1,2] <- abs(result.mat.textbook[m+1,1] - Varianz)
    result.mat.twoPass[m+1,1] <- twoPass(x, m)
    result.mat.twoPass[m+1,2] <- abs(result.mat.twoPass[m+1,1] - Varianz)
  }
  ## plotting
  plot(0:10, result.mat.textbook[,2], 
       main = "Absolute deviation from the true (sample)variance, when 
       input vector is [1e+16 + 1, ... , 1e+16 + 1000]",
       type = "b",
       xlab = "m",
       bg = "red",
       ylab = "Error",
       pch = 19,
       lwd = 2,
       col = "red",
       lty=3)
  lines(0:10, result.mat.twoPass[,2], type = "b", pch = 18, 
        lwd = 2, col="blue", lty=2)
  legend("topright",
         legend = c("textbook","twoPass"),
         col = c("red","blue"),
         lty=3:1, 
         cex=1.3)
  
  ## Outputs
  return(list(
    result.mat.textbook[,1], result.mat.textbook[,2],
    result.mat.twoPass[,1], result.mat.twoPass[,2] 
  ))  
}
absoluteAbweichung()