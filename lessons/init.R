knitr::opts_chunk$set('dev' = 'png', warning = TRUE, error = TRUE,
                      cache = TRUE, autodep = TRUE,
                      fig.show = 'all',
                      echo = TRUE,
                      results = 'markup')

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
  string <- paste0('<div class="panel panel-info">',
                   '<div class="panel-heading"><h3 class="panel-title">Solution</h3></div>',
                   '<div class="panel-collapse collapse">')
  string
}

solution_end <- function() {
  string <- "</div></div>"
  string
}

