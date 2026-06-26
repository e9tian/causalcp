new_causalcp_result <- function(plot, slopes, data_used) {
  structure(
    list(plot = plot, slopes = slopes, data_used = data_used),
    class = "causalcp_result"
  )
}

print.causalcp_result <- function(x, ...) {
  print(x$plot)
  invisible(x)
}
