library(microbenchmark)
# micro : 10^(-6) : schneller.
# milli : 10^(-3)
## Erste Aufgabe (a): Erzeugen Sie eine 1000 x 1000 Matrix mit standardnormal-
## verteilten Eintraegen.

microbenchmark({
  X <- matrix(rnorm(1000*1000), nrow = 1000, ncol = 1000)  
}, times = 10L)

## Zweite Aufgabe (b): Bestimmen Sie die Zeilensummen von X
microbenchmark({
  res <- rowSums(X)
}, times = 10L)

sum(res > 100)
sum(res < -100)
## Naechste Aufgabe (c): Jedes Element aus res soll zwischen -100 und 100
## liegen, d.h. wir wollen Ausreisser eliminieren.
microbenchmark({
  res[res > 100] <- rep(100, length(res[res > 100]) )
  res[res < -100] <- rep(-100, length(res[res < -100]) )
}, times = 10L)

microbenchmark({
  if( sum(res > 100) >= 1 ){
    res[res > 100] <- rep(100, length(res[res > 100]) )
  }
  if( sum(res < -100) >=1 ){
    res[res < -100] <- rep(-100, length(res[res < -100]) )
  }
  res2 <- res
}, times = 10L)

sqrt(sum( (res2^2) ) )


## Letzte Aufgabe (d): Bestimmen sie die 2-Norm von res2
microbenchmark({
  res3 <- sqrt(sum( (res2^2) ) )
}, times = 10L)

microbenchmark({
  res3 <- 0
  for(i in 1:length(res2))
    res3 <- res3 + res2[i] * res2[i]
  res3 <- sqrt(res3)
  res3 <<- res3
})
## 775.5345 Microsekunden
