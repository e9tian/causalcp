new_CPplot_result <- function(plot, slopes, data_used) {
  structure(
    list(plot = plot, slopes = slopes, data_used = data_used),
    class = "CPplot_result"
  )
}

print.CPplot_result <- function(x, ...) {
  print(x$plot)
  invisible(x)
}
