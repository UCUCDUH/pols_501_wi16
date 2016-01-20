library("R6")

knitr::opts_chunk$set('dev' = 'png', warning = TRUE, error = TRUE,
                      cache = TRUE, autodep = TRUE,
                      fig.show = 'all',
                      echo = TRUE,
                      results = 'markup')

Counter <-
  R6Class("Counter",
          public =
            list(i = 0L,
                 pattern = "%d",
                 initialize = function(i, pattern) {
                    if (!missing(i)) self$i <- i
                    if (!missing(pattern)) self$pattern <- pattern
                 },
                 add = function(value = 1L) {
                   self$i <- self$i + value
                 },
                 reset = function(value = 0L) {
                   self$i <- value
                 },
                 label = function() {
                   sprintf(self$pattern, self$i)
                 }             
            )
  )

.SOLUTION_COUNTER <- Counter$new(pattern = "solution-%d")

            
challenge_start <- function() {
  string <- paste0('<div class="panel panel-primary">',
                   '<div class="panel-heading"><h3 class="panel-title">Challenge</h3></div>',
                   '<div class="panel-body">')
  string
}
challenge_end <- function() {
  string <- "</div></div>"
  string
}

solution_start <- function() {
  .SOLUTION_COUNTER$add()
  solution_id <- .SOLUTION_COUNTER$label()
  string <- paste0('<div class="panel panel-info">',
                   '<div class="panel-heading">',
                   '<h3 class="panel-title">',
                   '<a data-toggle="collapse" href="#',
                   solution_id,
                   '">Solution</a>',
                   '</h3>',
                   '</div>',
                   '<div id="',
                   solution_id,
                   '" class="panel-collapse collapse">')
  string
}

solution_end <- function() {
  string <- "</div></div>"
  string
}

