# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.14                  *
# *          (Weihnachtszettel)                  *
# *          Uebung am Freitag                   *
# ************************************************
rm(list=ls())
library("parallel")

#### Aufgabe 1-a)

# digitSum      - bestimmt Quersumme.
#
# Eingabe:
#   x           - Eine Integer
#   b           - base. hier ist es 10.
#
# Ausgabe:
#               - die Quersumme

digitSum <- function(x, b = 10){
  n <- 0:floor(log10(x))
  return(sum((x%%b^(n+1) - x%%b^(n))/b^n))
}

# aufgabe.1.a.  - solves Aufgabe 1-a)
aufgabe.1.a <- function(){
  
  ## Mit Parallelisierung, 2 Rechner:
  cl <- makeCluster(rep("localhost", 2), type = "SOCK")
  A <- system.time(L1 <- parSapply(cl, 1:10^5, digitSum))
  stopCluster(cl)
  
  ## ohne Parallelisierung:
  B <- system.time(L2 <- sapply(1:10^5, digitSum))
  return(list('Mit Parallelisierung, 2 Rechner:' = A,
              'ohne Parallelisierung:' = B,
              'if L1 == L2 :' = all.equal(L1, L2),
              first.20 = L1[1:20] # print out first 20 digit sums
              ))
}
aufgabe.1.a()

### Ergebnisse

# $`Mit Parallelisierung, 2 Rechner:`
# user  system elapsed 
# 0.085   0.012   0.379 

# $`ohne Parallelisierung:`
# user  system elapsed 
# 0.423   0.000   0.423 

# $`if L1 == L2 :`
# [1] TRUE

# $first.20
# [1]  1  2  3  4  5  6  7  8  9  1  2  3  4  5  6  7  8  9 10  2

### Comments: 
# Mit Parallelisierung ist es schneller als ohne Parallelisierung.


#### Aufgabe 1-b und 1-c)

# sample.x     - a sample of a group X
# sample.y     - a sample of a group Y
#
# Eingabe:
#   k           - Dummy Variable for (parallel) sample generation.
#
# Ausgabe:
#               - a sample of size 10^6.

sample.x <- function(k){
  mu.x <- 6.0025
  sd.x <- 13.77
  size <- 10^6
  return(rnorm(size, mean = mu.x, sd = sd.x))

}
sample.y <- function(k){
  mu.y <- 6
  sd.y <- 19.76
  size <- 10^6
  return(rnorm(size, mean = mu.y, sd = sd.y))
}

# t.testen      - t-test that compares two mean values from two samples.
#
# Eingabe:
#   X           - a numeric vector of dataset.
#
# Ausgabe:
#               - p-value of the test, which decides whether rejecting H0.

t.testen <- function(X){
  test.result <- t.test(x=X[1:(length(X)/2)], y=X[(length(X)/2 + 1):length(X)], 
                        alternative = "two.sided", paired = TRUE, 
                        var.equal = FALSE)
  return(test.result$p.value < 0.05)
}

# aufgabe.1.b.c  - solves both Aufgaben 1-b and 1-c)
#
# Eingabe:
#   aufgabe      - Aufgabe indicator ("Aufgabe 1-b" or "Aufgabe 1-c")
#
# Ausgabe:
# testen.Typ     - Aufgabe indicator
# time           - measured elapsed time
# H0.reject.rate - shows how often H0 is rejected

aufgabe.1.b.c <- function(aufgabe){
  
  s.num <- 200
  chunks <- 4 ## Unfortunately this problem should be devided into 4 chunks
              ## due to memory allocation problems. If it is solved at once
              ## on my laptop, R terminates.
  result.mat <- matrix(0, nrow = s.num/chunks , ncol = chunks)
  
  cl <- makeCluster(rep("localhost", 2), type = "SOCK")
  
  time <- system.time( ## measures time
    for(k in 1:chunks){
      ## samples
      X <- t( parSapply(cl, 1:(s.num/chunks), sample.x) )
      Y <- t( parSapply(cl, 1:(s.num/chunks), sample.y) )
      
      if(aufgabe == "Aufgabe 1-b"){ ## ohne Parallelisierung
        result.mat[,k] <- apply(cbind(X, Y), 1, t.testen)
        
      }else{ ## ("Aufgabe 1-c") "mit Pararellisierung testen, 2 Rechner"
        result.mat[,k] <- parApply(cl, cbind(X, Y), 1, t.testen)
      }
    }
  )
  stopCluster(cl)
  
  return(list(testen.Typ = aufgabe, 
              time = time, 
              H0.reject.rate = mean(result.mat)))
}
## The two codes below take more than a minute:
# aufgabe.1.b.c("Aufgabe 1-b")
# aufgabe.1.b.c("Aufgabe 1-c")

### Ergebnisse
# $testen.Typ
# [1] "Aufgabe 1-b"

# $time
# user  system elapsed 
# 28.853  10.404  58.443 

# $H0.reject.rate
# [1] 0.075

# $testen.Typ
# [1] "Aufgabe 1-c"

# $time
# user  system elapsed 
# 25.648   9.868  62.563 

# $H0.reject.rate
# [1] 0.06

### Comments: 
# Not much difference of rejection rate of the two methods. It is interesting
# to see that the settings of Aufgabe 1-b is quicker than the settings of
# Aufgabe 1-c. 


#### Aufgabe 1-d) 

# ggT            - bestimmt groesste gemeinsame Teiler
#
# Eingabe:
#   i            - eine Integer
#   j            - eine Integer 
# Ausgabe:
#                - groesste gemeinsame Teiler der Eingaben.

ggT <- function(i, j){
  
  i <- abs(i)
  j <- abs(j)
  
  if(j %% i == 0){return(i)}
  else if(i%%j == 0){return(j)}
  else{
    if(i < j){
      new.i <- (j%%i)
      new.j <- i
      ggT(new.i, new.j)
    }else{ ## i >= j
      new.j <- (i%%j)
      new.i <- j
      ggT(new.i, new.j)
    }
  }
}

# aufgabe.1.d    - solves Aufgabe 1-d
#
# Eingabe:
#   if.parallel  - parallel indicator
#
# Ausgabe:
# testen.Typ     - if.parallel
# time           - measured elapsed time

aufgabe.1.d <- function(if.parallel, n.row=1000, n.col=1000){
  
  # Index von X generieren: 1, 1, 1, 1, .... 2, 2, 2, 2, .... 3, 3, 3, 3, ...
  x <- as.vector(matrix(1:n.row, nrow=n.row, ncol=n.col, byrow=TRUE))
  # Index von Y generieren: 1, 2, 3, 4, .... 1, 2, 3, 4, .... 1, 2, 3, 4, ...
  y <- rep(1:n.row, n.row)
  
  if(if.parallel == "ohne Parallelisierung"){
    time <- system.time(
      M <- matrix(mapply(ggT, x, y), nrow = n.row, ncol = n.col)
    )
    return(list(testen.Typ = "ohne Parallelisierung testen", time = time,
                matrix.look = M[1:5, 1:5]))
  }else{ # "mit Parallelisierung"
    time <- system.time(
      M <- matrix(mcmapply(ggT, x, y, mc.cores=2), nrow = n.row, ncol = n.col)
      ## mcmapply(): paralleliserte Variante der mapply()
    )
    return(list(testen.Typ = "mit Parallelisierung testen, 2 Rechner", 
                time = time, matrix.look = M[1:5, 1:5]))
  }
}
aufgabe.1.d("ohne Parallelisierung")
aufgabe.1.d("mit Parallelisierung")

### Ergebnisse:
# $testen.Typ
# [1] "ohne Parallelisierung testen"

# $time
# user  system elapsed 
# 8.873   0.000   8.871 

# $matrix.look
#       [,1] [,2] [,3] [,4] [,5]
# [1,]    1    1    1    1    1
# [2,]    1    2    1    2    1
# [3,]    1    1    3    1    1
# [4,]    1    2    1    4    1
# [5,]    1    1    1    1    5

# $testen.Typ
# [1] "mit Parallelisierung testen, 2 Rechner"

# $time
# user  system elapsed 
# 10.210   0.490  10.799

# $matrix.look
#       [,1] [,2] [,3] [,4] [,5]
# [1,]    1    1    1    1    1
# [2,]    1    2    1    2    1
# [3,]    1    1    3    1    1
# [4,]    1    2    1    4    1
# [5,]    1    1    1    1    5

### Comments:
# Ohne Parallelisierung wird die gewuenschte Matrix schneller erzeugt.