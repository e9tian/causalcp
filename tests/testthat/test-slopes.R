test_that("cp_slopes returns full-sample weighted slopes", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  df <- data.frame(
    ehat = rep(e, 2),
    tau = c(1 + 2 * e, 1 - 3 * e + c(0.2, -0.1, 0.1, -0.2)),
    z = rep(c(0, 1), each = 4)
  )
  out <- cp_slopes(df, ehat = "ehat", tau_hat = "tau", treat = "z")
  expected <- c(
    unname(coef(stats::lm(tau ~ ehat, data = df))[["ehat"]]),
    unname(coef(stats::lm(tau ~ ehat, data = df, weights = ehat))[["ehat"]]),
    unname(coef(stats::lm(tau ~ ehat, data = df, weights = 1 - ehat))[["ehat"]])
  )
  expect_equal(out$fit, c("Unweighted", "Treated weighted", "Control weighted"))
  expect_equal(out$n, rep(nrow(df), 3))
  expect_equal(out$slope, expected)
})

test_that("local_cp_slopes returns full-sample complier-weighted slopes", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  df <- data.frame(
    ehat = rep(e, 2),
    tau_c = c(1 + 2 * e, 1 - 3 * e + c(0.2, -0.1, 0.1, -0.2)),
    pi_c = c(1, 0.7, 1.3, 1.6, 2, 1.8, 1.2, 0.9),
    z = rep(c(0, 1), each = 4)
  )
  out <- local_cp_slopes(df, ehat = "ehat", tau_c_hat = "tau_c", pi_c_hat = "pi_c", group = "z")
  expected <- c(
    unname(coef(stats::lm(tau_c ~ ehat, data = df, weights = pi_c))[["ehat"]]),
    unname(coef(stats::lm(tau_c ~ ehat, data = df, weights = pi_c * ehat))[["ehat"]]),
    unname(coef(stats::lm(tau_c ~ ehat, data = df, weights = pi_c * (1 - ehat)))[["ehat"]])
  )
  expect_equal(out$fit, c("Complier weighted", "Treated-complier weighted", "Control-complier weighted"))
  expect_equal(out$n, rep(nrow(df), 3))
  expect_equal(out$slope, expected)
})
