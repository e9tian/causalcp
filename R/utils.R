col_data <- function(data, col, arg) {
  if (is.null(col)) {
    return(NULL)
  }
  if (!is.character(col) || length(col) != 1L) {
    stop(arg, " must be a single character column name.", call. = FALSE)
  }
  if (!col %in% names(data)) {
    stop(arg, " column not found in data: ", col, call. = FALSE)
  }
  out <- data[[col]]
  if (length(out) != nrow(data)) {
    stop(arg, " must have one value per row of data.", call. = FALSE)
  }
  out
}

finite_complete <- function(...) {
  vals <- list(...)
  if (length(vals) == 0L) {
    return(logical())
  }
  ok <- rep(TRUE, length(vals[[1L]]))
  for (v in vals) {
    ok <- ok & is.finite(v)
  }
  ok
}

validate_point_labels <- function(labels) {
  if (!is.character(labels) || length(labels) != 2L || anyNA(labels)) {
    stop("point_labels must be a character vector of length 2.", call. = FALSE)
  }
  if (any(labels == "")) {
    stop("point_labels cannot contain empty strings.", call. = FALSE)
  }
  if (length(unique(labels)) != 2L) {
    stop("point_labels must contain two distinct labels.", call. = FALSE)
  }
  labels
}

validate_binary_indicator <- function(x, arg = "group") {
  ux <- sort(unique(x[is.finite(x)]))
  if (!all(ux %in% c(0, 1))) {
    stop(arg, " must contain only 0/1 values.", call. = FALSE)
  }
  invisible(TRUE)
}

binary_group <- function(x, labels = c("Control", "Treated"), arg = "group") {
  labels <- validate_point_labels(labels)
  validate_binary_indicator(x, arg = arg)
  factor(ifelse(x == 1, labels[[2L]], labels[[1L]]), levels = labels)
}

make_grid <- function(x, n = 100L) {
  seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = n)
}

line_palette <- function(labels) {
  stats::setNames(c("#D55E00", "#0072B2", "#009E73")[seq_along(labels)], labels)
}

cp_line_data <- function(plot_df, labels, e_grid, point_labels, weighted = FALSE) {
  y_col <- if (weighted) "tau_c_hat" else "tau_hat"
  do.call(rbind, lapply(labels, function(lbl) {
    if (lbl == "All units") {
      fit_data <- plot_df
    } else if (lbl == "Treated units") {
      fit_data <- plot_df[plot_df$group == point_labels[[2L]], , drop = FALSE]
    } else {
      fit_data <- plot_df[plot_df$group == point_labels[[1L]], , drop = FALSE]
    }

    line_y <- rep(NA_real_, length(e_grid))
    if (nrow(fit_data) >= 2L && length(unique(fit_data$ehat)) >= 2L) {
      if (weighted) {
        fit <- stats::lm(tau_c_hat ~ ehat, data = fit_data, weights = pi_c_hat)
      } else {
        fit <- stats::lm(tau_hat ~ ehat, data = fit_data)
      }
      line_y <- as.numeric(stats::predict(fit, newdata = data.frame(ehat = e_grid)))
    }

    out <- data.frame(ehat = e_grid, fit = lbl)
    out[[y_col]] <- line_y
    out
  }))
}
