rhs_formula <- function(lhs, x) {
  if (!is.character(x) || length(x) < 1L) {
    stop("x must contain at least one covariate column name.", call. = FALSE)
  }
  stats::as.formula(paste(lhs, "~", paste(x, collapse = " + ")))
}

estimate_cp_inputs <- function(data, y, z, x, family = stats::binomial()) {
  zv <- col_data(data, z, "z")
  col_data(data, y, "y")
  for (nm in x) {
    col_data(data, nm, "x")
  }
  validate_binary_indicator(zv, arg = "z")

  ps_fit <- stats::glm(rhs_formula(z, x), data = data, family = family)
  ehat <- as.numeric(stats::predict(ps_fit, type = "response"))
  data_treated <- data[zv == 1, , drop = FALSE]
  data_control <- data[zv == 0, , drop = FALSE]
  y_formula <- rhs_formula(y, x)
  mu1 <- stats::lm(y_formula, data = data_treated)
  mu0 <- stats::lm(y_formula, data = data_control)
  tau_hat <- as.numeric(stats::predict(mu1, newdata = data) - stats::predict(mu0, newdata = data))

  data.frame(data, ehat = ehat, tau_hat = tau_hat)
}

estimate_local_cp_inputs <- function(data, y, d, z, x,
                                     family = stats::binomial(),
                                     min_first_stage = 1e-6) {
  zv <- col_data(data, z, "z")
  for (nm in c(y, d, x)) {
    col_data(data, nm, "column")
  }
  validate_binary_indicator(zv, arg = "z")

  ps_fit <- stats::glm(rhs_formula(z, x), data = data, family = family)
  ehat <- as.numeric(stats::predict(ps_fit, type = "response"))
  data_z1 <- data[zv == 1, , drop = FALSE]
  data_z0 <- data[zv == 0, , drop = FALSE]
  y_formula <- rhs_formula(y, x)
  d_formula <- rhs_formula(d, x)
  y1 <- stats::lm(y_formula, data = data_z1)
  y0 <- stats::lm(y_formula, data = data_z0)
  d1 <- stats::lm(d_formula, data = data_z1)
  d0 <- stats::lm(d_formula, data = data_z0)
  delta_y <- as.numeric(stats::predict(y1, newdata = data) - stats::predict(y0, newdata = data))
  delta_d <- as.numeric(stats::predict(d1, newdata = data) - stats::predict(d0, newdata = data))
  tau_c_hat <- delta_y / delta_d
  tau_c_hat[!is.finite(tau_c_hat) | abs(delta_d) <= min_first_stage] <- NA_real_

  data.frame(
    data,
    ehat = ehat,
    delta_y = delta_y,
    delta_d = delta_d,
    pi_c_hat = delta_d,
    tau_c_hat = tau_c_hat
  )
}
