# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang Datenwissenschaft       *
# *          Uebungsblatt Nr.6                   *
# *          Uebung am Freitag                   *
# ************************************************
rm(list=ls())
library(testthat)
library(Matrix)  ## rankMatrix() returns the rank of the matrix.

##### Aufgabe 1)

#### Aufgabe 1-a)
# greville        - returns a generalized inverse of a matrix.
#
# Inputs : 
#  X           - a numeric matrix with the maximal row rank.
#
# Outputs:
#              - a generalized inverse of a matrix

greville <- function(X){
  stopifnot(
    rankMatrix(X)[1] == nrow(X), ## check if the row rank of a matrix is maximal.
    is.matrix(X),
    is.numeric(X),
    all(is.finite(X))
  )
  ## All the notations are based on the notations from the lecture slides p.272.
  ## Please note that...
  ## old.X.j       : a matrix of row binded matrix. X(j-1).
  ## old.X.plus.j  : the generalized inverse of matrix X(j-1).
  ## new.X.j       : the updated version of the row binded matrix of the input
  ##                 matrix, which is updated by row-binding old.X.j and the 
  ##                 j-th row. X(j).
  ## new.X.plus.j  : the updated version of the generalized inverse of matrix 
  ##                 X(j), which is updated by column-binding of old.X.plus.j 
  ##                 with other vectors.
  
  m <- nrow(X)
  
  ## Initial matrices:
  old.X.j <- t(as.matrix(X[1,]))
  old.X.plus.j <- as.matrix(as.numeric(1/(X[1,]%*%X[1,]))*(X[1,])) 

  for(j in 2:m){
    new.X.j <- rbind(old.X.j ,t(as.matrix(X[j,])))    
    d.T.j <- t(as.matrix(X[j,]))%*%old.X.plus.j       
    c.T.j <- t(as.matrix(X[j,])) - d.T.j%*%old.X.j    
    b.j <- as.numeric(solve(c.T.j%*%t(c.T.j))) * t(c.T.j)
    new.X.plus.j <- cbind(old.X.plus.j - b.j%*%d.T.j, b.j)
    old.X.j <- new.X.j
    old.X.plus.j <- new.X.plus.j
  }
  return(old.X.plus.j)
}


A <- matrix(sample(-3:4, 20, TRUE), nrow = 4, ncol = 5)
greville(A)

g.inv.A <- greville(A)
A%*%g.inv.A

g.inv.A




#### Aufgabe 1-b)
# testMyGreville        - tests if a greville(A) satiesfies the properties of
#                         generalized inverse of a matrix A. Please note that
#                         A+ is greville(A), generalized inverse of A.
#
# Properties:
# 1. AA+A  = A
# 2. A+AA+ = A+
# 3. AA+   = t(AA+), where t() is transpose of the matrix.
# 4. A+A   = t(A+A)

## Tests
testMyGreville<-function(){
  mat.list <- list()
  mat.list[[1]] <- matrix(c(1, 2, 1, 4, 1, 1), nrow=2)
  mat.list[[2]] <- matrix(c(1, 0, 0, 1, 1, -1, 1, 1, 1), nrow=3)
  mat.list[[3]] <- matrix(c(-1, -2, -3, 1, 5, 6, 1, 0, 2, 3), nrow=2)
  mat.list[[4]] <- matrix(c(0, 1, 1, 3, 4, 5, 9, 100), nrow=2)
  mat.list[[5]] <- diag(998, 3)
  mat.list[[6]] <- matrix(c(-1, 2, 1, 1, 4, 1, 1, 5, 1), nrow=3)
  for (i in 1:length(mat.list)){
  A <- mat.list[[i]]
  test_that("generalized inverse of matrices test!", {
    expect_equal(A%*%greville(A)%*%A, A)                        ## property 1
    expect_equal(greville(A)%*%A%*%greville(A), greville(A))    ## property 2
    expect_equal(A%*%greville(A), t(A%*%greville(A)))           ## property 3
    expect_equal(greville(A)%*%A, t(greville(A)%*%A))           ## property 4
    })
  }
}
testMyGreville()


##### Aufgabe 2)
##### Aufgabe 2-a) und Aufgabe 2-b)
# zielkeMatrix    - returns a matrix of the type 1 Zielke matrix form.
# invZielkeMatrix - returns an inverse matrix of Zielke matrix.
#
# Inputs : 
#  Z              - a (p x p) numeric matrix
#  n              - a numeric scalar
#  p              - a numeric scalar, the dimension of column and row of the 
#                   matrix Z (Please note that n/p >=3 and p > 0).
#  
# Outputs:
# zielkeMatrix    - a numeric matrix of type 1 Zielke matrix.
# invZielkeMatrix - a numeric inverse matrix of Zielke matrix.

zielkeMatrix <- function(Z, n, p){
  stopifnot(
    p > 0, 
    n/p >= 3,
    is.numeric(Z),
    is.numeric(n),
    is.numeric(p),
    all(is.finite(Z)) 
  )
  
  ## memory list
  XZ1.list <- list()
  
  ## initial constants
  Z <- matrix(Z, nrow=p, ncol=p)
  m <- n/p                   
  I.p <- diag(1, p)
  
  ## Please note that the building process of the Zielke matrix is based on
  ## the lecture notes, p.297.
  
  ## last column of the matrix
  XZ1.list[[m]] <- Z
  for(k in 1:(m-2)){
    XZ1.list[[m]] <- rbind(XZ1.list[[m]], Z)
  }
  XZ1.list[[m]] <- rbind(XZ1.list[[m]], Z-I.p)
  
  ## The rest of the matrix
  for (i in 1:(m-1)){
    for (j in 1:(m-i)){
      XZ1.list[[i]] <- rbind(XZ1.list[[i]], Z + i*I.p)
    }
    for(j in 1:i){
      XZ1.list[[i]] <- rbind(XZ1.list[[i]], Z + (i-1)*I.p)
    }
  }
  
  ## matrix return
  for(i in 1:length(XZ1.list)){
    if(i == 1){
      XZ1.mat <- XZ1.list[[i]]
    }
    else{
      XZ1.mat <- cbind(XZ1.mat, XZ1.list[[i]])
    }
  }
  return(XZ1.mat)
}

invZielkeMatrix <- function(Z, n, p){
  stopifnot(
    p > 0, 
    n/p >= 3,
    is.numeric(Z),
    is.numeric(n),
    is.numeric(p),
    all(is.finite(Z)) 
  )
  ## memory list
  inv.XZ1.list <- list()
  
  ## Please note that the building process of the inverse Zielke matrix is 
  ## also based on the lecture notes, p.297.
  
  ## initial constants
  Z <- matrix(Z, nrow=p, ncol=p)
  m <- n/p                   
  I.p <- diag(1, p)
  
  ## first row of the inverse matrix
  inv.XZ1.list[[1]] <- cbind(2*I.p, Z)
  if (m>=4){
    for (i in 1:(m-3)){
      inv.XZ1.list[[1]] <- cbind(I.p, inv.XZ1.list[[1]])
    }
  }
  inv.XZ1.list[[1]] <- cbind((-1)*Z - (m-2)*I.p, inv.XZ1.list[[1]])
  
  ## end row of the inverse matrix
  inv.XZ1.list[[m]] <- (-1)*Z - I.p
  for (i in 1:(m-2)){
    inv.XZ1.list[[m]] <- cbind((-1)*I.p, inv.XZ1.list[[m]])
  }
  inv.XZ1.list[[m]] <- cbind(Z + (m-2)*I.p, inv.XZ1.list[[m]])
  
  ## middle rows of the inverse matrix
  zeros <-  matrix(0, nrow=p, ncol=p)
  for (i in 2:(m-1)){ 
    for (k in 1:m){   
      if ( k == (m - i) ){inv.XZ1.list[[i]] <- cbind(inv.XZ1.list[[i]], I.p)}  
      else if( k == (m - i + 1) ){
        inv.XZ1.list[[i]] <- cbind(inv.XZ1.list[[i]], (-1)*I.p)}
      else {inv.XZ1.list[[i]] <- cbind(inv.XZ1.list[[i]], zeros)}
    }
  }

  ## inverse matrix return
  for(i in 1:length(inv.XZ1.list)){
    if(i == 1){
      inv.XZ1.mat <- inv.XZ1.list[[i]]
    }
    else{
      inv.XZ1.mat <- rbind(inv.XZ1.mat, inv.XZ1.list[[i]])
    }
  }
  return(inv.XZ1.mat)
}

##### Aufgabe 2-a) und Aufgabe 2-b)
# testZielkeMatrices - test Zielke matrices and their inverse. Please note that 
#                      those two examples are examples that are given in the
#                      lecture. This could've been better with more examples.
#                      Unfortunately, ginv{MASS} couldn't be an optimal 
#                      solution to compare with my functions due to 
#                      numerical errors of ginv{MASS}.

testZielkeMatrices <- function(){
  test_that("Zielke Matrices and their inverse test", {
    ## ZielkeMatrix(998, 3, 1) and its inverse
    expect_equal(
      zielkeMatrix(998, 3, 1), 
      matrix(c(999, 999, 998, 1000, 999, 999, 998, 998, 997), nrow = 3, 
             byrow=FALSE)
    )
    expect_equal(
      invZielkeMatrix(998, 3, 1), 
      matrix(c(-999, 1, 999, 2, -1, -1, 998, 0, -999), nrow=3, byrow=FALSE)
    )
    
    ## ZielkeMatrix(998, 4, 1) and its inverse
    expect_equal(
      zielkeMatrix(998, 4, 1),
      matrix(c(999, 999, 999, 998, 1000, 1000, 999, 999, 1001, 1000, 1000, 1000,
               998, 998, 998, 997), nrow=4, byrow=FALSE)
    )           
    expect_equal(
      invZielkeMatrix(998, 4, 1),
      matrix(c(-1000, 0, 1 ,1000, 1, 1, -1, -1, 2, -1, 0, -1, 998, 0, 0, -999),
             nrow=4, byrow=FALSE)
    )           
  })
}
testZielkeMatrices()


zielkeMatrix(3, 4, 1)[-1,]

invZielkeMatrix(3, 4, 1)

