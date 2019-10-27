# simpleQSort - Simpler Quicksort

simpleQSort <- function(x) {
  stopifnot(
    is.vector(x),
    is.numeric(x),
    all(is.finite(x))
    )
  
  if (length(x) <= 1L)
    return(list(res = x, ncmp = 0))

  pivot <- sample(x, 1)
  less_or_equal_pivot <- x <= pivot

  left <- Recall(x[less_or_equal_pivot])
  right <- Recall(x[!less_or_equal_pivot])

  list(res = c(left$res, right$res),
       ncmp = left$ncmp + right$ncmp + length(x))
}

simpleQSort(sample(10))