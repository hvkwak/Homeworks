# ************************************************
# *          CStat 18-19  Quellcode              *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.12                  *
# *          Uebung am Freitag                   *
# ************************************************
rm(list=ls())
library(combinat) ## combinat::permn() : permutation generator, Aufgabe 1)
library(truncnorm) ## zum Testen bei Aufgabe 3)

##### Aufgabe 1)

#### Aufgabe 1-a)
# gapTest       - fuehrt einen GapTest durch.
#
# Eingabe:
#   M           - Positive Integer. Die Anzahl der erzeugten Zufallszahlen aus
#                 Gleichverteilung
#   z           - Positive Integer, im Skript ist es 5.
#   alpha       - eine reelle Zahl auf dem Interval[0, 1]
#   beta        - eine reelle Zahl auf dem Interval[0, 1], groesser alpha.
#
# Ausgabe:
# chisq.test(Yr, p = Pr)$p.value
#               - ein P-Wert aus dem durchgefuehrten Test

gapTest <- function(M, z, alpha, beta){
  stopifnot(
    M > 0,
    is.integer(M),
    z > 0,
    is.integer(z),
    (0 < alpha && alpha < beta && beta < 1)
  )
  
  ## Zufallszahlen erzeugen
  u <- sample(2^31 , M) / 2^31
  true.false.vec <- (alpha < u) & (u < beta)
  
  Yr <- rep(0, z+1)
  i <- 1
  count <- 0
  
  ## Nach dem Regel kategorieren:
  while(i <= length(true.false.vec) ){
    if(true.false.vec[i] == FALSE){
      count <- count + 1
      i <- i + 1
    }else{ ## if TRUE
      if(count == 0){
        Yr[1] <- Yr[1] + 1
      }else if(count >= z+1){ 
        Yr[z+1] <- Yr[z+1] + 1
      }else{ 
        Yr[count+1] <- Yr[count+1] + 1
      }
      count <- 0
      i <- i + 1
    }
  }
  
  ## Parameter fuer Test-Statistik berechnen:
  q <- beta - alpha
  r <- 0:(z-1)
  Pr <- c(q*(1-q)^r, (1-q)^z)
  
  return(chisq.test(Yr, p = Pr)$p.value)
}


#### Aufgabe 1-b)
# permutationTest  - fuehrt einen Permutation Test durch.
#
# Eingabe:
#   M           - Positive Integer. Die Anzahl der erzeugten Zufallszahlen aus
#                 Gleichverteilung
#   E           - Positive Integer, die Anzahl der Elemente in einer Gruppe,
#                 die zu permutieren sind.              

# Ausgabe:
# chisq.test(Ye, p = Pe)$p.value
#               - ein P-Wert aus dem durchgefuehrten Test

#### Permutation Test
permutationTest <- function(M, E){
  
  ##M <- 100
  ##E <- 3
  
  u <- sample(2^31, M) / 2^31
  Gruppen <- list()
  
  ## Parameter
  N <- floor(M/E)
  K <- factorial(E)
  
  for (i in 1:N){
    Gruppen[[i]] <- u[ (E*i-(E-1)) : (E*i) ]
  }
  
  ## unlisten(mit den doppelten Schleifen jedoch nuetzte es wenig...)
  Gruppen <- matrix(unlist(Gruppen), ncol = E, byrow=TRUE)
  
  ## permutations bestimmen
  perm.list <- permn(1:E)
  
  
  
  Ye <- rep(0, K)
  
  Pe <- rep(1/factorial(E), length(Ye))
  

  ## Elemente Kategorieren, je nach Permutation:
  # Diese doppelte Schleifen waeren sehr uneffizient, jedoch andere Moeglichkeit 
  # leider nicht ausdenkbar. Sorry!

  for(i in 1:nrow(Gruppen) ){
    current.vec <- Gruppen[i,]
    Anordnung <- rank(current.vec)
    found <- FALSE
    s <- 1
    
    # eine Kategorie erhoeht um 1, je nach Treffer.
    while(s <= length(perm.list) & found == FALSE){
      if(all(perm.list[[s]] == Anordnung) ){
        Ye[s] <- Ye[s] + 1
        found <- TRUE
      }
      s <- s + 1
    }
  }
  return(chisq.test(Ye, p = Pe)$p.value)
}

## Bezueglich Lemma 4.1 der Folie S.638:
## "Sei die Verteilungsfunktion von X stetig und streng monoton steigend. 
## Dann ist F(X) gleichverteilt auf dem Intervall [0, 1]."

## Beweis:
## Für die Gleichverteilung auf dem Intervall [0, 1] gilt: P(Y ≤ y) = y.
## Die Test-Statistik in diesem Test ist Chi-Quadrat verteilt und die Definition
## des p-Wert ist p = P(V ≤ v) = F(V). 
## Dann ist P(F(V) ≤ F(v)) = P(V ≤ v) = F(v), weil F(v) stetig und streng 
## monoton aufsteigend ist. Also ist die Zufallsvariable Y = F(V) = p auf dem
## Interval [0 ,1] gleichverteilt.

## Histogram:
## Grafisch mit Hilfe von Histogram koennte es dargestellt werden:
## (allerdings wird es deaktiviert, da es mehr als eine Minute dauert.)
#hist(replicate(1000, gapTest(10000L, 5L, 1/4, 3/4)))
#hist(replicate(1000, permutationTest(10000L, 3L)))
#hist(replicate(1000, permutationTest(10000L, 4L)))
#hist(replicate(1000, permutationTest(10000L, 5L)))

## Es ist vermutlich, dass die p-values gleichverteilt sind, wenn die Hypothese
## H0 erfuellt ist.


#### Aufgabe 2)

#### Basis-Generator: Bernoulliverteilt Zufallszahlen Generator
Ber.ZZ <- function(M, q){
  
  ## Zufahlszahlen erzeugen aus Gleichverteilung:
  ZZ <- sample(2^31 , M) / 2^31
  for(i in 1:length(ZZ)){
    ## Wenn das Element groesser q, wird das Element 1.
    if(ZZ[i] > q ){
      ZZ[i] <- 1
    }else{ ## sonst 0.
      ZZ[i] <- 0
    }
  }
  return(ZZ)
}

##### Aufgabe 2)
#### Aufgabe 2-a) Zufallszahlen Generator-Geometrisch

# Geo.ZZ        - erzeugt Zufallszahlen der Geometirschen Verteilung, die
#                 Zahlen bis zum ersten Erfolg des Experiments der Bernoulli
#                 Verteilung
#
# Eingabe:
#   M           - Positive Integer. Die Anzahl der zu erzeugenden Zufallszahlen
#   q           - Wahrscheinlichkeit des Erfolgs des Experiments 
#                 der Bernoulli Verteilung.
# Ausgabe:
# memory.vec[1:M]
#               - die M gewuenschten Zufallszahlen 

Geo.ZZ <- function(M, q){
  stopifnot(
    M > 0,
    is.integer(M),
    q > 0 && q < 1,
    is.double(q)
  )
  # 2.5 ist hier ein "safe-margin" Parameter.
  ZZ <- Ber.ZZ(floor(M*2.5), q)
  i <- 1
  count <- 0
  memory.vec <- NULL
  
  while(i <= length(ZZ) ){
    if(ZZ[i] == 0){
      count <- count + 1
      i <- i + 1
    }else{ 
      memory.vec[length(memory.vec)+1] <- count
      count <- 0
      i <- i + 1
    }
  }
  return(memory.vec[1:M])
}

## zum Testen, Histogram und Dichtefunction grafisch darstellen:
Geo.ZZ.graph <- function(){
  hist(Geo.ZZ(10000L, 1/2), freq = FALSE, right=FALSE)
  
  ## Grafischer Testen mit Dichtefunction
  x <- seq(0, 15)
  y <- dgeom(x, 1/2)
  lines(x, y,
        lwd = 2,
        col = "red")
}
Geo.ZZ.graph()

#### Aufgabe 2-b) Zufallszahlen Generator-Exponential
# Exp.ZZ        - erzeugt Zufallszahlen der Exponentialen Verteilung
#
# Eingabe:
#   M           - Positive Integer. Die Anzahl der zu erzeugenden Zufallszahlen
#   lambda      - ein numrischer Skalar, groesser als 0.

# Ausgabe:
# memory.vec[1:M]
#               - die M gewuenschten Zufallszahlen 

Exp.ZZ <- function(M, lambda){
  stopifnot(
    M > 0,
    is.integer(M)
  )
  ## lambda muss groesser als 0 sein.
  return(-log(1-sample(2^31 , M)/2^31) / lambda)
}

## zum Testen, Histogram und Dichtefunction grafisch darstellen:
Exp.ZZ.graph <- function(){ 
  lambda <- 1
  hist(Exp.ZZ(10000L, lambda), freq=FALSE, right = FALSE)
  
  ## Grafischer Testen mit Dichtefunction
  x <- seq(0, 30, 0.0001)
  y <- dexp(x, lambda)
  lines(x, y,
        lwd = 2,
        col = "red")  
}
Exp.ZZ.graph()


#### Aufgabe 2-c) Zufallszahlen Generator-Normal

# Norm.ZZ        - erzeugt Zufallszahlen der Normalen Verteilung
#
# Eingabe:
#   M           - Positive Integer. Die Anzahl der zu erzeugenden Zufallszahlen
#   k           - ein numrischer Skalar, parameter, 

# Ausgabe:
# memory.vec[1:M]
#               - die M gewuenschten Zufallszahlen 

Norm.ZZ <- function(M, k){
  u <- sample(2^31, M*(k+1))/2^31
  memory.vec <- NULL
  i <- 1
  for(i in 1:floor( (M*(k+1))/k) ){
    memory.vec[i]<- sum( u[(k*i-(k-1)) : (k*i)] ) - (k/2)
  }
  return(memory.vec[1:M])
}

## zum Testen, Histogram und Dichtefunction grafisch darstellen:
Norm.ZZ.graph <- function(k){
  hist(Norm.ZZ(10000L, k), freq=FALSE, right=FALSE,
       main = paste("Histogram of Norm.ZZ(10000,", "k=" , k, ")"))
  
  ## Grafischer Testen mit Dichtefunction
  x <- seq(-5, 5, 0.0001)
  y <- dnorm(x)
  lines(x, y,
        lwd = 2,
        col = "red")  
}
Norm.ZZ.graph(12) ## k = 12 ist Parameter aus Folie s.641.

#### Aufgabe 2-d) 
## Durch diesen Histogram ist es vermutlich, dass mein Generator aus 2-c) 
## ab dem Wert k = 11 ordentlich normalverteilte Zufallszahlen erzeugt.
Norm.ZZ.graph.k <- function(){
  for (k in 1:12){
    Sys.sleep(1) ## Eine Sekunde Pause
    Norm.ZZ.graph(k) 
  }
}
Norm.ZZ.graph.k()


##### Aufgabe 3)

# Verwerfung.ZZ.trunc.norm - erzeugt Zufallszahlen der trunkierten 
#                            Normalen Verteilung durch Verwerfungsmethode.
#
# Eingabe:
#   N           - Positive Integer. Die Anzahl der zu erzeugenden Zufallszahlen
#   ab          - ein numrischer vector, der den Interval [a, b] bestimmt.
#                 length ist 2. 
#
# Ausgabe:
# memory.vec[1:M]
#               - die M gewuenschten Zufallszahlen 

Verwerfung.ZZ.trunc.norm <- function(N, ab){
  stopifnot(
    length(ab) == 2,
    abs(ab[1]) == abs(ab[2]),
    ab[2] > ab[1], 
    N > 0,
    is.integer(N)
  )
  
  ## Interval Bestimmen
  a <- ab[1]
  b <- ab[2]
  
  memory.vec <- NULL
  k <- 100 ## beliebig eingeben
  i <- 0
  
  while(length(memory.vec) < N){
    
    x0 <- a + (b-a)*(sample(2^31, 1)/2^31) ## aus q
    u <- sample(2^31 , 1) / 2^31
    
    ## Vergleich durch dnorm():
    if( u*k <= (dnorm(x0) / dunif(x0 , a, b)) ){
      memory.vec[length(memory.vec)+1] <- x0  
    }else{
      next
    }  
  }
  return(memory.vec)
}

## zum Testen, Histogram und Dichtefunction grafisch darstellen:
Verwerfung.ZZ.trunc.norm.graph <- function(ab){
  hist(Verwerfung.ZZ.trunc.norm(10000L, ab), freq = FALSE)
  
  ## Grafischer Testen mit Dichtefunction
  x <- seq(ab[1], ab[2], 0.0001)
  y <- dtruncnorm(x)
  lines(x, y,
        lwd = 2,
        col = "red")
}
Verwerfung.ZZ.trunc.norm.graph(c(-10, 10))
