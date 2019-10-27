# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.4                   *
# *          Uebung am Freitag                   *
# ************************************************
rm(list=ls())

##### Aufgabe 1)
##### Examples
# (i) a+b != c                          
a <- 0.1
b <- 0.00000000000000005
c <- 0.10000000000000005
a + b == c                                                   # returns FALSE
          
# (ii) a^(b/b) != a
# (It was unable to find a suitable example)


# (iii) (sqrt(x))^2 != x                
a <- sqrt(2)^2                                               
b <- 2                                                       
a == b                                                       # returns FALSE

# (iv)  a + b - b != a                  
a <- 0.1461789789
b <- 0.3978789789
a + b - b                                                    # returns 0.146179
a                                                            # returns 0.146179
a + b - b == a                                               # returns FALSE

# (v) exp(log(x)) != x
a <- 3.0007
exp(log(a)) == a

# (vi) nCk != n!/(k!*(n-k)!)            
n <- 30
k <- 5
choose(n, k)                                                # returns 142506
factorial(n)/(factorial(k)*factorial(n-k))                  # returns 142506
choose(n, k) == factorial(n)/(factorial(k)*factorial(n-k))  # returns FALSE
                                           
# (vii) my example1 : a^3 != c
a <- 2.1
a^3                                                         # returns 9.261
a^3 == 9.261                                                # returns FALSE

# (vii) my example2 : log10(a) + log10(b) != log10(a*b)
a <- 0.3
b <- 3
log10(a) + log10(b) == log10(a*b)



##### Aufgabe 2 : Please see the enclosed PDF File.
g <- function(a0, a1, a2, x){
  return(a2*x^2 + a1*x + a0)
}

## For example, this kind of settings result in big relative errors.
x <- 300
a1 <- 300
a2 <- 300
a0 <- (-1)*(a2*x^2 + a1*x) + 0.0025

## Testen
g(a0, a1, a2, x)
g(a0, a1, a2, x*(0.99))                            # 1% decrease of x
g(a0*(1.01), a1, a2, x)                            # 1% increase of a0
g(a0, a1*(0.99), a2, x)                            # 1% decrease of a1
g(a0, a1, a2*(1.01), x)                            # 1% increase of a2


##### Aufgabe 3
### Aufgabe 3-a)
# twoPass      - returns a sum of squared difference between the input elements
#                and the sample mean(deviations)
# Inputs : 
#  x           - a numeric vector, [1, 2, ... n]
#
# Outputs:
#              - a numeric scalar. 
#              - dividing what's returned with n-1, for instance, is
#              - generally regarded as the sample variance.

twoPass <- function(x){
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  # sample mean computing
  x.bar <- mean(x)
  return(sum((x - x.bar)^2))
}

### Aufgabe 3-b)
# textbook      - returns the difference between the sum of squares of input
#                 elements and the mean of square of sum of input elements.
# Inputs : 
#  x           - a numeric vector, [1, 2, ... n]
#
# Outputs:
#              - a numeric scalar.
#              - dividing what's returned with n-1, for instance, is
#              - generally regarded as the sample variance.

textbook <- function(x){
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  return(sum(x^2) - 1/length(x)*(sum(as.numeric(x)))^2)
}

### Aufgabe 3-c) : Please see the enclosed PDF-File.
### Aufgabe 3-d)
wahreVarianz <- function(x){
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  # analytically derived formula from Aufgabe 3-c) when x = {1, 2, 3,.. n}:
  n <- length(x)
  s <- (n*(n+1)/(n-1)) * (((2*n+1)/6) - (n+1)/4)
  return(s)
}

## Error matrix
## we have 3 different variance derivation functions. Errors of ten random
## permutations of each input vector will be recorded. The matrix should be
## (10 X 27) matrix of each function. 
textbook.err <- matrix(0, nrow=10, ncol=26)
twoPass.err <- matrix(0, nrow=10, ncol=26)
var.err <- matrix(0, nrow=10, ncol=26)


## Varying "i"s and "k"s, the error of the function is recorded.
## The error is the absolute difference between the true sample variance,
## which is based on the formula from Aufgabe 3-c), and the three functions:
## textbook, twoPass and var.

## Computation takes more than a minute. Disabled with #.
#for (i in 1:26){
#  print("The computation takes about 3 minutes or less.")
#  for (k in 1:10){       # with 10 Permutations
#    m <- sample(1:(2^i))
#    n.minus.eins <- (length(m)-1)
#    whV <- wahreVarianz(m)
#    textbook.err[k, i] <- abs(whV - textbook(m)/(n.minus.eins))
#    twoPass.err[k, i] <- abs(whV - twoPass(m)/(n.minus.eins))
#    var.err[k, i]<- abs(whV - var(m))
#    print(i)
#  }
#}

## Due to 10 different permutations, the error differs slightly,
## especially when "n" is big.
textbook.err
twoPass.err
var.err

## To see the general tendency of errors, in my opinion, it could be helpful 
## to see the mean value of each column of matrices.
textbook.err.mean.vec <- rep(0, 26)
twoPass.err.mean.vec <- rep(0, 26)
var.err.mean.vec <- rep(0, 26)

for (k in 1:26){
  textbook.err.mean.vec[k]<- mean(textbook.err[,k])
  twoPass.err.mean.vec[k] <- mean(twoPass.err[,k])
  var.err.mean.vec[k] <- mean(var.err[,k])
}

## here are the vectors to show to mean errors when n ∈ {2^1, 2^2, ..,2^26}"
textbook.err.mean.vec
twoPass.err.mean.vec
var.err.mean.vec

## plotting
plot(textbook.err.mean.vec, 
     main = "absolute difference between true sample variance of vector 
     [1,..,2^n] and variance computed by 3 different algorithms in R",
     type = "b",
     xlab = "n",
     bg = "red",
     ylab = "Error",
     pch = 19,
     lwd = 2,
     col = "red",
     lty=3)
lines(twoPass.err.mean.vec, type = "b", pch = 18, lwd = 2, col="blue", lty=2)
lines(var.err.mean.vec, type = "b", pch = 17, lwd = 2, col = "green", lty=1)
legend("topleft",
       legend = c("textbook","twoPass", "var"),
       col = c("red","blue", "green"),
       lty=3:1, 
       cex=1.3
)

## Additional Comments:
# Q) Bis wann liefern die Algorithmen exakte Ergebnisse? 
# : Almost until n = 2^22 the algorithm returns the exact results.

# Q) Welchen Algorithmus implementiert R vermutlich? 
# : twoPass and var are very likely to be the same as shown in the plot. 
# : It is reasonable to say that twoPass algorithm is implemented.

# Q) Welchen Einfluss hat die Reihenfolge des Vektors?
# : The sequence of the vector plays a role to impact the error, when n is big.
# : Error computing according to 10 different permutations results in 
# : different errors, especially remarkable when n is bigger than 2^24.