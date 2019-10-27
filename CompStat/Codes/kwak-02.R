# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang M.Sc.Datenwissenschaft  *
# *          Uebungsblatt Nr.2                   *
# *          Uebung am Freitag                   *
# ************************************************

rm(list=ls())
library(testthat)

##### Aufgabe 1 

## In dieser Aufgabe wird eine Funktion implementiert, die eine Liste der
## reelle Zahlen sortiert. Schritteweise von links nach rechts der Liste 
## werden zwei Elemente vergliechen, und vertauscht, wenn die Linke nach dem 
## logischen Parameter groesser(oder kleiner) als der Rechte. Die Ausfuehrung 
## dieser Verarbeitung findet statt, bis die eingegebene Liste vollstaendig 
## sortiert ist. Dort bedeutet ein zusaetzlicher logischer Parameter 
## "decreasing", ob die Elemente der Liste sich entweder absteigend(TRUE) oder 
## aufsteigend(FALSE) sortiert werden muss. 

# bubbleSort - gibt die sortierte Liste der Zahlen zurueck, wenn eine Liste
#             eingegeben wird.
# Eingabe : 
#  E.vec -        Eine Liste der reelle Zahlen(ein numerischer Vektor)
#                 Eingabevektor, der zu sortieren ist.
#                  (Negative Zahlen sind auch moeglich!)
#
#  decreasing  -   ein logischer Parameter. Falls die aufsteigende Version von
#                  E.vec gewuenscht ist, sollte dieser Parameter als 
#                  "FALSE" gesetzt werden. Sonst, "TRUE".
# Ausgabe:
#   [[1]] eine sortierte Liste(ein numerishcer Vektor in R) der reelle Zahlen.
#   [[2]] die Anzahl der durchgefuehrten Vergleiche


bubbleSort <- function(E.vec, decreasing){
  ## wenn die Laenge des eingegebenen Vektors 0 oder 1 ist, 
  ## gibt die Funktion den Eingabevektor zurueck und die Anzahl der
  ## Vergleiche ist 0. 
  if (length(E.vec) == 0 | length(E.vec) == 1){
    #  vergleicheAnzahl - ein numerischer Skalar(Integer). Die Anzahl der 
    #                      durchgefuehrten Vergleiche.
    vergleicheAnzahl <- 0
    return(list(E.vec, vergleicheAnzahl))
  }
  
  else{
    ## Ist "decreasing" FALSE, sortiert die Funktion aufsteigend.
    if (decreasing == FALSE){
      ## Ob Vertausch stattfindet, spielt die Rolle, die Anzahl der Vergleiche
      ## zu berechnen. Zuerst setzt man "ob.Vertausch" als "FALSE". Wenn
      ## zumindest ein Vertausch waehrend der Durchlauf passiert ist, 
      ## dann wird es "TRUE" markiert.
      ## Ist  "ob.Vertausch" = TRUE nach der Durchlauf, ist es noetig,
      ## dass die Elemente außer diesem letzten stehenden Element wieder 
      ## vergleichen werden muss. d.h. z.B.
      ##   c(4, 1, 2, 3) : 4 wird 3 mal vergleichen. (ob.Vertausch = TRUE)
      ## -> c(1, 2, 3, 4) : die Naechsten c(1, 2, 3) muss noch gegeneinander 
      ##                     vergliechen werden. (Rekursion)
      vergleicheAnzahl <- (length(E.vec)-1)
      ob.Vertausch <- FALSE
      for (i in 1:(length(E.vec)-1)){
        if (E.vec[i] > E.vec[i+1]){
          ob.Vertausch <- TRUE
          ## ein neuer Speicher (new.E.vec.i) muss vorher deklariert 
          ## werden, um die zwei Werten zu vertauschen, bevor einer der 
          ## Wert verloren ist.
          new.E.vec.i <- E.vec[i+1]
          E.vec[i+1] <- E.vec[i]
          E.vec[i] <- new.E.vec.i
        }
        else{}  
      }   # end for
      if (ob.Vertausch == TRUE){
        ## Nach einer Durchlauf handelt es sich um die Resten. (Rekursion)
        return(
          list(
            c(bubbleSort(E.vec[-length(E.vec)], decreasing)[[1]], 
              E.vec[length(E.vec)])
            ,
            sum(c(bubbleSort(E.vec[-length(E.vec)], decreasing)[[2]], 
                  vergleicheAnzahl))
          )
        )
      }
      ## Falls ob.Vertausch = FALSE ist, sind die naechsten Vergleiche 
      ## der naechsten rekursiven Loop unnoetig.
      else {
        return(list(E.vec, vergleicheAnzahl))
      }
    }
    ## wenn decreasing = TRUE ist, absteigend sortieren. 
    ## Auf die Reihenfolge der Elemente achten.
    ## Ansonsten ist das Konzept im Prinzip  genauso.
    else { 
      vergleicheAnzahl <- (length(E.vec)-1)
      ob.Vertausch <- FALSE
      for (i in (length(E.vec)):2){
        if (E.vec[i-1] < E.vec[i]){
          ob.Vertausch <- TRUE
          new.E.vec.i <- E.vec[i-1]
          E.vec[i-1] <- E.vec[i]
          E.vec[i] <- new.E.vec.i
        }
        else{}
      }   
      if (ob.Vertausch == TRUE){
        return(
          list(
            c(E.vec[1], bubbleSort(E.vec[-1], decreasing)[[1]])
            ,
            sum(c(bubbleSort(E.vec[-1], decreasing)[[2]], vergleicheAnzahl))
          )
        )
      }
      else {
        return(list(E.vec, vergleicheAnzahl))
      }
    }
  }
}

## Testen
testbubbleSort <- function() {
  test_that("Simple Cases Testen!", {
    expect_equal((bubbleSort(c(4, -3, 2), TRUE)[[1]]), c(4, 2, -3))
    expect_equal(bubbleSort(c(1, 0, -1), FALSE)[[1]], c(-1, 0, 1))
    expect_equal((bubbleSort(c(10, 14, 12, 13), FALSE)[[1]]), c(10, 12, 13, 14))
    expect_equal(is.unsorted((bubbleSort(sample(10), FALSE)[[1]])),  FALSE)
  })
}
testbubbleSort()



##### Aufgabe 2

## In dieser Aufgabe wird eine Funktion implementiert, Bucket-Sort realisiert.
## Bucket-Sort sortiert die Beobachtungen in die Buckets vor und sortiert 
## jeden Topf(Bucket) mit einem einfachen Sortieralgorithmus. 

# bucketSort - gibt die sortierte Liste der Zahlen zurueck, wenn eine Liste
#             eingegeben wird.
# Eingabe : 
#  E.vec -        Eine Liste der reelle Zahlen(ein numerischer Vektor)
#                 Eingabevektor, der zu sortieren ist.
#                  (Negative Zahlen sind auch moeglich!)
#
#  n.bucket -       eine Ganzzahl (ein numerischer Skalar)
#                   Gewuenschte Anzahl der Buckets, beliebig eingeben.
#
# Ausgabe:
#   [[1]] eine sortierte Liste(ein numerishcer Vektor in R) der reelle Zahlen.
#   [[2]] die Anzahl der durchgefuehrten Vergleiche


bucketSort <- function(E.vec, n.bucket){
  ## wir nehmen an, dass nur aufsteigende Version von E.vec gewuenscht ist.
  decreasing <- FALSE
  res <- c()
  vergleicheAnzahl <- c()
  bucket <- rep(0, n.bucket)
  
  ## die Beobachtungen in die Buckets vorsortieren
  for (i in 1:(length(E.vec))){
    ## falls unten sogenannter Wert 0 ist, d.h. E.vec[i] = min(E.vec), muss man
    ## hier einen kleinen Wert E > 0 addieren, um eine Luecke zu vermeiden.
    ## beliebig E = 0.01 wurde gewaehlt.
    if ((E.vec[i]-min(E.vec))/(max(E.vec)-min(E.vec))==0){
      bucket[i] <- ceiling(0.01 + 
                             (E.vec[i]-min(E.vec))/(max(E.vec)-min(E.vec)))
    }
    else {
      bucket[i] <- ceiling(n.bucket*
                             (E.vec[i]-min(E.vec))/(max(E.vec)-min(E.vec)))  
    }
  }
  
  ## jeden Topf(Bucket) mit einem einfachen sortieren(bubbleSort) 
  for (j in 1:n.bucket){
    temporal.vec <- E.vec[bucket==j]
    res <- c(res, bubbleSort(temporal.vec, decreasing)[[1]])
    vergleicheAnzahl <- sum(c(vergleicheAnzahl, 
                              bubbleSort(temporal.vec, decreasing)[[2]]))
  }
  return(list(res, vergleicheAnzahl))
}

## Testen
testbucketSort <- function() {
  test_that("Simple Cases Testen!", {
    expect_equal((bucketSort(c(4, -3, 2), 3)[[1]]), c(-3, 2, 4))
    expect_equal(is.unsorted((bucketSort(sample(10), 9)[[1]])),  FALSE)
    expect_equal(is.unsorted((bucketSort(sample(15), 30)[[1]])),  FALSE)
    expect_equal(is.unsorted((bucketSort(sample(100), 30)[[1]])),  FALSE)
  })
}
testbucketSort()


#### Aufgabe 2-c)

## Leider war es unmoeglich, n.bucket von 1 bis 100 zu berechnen. 
## Es dauert leider zu lang. Meiner Meinung nach liegt es daran, 
## dass meine FunktionbubbleSort rekursiv ist. 

#set.seed(2018)
#test.Vektoren <- list()
#n.bucket <- 1:100
#memory.vec<- rep(0, 100)
#for (i in 1:100){
#   test.Vektoren[[i]] <- sample(1000)
#}


#for (k in n.bucket){
#  memory.vec[k] <- bucketSort(test.Vektoren[[k]], k)[[2]]
#  print(paste(length(n.bucket)-k, "more to go"))
#}


#plot(n.bucket, memory.vec, 
#     xlab = "Die Anzahl der Buckets", 
#     ylab = "Die Anzahl der Vergleiche",
#     main = "Die Anzahl der Vergleiche mit verschiedener Anzahl 
#     der Buckets von {1, 2, ... 100}")