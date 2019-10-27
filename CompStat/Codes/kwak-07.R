# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang M.Sc.Datenwissenschaft  *
# *          Uebungsblatt Nr.7                   *
# *          Uebung am Freitag                   *
# ************************************************

rm(list=ls())
##### Aufgabe 1)

# givensOrthogonalization - returns generalized inverse of the input matrix
#
# Input:
#  X - Matrix
#
# Ausgabe:
#  Generalized inverse of the input matrix X

givensOrthogonalization <- function(X){ 
  
  stopifnot(
    ## check if the number of rows is bigger than the number of columns.
    nrow(X) > ncol(X), 
    is.matrix(X),
    is.numeric(X),
    all(is.finite(X))
  )
  
  ## realization of Pseudocode in R
  m <- nrow(X)
  n <- ncol(X)
  Q <- diag(1, m)
  
  for(j in 1:n){
    for(i in ((j+1):m)){
      if(X[j, j] == 0 && X[i, j] == 0){
        J <- diag(1, 2)
      }
      else{
        if (abs(X[i, j]) > abs(X[j, j])) {
          a <- 1 / sqrt( 1+(X[j, j]/X[i, j])^2 )
          b <- (X[j, j]/X[i, j])*a
        }
        else{
          b <- 1 / sqrt( 1+(X[i, j]/X[j, j])^2 )
          a <- (X[j, j]/X[i, j])*b
        }
        J <- matrix(c(b, a, (-1)*a, b), nrow=2, byrow=TRUE)
      }
      X[c(j, i),] <- J%*%X[c(j, i),]
      Q[c(j, i),] <- J%*%Q[c(j, i),]
    }
  }
  X <- X[-(n+1:m),]
  Q <- Q[-(n+1:m),]
  
  return(solve(X)%*%Q)
}

## Testen
## There were two problems at the phase of testing of this algorithm:
## 1. The Pseudocode works only when the number of rows is bigger than the
##    number of columns. Is debugging or any sort of improvements of this 
##    algorithm required?
##    
## 2. With bigger number of rows there were chances that the returned value,
##    namely generalized inverse of the input matrix X, is probably not 
##    the value that we looked for. There must be something wrong with
##    my implementation.

## For example, with an example matrix as stated below,
beispiel <- matrix(c(1, 2, 3, 4, -1, 3), nrow=3, byrow=TRUE)

## Totally different computed values, comparing to greville(X) from sim.R.
greville <- function(X){
  if (nrow(X) > ncol(X))
    return(t(Recall(t(X))))
  m <- nrow(X)                              # voller Rang ==> m = rang(X)
  X.plus <- X[1, ] / sum(X[1, ]^2)          # initialize X+
  for(j in 1 + seq_len(m - 1)){
    djt <- t(X[j, ]) %*% X.plus             # t(dj), t(cj), bj nach Definition
    cjt <- t(X[j, ]) - djt %*% X[1:(j-1), ]
    bj <- t(cjt) / sum(t(cjt)^2)            # = t(cj+)
    X.plus <- cbind(X.plus - bj %*% djt, bj)
  }
  return(as.matrix(X.plus))
}
greville(beispiel)
givensOrthogonalization(beispiel)



##### Aufgabe 2)
###################################################################
# Die gegebenen Funktionen zur Konstruktion von Zielke Matrizen,
# exakte inverse der Zielke Matrizen, Wichtungsmatrix, sowie
# zur Auswahl der linken Seiten:

zielkeMatrix = function(Z, m){
  
  # Param Checks: Z muss eine Matrix sein, notfall 1 x 1
  Z = as.matrix(Z)
  stopifnot(is.matrix(Z), is.numeric(Z),
            nrow(Z) == ncol(Z), m >= 3)
  
  # Hilfsmatrizen
  p = nrow(Z)
  Ip = diag(p)
  Einsen = matrix(1, nrow = m, ncol = m)
  
  # Ergebnismatrix mit Kronecker Produkt initialisieren
  # In jedem Block steht erstmal Z, und wir muessen jetzt schauen, was wir
  # noch veraendert muessen
  X = Einsen %x% Z
  
  # 1. Zeilenblock - wir muessen passende Einheitsmatrizen addieren
  blockmult = c(1:(m - 1), 0)
  X[1:p, ] =  X[1:p, ] + t(blockmult) %x% Ip
  
  # Iteration ueber die uebrigen Spalten, oben nach unten
  # muss immer auf einen Spaltenblock weniger Ip addiert werden
  for (i in 2:(m - 1)) {
    blockmult[m - i + 1] = blockmult[m - i + 1] - 1
    blockinds = ((i - 1) * p + 1):(i * p)
    X[blockinds, ] = X[blockinds, ] + (t(blockmult) %x% Ip)
  }
  
  # Letzter Zeilenblock
  blockmult = c(0:(m - 2), -1)
  blockinds = ((m - 1) * p + 1):(m * p)
  X[blockinds, ] =  X[blockinds, ] + (t(blockmult) %x% Ip)
  return(X)
}
invZielkeMatrix <- function(Z, m){
  # Param Checks: Z muss eine Matrix sein, notfall 1 x 1
  Z = as.matrix(Z)
  stopifnot(is.matrix(Z), is.numeric(Z),
            nrow(Z) == ncol(Z), m >= 3)
  
  # Hilfsmatrizen
  p = nrow(Z)
  n = m * p
  Ip = diag(p)
  
  # Ergebnis initialisieren
  invX = matrix(0, nrow =n, ncol = n)
  
  # 1. Spalte
  colmult.Z = c(-1, rep(0, m - 2), 1)
  colmult.I = c(-(m - 2), rep(0, m - 3), 1, (m - 2))
  invX[, 1:p] = invX[, 1:p] + colmult.Z %x% Z + colmult.I %x% Ip
  
  # Iteration durch die Spalten
  colmult.1 = c(1, rep(0, m - 2), -1)
  for (i in 2:(m - 1)) {
    colmult.2 = c(rep(0, m - 1 - i), 1, -1, rep(0, i - 1))
    colind = ((i  -1) * p + 1):(i * p)
    invX[, colind] = invX[, colind] + (colmult.1 + colmult.2) %x% Ip 
  }
  
  # Letzte Spalte
  colind = (n-p+1):n
  invX[1:p, colind] = Z
  invX[(n - p + 1):n, colind] = -Z - Ip
  
  return(invX)
}
wMatrix <- function(n) {
  stopifnot(as.integer(n) == n, n >= 4, n %% 2 == 0)
  
  rotate_vector <- function(x, by) {
    s <- length(x) - by + 1
    c(x[s:length(x)], x[1:(s - 1)])
  }
  
  l <- (n - 2) / 2
  m <- 2 * l + 2
  ms <- l / m
  
  ## Constants:
  a <- 1 / m
  b <- 1 - ms
  c <- ms
  ## Construct matrix:
  W <- matrix(0, n, n)
  W[, 1] <- c( b, -a,  a, c(-1,  1) * rep(a, n - 4),  c)
  W[, 2] <- c(-a,  b,  c, c( 1, -1) * rep(a, n - 4),  a)
  W[, 3] <- c( a,  c,  b, c(-1,  1) * rep(a, n - 4), -a)
  W[, n] <- c( c,  a, -a, c( 1, -1) * rep(a, n - 4),  b)
  if (n > 4)
    for (i in 4:(n-1))
      W[, i] <- rotate_vector(W[, i - 2], 2)
  W
}
leftHandSide <- function(X, Xinv) {
  norm <- function(x) sqrt(sum(x*x))
  
  y0 <- trunc(rnorm(ncol(Xinv), sd = 256))
  beta0 <- drop(Xinv %*% y0)
  
  y <- drop(X %*% beta0)
  norm_y <- norm(y)
  
  r0 <- y -y0
  norm_r0 <- norm(r0)
  
  i <- 19L
  while (norm_r0 < (norm_y * 2^i))
    i <- i - 2L
  if (i < -19L)
    i <- -21L
  ck <- 2^(c(-21L, -3L, 1L, 19L) - i)
  y <- y + r0 %*% t(ck)
  list(beta = Xinv %*% y, y = y, phi = atan(ck))
}

## Die verschiedenen Algorithmen fuer KQ
greville <- function(X){
  if (nrow(X) > ncol(X))
    return(t(Recall(t(X))))
  m <- nrow(X)                              # voller Rang ==> m = rang(X)
  X.plus <- X[1, ] / sum(X[1, ]^2)          # initialize X+
  for(j in 1 + seq_len(m - 1)){
    djt <- t(X[j, ]) %*% X.plus             # t(dj), t(cj), bj nach Definition
    cjt <- t(X[j, ]) - djt %*% X[1:(j-1), ]
    bj <- t(cjt) / sum(t(cjt)^2)            # = t(cj+)
    X.plus <- cbind(X.plus - bj %*% djt, bj)
  }
  return(as.matrix(X.plus))
}
mgs <- function(X) {
  choosePivotColumn <- function(X, cols) {
    XX <- X[, cols]
    cols[which.max(colSums(XX * XX))]
  }
  exchangeColumns <- function(X, i, j, which = 1:nrow(X)) {
    if (i != j) {
      tmp <- X[which, i]
      X[which, i] <- X[which, j]
      X[which, j] <- tmp
    }
    X
  }
  # Ersetze breite durch hohe Matrix. (Immer voller Spaltenrang)
  if (nrow(X) < ncol(X))
    return(t(Recall(t(X))))
  
  # Initialisiere alle benoetigten Variablen.
  k <- ncol(X)
  d <- numeric(k)
  U <- diag(1, nrow = k)
  P <- U
  
  # Nur orthogonalisieren, wenn es mehr als eine Spalte gibt!
  if (k > 1) {
    for (s in 1:(k-1)) {
      # Hier muss das Pivot gewaehlt werden:
      pivot <- choosePivotColumn(X, s:k)
      # Jetzt tauschen wir in allen Matrizen das Pivot nach vorne
      X <- exchangeColumns(X, s, pivot)
      P <- exchangeColumns(P, s, pivot)
      if (s > 1)
        U <- exchangeColumns(U, s, pivot, 1:(s-1))
      qs <- X[, s]
      d[s] <- crossprod(qs)
      for (i in (s + 1):k) {
        qi <- X[, i]
        U[s, i] <- crossprod(qi, qs) / d[s]
        X[, i] <- qi - U[s, i] * qs
      }
    }
  }
  d[k] <- crossprod(X[, k])
  # Und hier muss vorne P anmultipliziert werden
  X <- P %*% backsolve(U, diag(1 / d, nrow = length(d)) %*% t(X))
  return(X)
}
lsSolveNormal <- function(X, y) {
  At <- t(X)
  AtA <- At %*% X
  Atb <- At %*% y
  drop(solve(AtA, Atb, tol = 1e-30))
}
lsSolveLM <- function(X, y) {
  lm.fit(X, y)$coefficients
}
lsSolveMGS <- function(X, y) {
  QR <- mgs(X)
  drop(QR %*% y)
}
lsSolveGreville <- function(X, y) {
  QR <- greville(X)
  drop(QR %*% y)
}
######################################################################
######################################################################


# konditionsZahl - returns condition number of the input matrix
#
# Input :
#  A     - Matrix
# ginv.A - generalized inverse of the matrix
#
# Output :
#  condition number of the matrix A.

konditionsZahl <- function(A, ginv.A){
  return(sqrt(sum(abs(A)^2)) * sqrt(sum(abs(ginv.A)^2)))
}

# relative.err - returns relative errors of solutions(Beta) computed by various 
#                algorithms for Least Squares Problems.
#
# Input :
#  test.mat     - a test matrix
#  linke.seite  - a list of elements of linke seite.
#  BetaZero     - true solutions of the linear model.
#  winkel       - the angle between y and the projection of y.
#
# Output :
#  a list of relative errors of solutions computed by various algorithms. 

relative.err <- function(test.mat, linke.seite, BetaZero, winkel){
  greville.err <- mean((greville(test.mat)%*%linke.seite$y[,winkel])
                       /BetaZero-1)
  mgs.err <- mean((mgs(test.mat)%*%linke.seite$y[,winkel])/BetaZero-1)
  
  
  ## try() is needed, because some of these algorithms don't work always.
  if (is.double(try(lsSolveNormal(test.mat, linke.seite$y[,winkel])
                    /BetaZero-1, TRUE))){
    SolveNormal.err <- mean(lsSolveNormal(test.mat, linke.seite$y[,winkel])
                            /BetaZero-1)}
  else{SolveNormal.err <- NA}
  
  if (is.double(try(lsSolveLM(test.mat, linke.seite$y[,winkel])
                    /BetaZero-1, TRUE))){
    SolveLM.err <- mean(lsSolveLM(test.mat, linke.seite$y[,winkel])
                        /BetaZero-1)}
  else{SolveLM.err <- NA}
  
  if (is.double(try(lsSolveMGS(test.mat, linke.seite$y[,winkel])
                    /BetaZero-1, TRUE))){
    SolveMGS.err <- mean(lsSolveMGS(test.mat, linke.seite$y[,winkel])
                         /BetaZero-1)}
  else{SolveMGS.err <- NA}
  
  if (is.double(try(lsSolveGreville(test.mat, linke.seite$y[,winkel])
                    /BetaZero-1, TRUE))){
    SolveGreville.err <- mean(lsSolveGreville(test.mat, linke.seite$y[,winkel])
                              /BetaZero-1)}
  else{SolveGreville.err <- NA}
  
  return (list(greville = greville.err, mgs = mgs.err, 
               SolveNormal = SolveNormal.err,
               SolveLM = SolveLM.err,
               SolveMGS = SolveMGS.err,
               SolveGreville = SolveGreville.err
               ))
}


# LiMoTest     - Test process of steps 1-4 from the lecture slides p.318-319.
#
# Input :
# 
# Output :
#  a list of data frames of condition number and relative errors when the angle
#  differs from y1 to y4 using different algorithms. 

LiMoTest <- function(){
  nach.Winkel.list <- list()
  for (winkel in 1:4){ ## y1, y2, y3, y4
    
    df <- data.frame()
    for(s in 1:5){ 
      n <- 2^(s+1) ## n: 4, 8, 16, 32, 64
      k <- n/2 - 1 ## the number of rows to remove
      
      for (Z in 2^(0:20)){
        ## test matrix and inverse of the matrix
        test.mat <- t(zielkeMatrix(Z, n)[-(2*(1:k)),])
        inv.test.mat <- t(wMatrix(n)%*%invZielkeMatrix(Z, n)[,-(2*(1:k))])
        
        linke.seite <- leftHandSide(test.mat, inv.test.mat)
        BetaZero <- linke.seite$beta[,winkel]
        
        err.list <- relative.err(test.mat, linke.seite, BetaZero, winkel)
        df <- rbind(cbind(konditionsZahl(test.mat, inv.test.mat), 
                          err.list$greville,
                          err.list$mgs, 
                          err.list$SolveNormal, 
                          err.list$SolveLM,
                          err.list$SolveMGS, 
                          err.list$SolveGreville), df)
      }
    }
    names(df) <- c("Konditionszahl", "Greville", "MGS", "SolveNormal", 
                   "SolveLM", "SolveMGS", "SolveGreville")
    nach.Winkel.list[[winkel]] <- df
  }
  return(nach.Winkel.list)
}
data <- LiMoTest()
data


## Sorry! I was busy during this weekend. I should stop here and will save the 
## rest of my work (Aufgabe 3) to compare with Musterloesungen and continue
## working sometime this week!


##### Aufgabe 3)
# y1.plotting <- function(){
#   plot(log10(data[[1]]$Konditionszahl), log10(data[[1]]$Greville))
#  lines(log10(data[[1]]$Konditionszahl), log10(data[[1]]$MGS), 
#      type = "b", pch = 18, lwd = 2, col="blue", lty=2)
#  lines(log10(data[[1]]$Konditionszahl), log10(data[[1]]$SolveNormal), 
#      type = "b", pch = 18, lwd = 2, col="red", lty=2)
#  lines(log10(data[[1]]$Konditionszahl), log10(data[[1]]$SolveLM), 
#      type = "b", pch = 18, lwd = 2, col="black", lty=2)
#  lines(log10(data[[1]]$Konditionszahl), log10(data[[1]]$SolveMGS), 
#      type = "b", pch = 18, lwd = 2, col="black", lty=2)
#  lines(log10(data[[1]]$Konditionszahl), log10(data[[1]]$SolveGreville), 
#      type = "b", pch = 18, lwd = 2, col="black", lty=2)
#}
#y1.plotting()