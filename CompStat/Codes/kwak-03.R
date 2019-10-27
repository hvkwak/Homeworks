# ************************************************
# *          CStat2018   Quellcode               *
# *          Abgabe von Hyovin Kwak              *
# *          Matrikelnr. 214515                  *
# *          Studiengang M.Sc.Datenwissenschaft  *
# *          Uebungsblatt Nr.3                   *
# *          Uebung am Freitag                   *
# ************************************************

rm(list=ls())
library(testthat)

##### Aufgabe 1 

### Aufgabe 1-a)
# simpleQSort - returns a sorted list of numbers. 
#
# Inputs : 
#  x           -   a numeric vector which is to be sorted.
#                  (negative numbers are also possible.)
#
# Outputs:
#   $res       - a sorted numeric vector
#   $ncmp      - the number of comparisons when the program is executed.


simpleQSort <- function(x) {
  # to check if the inputs are the right types of arguments:
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  
  # if the length of the input equals or shorter than 1, it returns
  # the input vector and there occurs no comparison.
  if (length(x) <= 1L)
    return(list(res = x, ncmp = 0))
  
  # instead of "sample(x, 1)" (originally suggested to find "pivot" value.)
  # median(x) could be a solution.
  pivot <- median(x)
  less_or_equal_pivot <- x <= pivot
  
  # Divide and Conquer Concept
  # With this value "pivot", which is randomly chosen from the numbers of the
  # input vector, the vector will be divided into two groups: the one with the
  # numbers smaller than pivot(left) and the other one with the numbers bigger 
  # than pivot(right). When they are separated, same process will be repeated 
  # in those left and right vectors, until the seperated vectors reaches
  # its length of 1.
  
  left <- Recall(x[less_or_equal_pivot])
  right <- Recall(x[!less_or_equal_pivot])
  
  # When the vectors reaches its length of 1, they are called a step back to be
  # combined with other vectors, which finally constructs a complete version
  # of sorted numeric vector.
  return(list(res = c(left$res, right$res),
       ncmp = left$ncmp + right$ncmp + length(x))
        )

  ## More comments on Aufgabe 1-a): "Ist die Funktion fehlerfrei?"
  #  The function operates with no syntax errors. Still there are two things
  #  I'd like to add before moving on to the next Aufgabe:
  #  1. Because the "pivot" value is randomly selected by the function of
  #     "sample(x, 1)", this leaves a room for improvement when it comes to 
  #     calculating the number of comparisons. My suggestion is to use 
  #     a fixed value, for example, median(), to choose the "pivot" value, 
  #     which can avoid unnecessary repeated runs of this code.
  #     
  #  2. According to the R syntax could've been better to add "return" function
  #     at the end of this function. ("return" function at the line of 58 of 
  #     this code.) Although the function runs without this.
}

## Tests
testsimpleQSort <- function() {
  test_that("Testen!", {
    ## res test
    expect_equal(is.unsorted((simpleQSort(c(-3, -5, 2, 1, 7))[[1]])),  FALSE)
    expect_equal(is.unsorted((simpleQSort(sample(50))[[1]])),  FALSE)
    expect_equal(is.unsorted((simpleQSort(sample(100))[[1]])),  FALSE)
    expect_equal(is.unsorted((simpleQSort(sample(10000, 10))[[1]])),  FALSE)
    ## ncmp test
    expect_equal(simpleQSort(sample(2))[[2]], 2)
    expect_equal(simpleQSort(sample(3))[[2]], 5)
    expect_equal(simpleQSort(sample(4))[[2]], 8)
    expect_equal(simpleQSort(c(-3, -5, 2, 1, 7))[[2]], 12)
  })
}
testsimpleQSort()

### Aufgabe 1-b)
# myOptimaleSort - returns a sorted list of three numbers. 
#
# Inputs : 
#  x           -   a numeric vector of length 3 which is to be sorted
#                  (negative numbers are also possible)
#
# Outputs:
#              - a sorted numeric vector, also length 3


## Warum ist es für Clever-Quicksort nötig, diese Funktion zu implementieren?
# This must play an important role when it comes to using Clever-Quicksort,
# because the Clever-Quicksort is the realisation of type 3 or 4 of Quicksort,
# which chooses the 3 values from the given input vector and find the median
# of them to start sorting the given input.

myOptimaleSort <- function(x){
  # It is especially important to check if the length of the vector is 3.
  stopifnot(
    is.vector(x),
    is.numeric(x),
    length(x) == 3
  )
  # Three elements comparison. First two of them(x1, x2) should be compared,
  # one of these first two(x2) and the third element(x3) should be compared.
  # If it is still unknown, which one biggest is and which one smallest is,
  # x1 and x3 must be compared one more time.
  if (x[1] <= x[2]){
    if (x[3] <= x[1]){ #Simple case
      return(c(x[2], x[1], x[3]))
    }
    else{ #x[3] > x[1]
      if (x[2]<=x[3]){
        return(c(x[3], x[2], x[1]))
      }
      else{ #x[2]>x[3]
        return(c(x[2], x[3], x[1]))
      }  
    }
  }
  else{ # x[1] > x[2]
    if(x[1]<= x[3]){
      return(c(x[3], x[1], x[2]))
    }
    else{ # x[1] > x[3]
      if (x[2] <= x[3]){
        return(c(x[1], x[3], x[2]))
      }
      else{ # x[2] > x[3]
        return(c(x[1], x[2], x[3]))
      }
    }
  }
}

## Tests
testmyOptimaleSort <- function() {
  test_that("Testen!", {
    expect_equal(myOptimaleSort(c(-10, -100, 500)), c(500, -10, -100))
    expect_equal(myOptimaleSort(sample(3)), c(3, 2, 1))
    expect_equal(myOptimaleSort(c(1, 30, 1)), c(30, 1, 1))
    expect_equal(!is.unsorted(myOptimaleSort(sample(100, 3))),  FALSE)
    expect_equal(!is.unsorted(myOptimaleSort(sample(50, 3))),  FALSE)
    expect_equal(!is.unsorted(myOptimaleSort(sample(30, 3))),  FALSE)
    expect_equal(!is.unsorted(myOptimaleSort(sample(20, 3))),  FALSE)
    expect_equal(!is.unsorted(myOptimaleSort(sample(10, 3))),  FALSE)
  })
}
testmyOptimaleSort()

### Aufgabe 1-c)
# cleverQSort - returns a sorted list of three numbers. 
#
# Inputs : 
#  x           -   a numeric vector which is to be sorted.
#                  (negative numbers are also possible.)
#
# Outputs:
#   $res       - a sorted numeric vector
#   $ncmp      - the number of comparisons when the program is executed.

cleverQSort <- function(x) {
  # to check if the inputs are the right types of arguments:
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
  )
  
  if (length(x) <= 1L){
    return(list(res = x, ncmp = 0))
  }
  # if the length of the vector is 2, it's no use to use cleverQSort,
  # because it first takes 3 values from the vector and find median of them
  # to implement simpleQSort. a vector length of 2 could be easily sorted 
  # through simpleQSort.
  if (length(x) <= 2L){
    return(simpleQSort(x))
  }
  
  # as it was introduced in the lecture, type 3 of choosing three values:
  # a1 : the first value of the vector
  # a2 : the value at the middle of the vector. (if the length of the vector
  #      is even, take the value at left of the very middle.)
  # a3 : the last value of the vector
  a1 <- x[1]
  a3 <- x[length(x)]
  if (length(x)%%2 == 1){
    a2 <- x[(length(x)+1)/2]
  }
  else{
    a2 <- x[length(x)/2]
  }
    
  # myOptimaleSort is implemented to find the median(a1, a2, a3)
  pivot <- myOptimaleSort(c(a1, a2, a3))[2]
  # below from here operates same as simpleQSort
  less_or_equal_pivot <- x <= pivot
  left <- cleverQSort(x[less_or_equal_pivot])
  right <- cleverQSort(x[!less_or_equal_pivot])
  return(list(res = c(left$res, right$res),
              ncmp = left$ncmp + right$ncmp + length(x))
  )
}

## Tests
testcleverQSort <- function() {
  test_that("Testen!", {
    expect_equal(is.unsorted(cleverQSort(c(-3, -5, 2, 1, 7))[[1]]),  FALSE)
    expect_equal(is.unsorted((cleverQSort(sample(50))[[1]])),  FALSE)
    expect_equal(is.unsorted((cleverQSort(sample(100))[[1]])),  FALSE)
    expect_equal(is.unsorted((cleverQSort(sample(10000, 10))[[1]])),  FALSE)
    # ncmp test : As cleverQSort involves 3 random values to get the first
    #             pivot value, there's no meaning to find ncmp.
  })
}
testcleverQSort()



##### Aufgabe 2

## runTuringMachine - runs the simulator for a generic turing machine
##
## Input
##   I       - the instruction set. Must be a list, that contains a 
##             list for every instruction. Every single instruction is
##             a list with 5 entries (in this order)
##             * The cell number
##             * The character from the tape
##             * The character, which will be printed on the tape 
##             * The instruction for the cell selector, must be "L",
##               "R" or "N"
##             * The next cell number
##   tape    - the initial tape of the TM
##   L0      - the initial instruction of the TM
##   F       - the final states of the TM
##   ini.pos - the initiel position of the RW
##
## Output
##   The finale tape is returned invisible. As a side effect after every step
##   the tape is  printed on the R console
runTuringMachine <- function(I, tape, L0, F, ini.pos) {
  ## Save the current of the TM in a list. This list contains:
  ## cell.selector - the current value of the cell selector
  ## tape          - the current tape
  ## pos           - the current position of the RW
  tm <- list(cell.selector = L0, tape = tape, pos = ini.pos)
  repeat {
    ## some nice output on the console
    tape.str <- paste(" ", paste(tm$tape, collapse = " "), sep = "")
    i <- tm$pos * 2 
    substr(tape.str, i - 1, i - 1) = "*"
    substr(tape.str, i + 1, i + 1) = "*"
    cat("tape:", tape.str , " cell.selector:", tm$cell.selector)
    ## error, if the machine runs of the tape
    if (tm$pos < 1 || tm$pos > length(tape))
      stop("The TM ran of the tape")
    ## stop if final state is reaches
    if(tm$cell.selector %in% F)
      break  
    ## execute one Step
    tm <- oneStep(I, tm$tape, tm$cell.selector, tm$pos)
  }
  cat("\n")
  return(invisible(tm$tape))
}

## oneStep - executes one Step of a given Turing Machine.
##
## Input
##   I             - the instruction set, as described in the 
##                   documentation of turingMachine
##   tape          - the current tape of the TM
##   cell.selector - (cell selector) the current state of the TM
##   pos           - the current position of the RW
##
## Output
##   A list with the named elements
##   tape  - the tape of the TM after the execution of the step
##   state - the new state of the TM
##   pos   - the new position of the RW
oneStep <- function(I, tape, cell.selector, pos) {
  ## 1st cycle
  command.register <- Filter(function(p) p[[1]] == cell.selector, I)
  ## 2nd cycle
  input.register <- tape[pos]
  ## 3rd cycle
  tmp <- Find(function(p) p[[2]] == input.register, command.register)
  operation.register <- tmp[3:4]
  cell.selector <- tmp[[5]]
  ## some nice output
  cat("  next:", unlist(tmp), "\n")
  ## 4th cycle
  tape[pos] <- operation.register[[1]]
  ## 5th cycle
  pos <- if(operation.register[[2]] == "L") pos - 1L else pos
  pos <- if(operation.register[[2]] == "R") pos + 1L else pos
  ## return the new TM state
  return(list(cell.selector = cell.selector, tape = tape, pos = pos))
}


## A Program to see if there are "x"s more than twice as many as "y"s.
## Please read PDF Datei for further explanations.
prog.bxy <- list(
  list(1, "b", "b", "R", 2),
  list(1, "x", "x", "R", 0),
  list(1, "y", "y", "R", 0),
  
  list(2, "b", "b", "L", 0),
  list(2, "x", "x", "R", 11),
  list(2, "y", "y", "R", 30),
  
  list(3, "b", "x", "R", 0),
  list(3, "x", "b", "L", 3),
  list(3, "y", "b", "L", 3),
  
  list(4, "b", "y", "R", 0),
  list(4, "x", "b", "L", 4),
  list(4, "y", "b", "L", 4),
  
  list(10, "b", "b", "L", 4),
  list(10, "x", "x", "R", 11),
  list(10, "y", "y", "R", 30),
  
  list(11, "b", "b", "L", 3),
  list(11, "x", "x", "R", 12),
  list(11, "y", "y", "R", 20),
  
  list(12, "b", "b", "L", 3),
  list(12, "x", "x", "R", 13),
  list(12, "y", "y", "R", 10),
  
  list(13, "b", "b", "L", 3),
  list(13, "x", "x", "R", 14),
  list(13, "y", "y", "R", 11),
  
  list(14, "b", "b", "L", 3),
  list(14, "x", "x", "R", 15),
  list(14, "y", "y", "R", 12),
  
  list(15, "b", "b", "L", 3),
  list(15, "x", "x", "R", 16),
  list(15, "y", "y", "R", 13),
  
  list(16, "b", "b", "L", 3),
  list(16, "x", "x", "R", 17),
  list(16, "y", "y", "R", 14),
  
  list(17, "b", "b", "L", 3),
  list(17, "x", "x", "R", 18),
  list(17, "y", "y", "R", 15),
  
  list(18, "b", "b", "L", 3),
  list(18, "x", "x", "R", 19),
  list(18, "y", "y", "R", 16),
  
  list(19, "b", "b", "L", 3),
  list(19, "x", "x", "R", 3),
  list(19, "y", "y", "R", 17),
  
  list(20, "b", "b", "L", 4),
  list(20, "x", "x", "R", 10),
  list(20, "y", "y", "R", 21),
  
  list(21, "b", "b", "L", 4),
  list(21, "x", "x", "R", 30),
  list(21, "y", "y", "R", 22),
  
  list(22, "b", "b", "L", 4),
  list(22, "x", "x", "R", 31),
  list(22, "y", "y", "R", 23),
  
  list(23, "b", "b", "L", 4),
  list(23, "x", "x", "R", 32),
  list(23, "y", "y", "R", 24),
  
  list(24, "b", "b", "L", 4),
  list(24, "x", "x", "R", 33),
  list(24, "y", "y", "R", 25),
  
  list(25, "b", "b", "L", 4),
  list(25, "x", "x", "R", 34),
  list(25, "y", "y", "R", 26),
  
  list(26, "b", "b", "L", 4),
  list(26, "x", "x", "R", 35),
  list(26, "y", "y", "R", 27),
  
  list(27, "b", "b", "L", 4),
  list(27, "x", "x", "R", 36),
  list(27, "y", "y", "R", 28),
  
  list(28, "b", "b", "L", 4),
  list(28, "x", "x", "R", 37),
  list(28, "y", "y", "R", 29),
  
  list(29, "b", "b", "L", 4),
  list(29, "x", "x", "R", 38),
  list(29, "y", "y", "R", 4),
  
  list(30, "b", "b", "L", 4),
  list(30, "x", "x", "R", 20),
  list(30, "y", "y", "R", 31),
  
  list(31, "b", "b", "L", 4),
  list(31, "x", "x", "R", 21),
  list(31, "y", "y", "R", 32),
  
  list(32, "b", "b", "L", 4),
  list(32, "x", "x", "R", 22),
  list(32, "y", "y", "R", 33),
  
  list(33, "b", "b", "L", 4),
  list(33, "x", "x", "R", 23),
  list(33, "y", "y", "R", 34),
  
  list(34, "b", "b", "L", 4),
  list(34, "x", "x", "R", 24),
  list(34, "y", "y", "R", 35),
  
  list(35, "b", "b", "L", 4),
  list(35, "x", "x", "R", 25),
  list(35, "y", "y", "R", 36),
  
  list(36, "b", "b", "L", 4),
  list(36, "x", "x", "R", 26),
  list(36, "y", "y", "R", 37),
  
  list(37, "b", "b", "L", 4),
  list(37, "x", "x", "R", 27),
  list(37, "y", "y", "R", 38),
  
  list(38, "b", "b", "L", 4),
  list(38, "x", "x", "R", 28),
  list(38, "y", "y", "R", 39),
  
  list(39, "b", "b", "L", 4),
  list(39, "x", "x", "R", 29),
  list(39, "y", "y", "R", 4)
)

## Tests
#Tape1
ini.tape.1 <- c("b", "b")
runTuringMachine(prog.bxy, tape = ini.tape.1, L0 = 1L, F = 0L,
                 ini.pos = 1L)
#Tape2
ini.tape.2 <- c("b", "x", "y", "x", "b")
runTuringMachine(prog.bxy, tape = ini.tape.2, L0 = 1L, F = 0L,
                 ini.pos = 1L)
#Tape3
ini.tape.3 <- c("b", "x", "y", "x", "x", "x", "x", "y", "b")
runTuringMachine(prog.bxy, tape = ini.tape.3, L0 = 1L, F = 0L,
                 ini.pos = 1L)
#Tape4
ini.tape.4 <- c("b", "y", "x","b")
runTuringMachine(prog.bxy, tape = ini.tape.4, L0 = 1L, F = 0L,
                 ini.pos = 1L)
#Tape5
ini.tape.5 <- c("b", "y", "x", "y", "y", "x" ,"x", "b")
runTuringMachine(prog.bxy, tape = ini.tape.5, L0 = 1L, F = 0L,
                 ini.pos = 1L)