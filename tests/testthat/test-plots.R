test_that("causalcp result stores plot, slopes, and data", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  tau <- 1 + 5 * e + c(0.01, -0.03, 0.03, -0.01)
  df <- data.frame(ehat = e, tau = tau)
  fit <- cp_plot(df, ehat = "ehat", tau_hat = "tau")
  expect_s3_class(fit, "causalcp_result")
  expect_s3_class(fit$plot, "ggplot")
  expect_true(is.data.frame(fit$slopes))
  expect_true(is.data.frame(fit$data_used))
})

test_that("cp_plot supports treated and control point labels", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  tau <- 1 + 5 * e + c(0.01, -0.03, 0.03, -0.01)
  df <- data.frame(
    ehat = rep(e, 2),
    tau = rep(tau, 2),
    z = rep(c(0, 1), each = 4)
  )
  fit <- cp_plot(df, ehat = "ehat", tau_hat = "tau", treat = "z")
  expect_equal(levels(fit$data_used$group), c("Control", "Treated"))
  expect_equal(fit$slopes$fit, c("Unweighted", "Treated weighted", "Control weighted"))
})

test_that("cp_plot lines use the same full-sample weighted fits as cp_slopes", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  df <- data.frame(
    ehat = rep(e, 2),
    tau = c(1 + 2 * e, 1 - 3 * e + c(0.2, -0.1, 0.1, -0.2)),
    z = rep(c(0, 1), each = 4)
  )
  fit <- cp_plot(df, ehat = "ehat", tau_hat = "tau", treat = "z")
  built <- ggplot2::ggplot_build(fit$plot)
  line_data <- built$data[[2]]
  line_slopes <- vapply(split(line_data, line_data$group), function(d) {
    unname(coef(stats::lm(y ~ x, data = d))[["x"]])
  }, numeric(1))
  names(line_slopes) <- fit$slopes$fit
  expect_equal(unname(line_slopes), fit$slopes$slope, tolerance = 1e-8)
})

test_that("local_cp_plot returns weighted local CP diagnostics", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  tau_c <- 1 + 5 * e + c(0.01, -0.03, 0.03, -0.01)
  df <- data.frame(
    ehat = rep(e, 2),
    tau_c = rep(tau_c, 2),
    pi_c = rep(1, 8),
    z = rep(c(0, 1), each = 4)
  )
  fit <- local_cp_plot(df, ehat = "ehat", tau_c_hat = "tau_c", pi_c_hat = "pi_c", group = "z")
  expect_s3_class(fit, "causalcp_result")
  expect_equal(levels(fit$data_used$group), c("Control", "Treated"))
  expect_equal(fit$slopes$fit, c("Complier weighted", "Treated-complier weighted", "Control-complier weighted"))
})
