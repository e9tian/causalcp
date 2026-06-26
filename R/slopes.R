fit_slope <- function(data, weights = NULL, label) {
  out <- data.frame(
    fit = label,
    n = nrow(data),
    slope = NA_real_,
    std_error = NA_real_,
    p_value = NA_real_
  )
  if (nrow(data) < 2L || length(unique(data$x)) < 2L) {
    return(out)
  }

  fit_args <- list(formula = y ~ x, data = data)
  if (!is.null(weights)) {
    fit_args$weights <- weights
  }
  fit <- do.call(stats::lm, fit_args)
  sm <- summary(fit)$coefficients
  if (!"x" %in% rownames(sm)) {
    return(out)
  }

  out$slope <- unname(sm["x", "Estimate"])
  out$std_error <- unname(sm["x", "Std. Error"])
  out$p_value <- unname(sm["x", "Pr(>|t|)"])
  out
}

cp_slopes <- function(data, ehat, tau_hat, treat = NULL) {
  e <- col_data(data, ehat, "ehat")
  tau <- col_data(data, tau_hat, "tau_hat")
  z <- col_data(data, treat, "treat")
  ok <- finite_complete(e, tau)
  if (!is.null(z)) {
    validate_binary_indicator(z, arg = "treat")
    ok <- ok & is.finite(z)
  }

  df <- data.frame(e = e[ok], tau = tau[ok])
  if (is.null(z)) {
    return(fit_slope(data.frame(y = df$tau, x = df$e), label = "All units"))
  }

  df$z <- z[ok]
  out <- rbind(
    fit_slope(data.frame(y = df$tau, x = df$e), label = "All units"),
    fit_slope(data.frame(y = df$tau[df$z == 1], x = df$e[df$z == 1]), label = "Treated units"),
    fit_slope(data.frame(y = df$tau[df$z == 0], x = df$e[df$z == 0]), label = "Control units")
  )
  rownames(out) <- NULL
  out
}

local_cp_slopes <- function(data, ehat, tau_c_hat, pi_c_hat, group = NULL) {
  e <- col_data(data, ehat, "ehat")
  tau <- col_data(data, tau_c_hat, "tau_c_hat")
  pi_c <- col_data(data, pi_c_hat, "pi_c_hat")
  z <- col_data(data, group, "group")
  ok <- finite_complete(e, tau, pi_c) & pi_c > 0
  if (!is.null(z)) {
    validate_binary_indicator(z, arg = "group")
    ok <- ok & is.finite(z)
  }

  df <- data.frame(e = e[ok], tau = tau[ok], pi_c = pi_c[ok])
  if (is.null(z)) {
    return(fit_slope(data.frame(y = df$tau, x = df$e), weights = df$pi_c, label = "All units"))
  }

  df$z <- z[ok]
  out <- rbind(
    fit_slope(data.frame(y = df$tau, x = df$e), weights = df$pi_c, label = "All units"),
    fit_slope(
      data.frame(y = df$tau[df$z == 1], x = df$e[df$z == 1]),
      weights = df$pi_c[df$z == 1],
      label = "Treated units"
    ),
    fit_slope(
      data.frame(y = df$tau[df$z == 0], x = df$e[df$z == 0]),
      weights = df$pi_c[df$z == 0],
      label = "Control units"
    )
  )
  rownames(out) <- NULL
  out
}
