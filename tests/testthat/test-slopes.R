test_that("cp_slopes returns all, treated, and control slopes", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  tau <- 1 + 5 * e + c(0.01, -0.03, 0.03, -0.01)
  df <- data.frame(
    ehat = rep(e, 2),
    tau = rep(tau, 2),
    z = rep(c(0, 1), each = 4)
  )
  out <- cp_slopes(df, ehat = "ehat", tau_hat = "tau", treat = "z")
  expect_equal(out$fit, c("All units", "Treated units", "Control units"))
  expect_true(all(abs(out$slope - 5) < 1e-8))
})

test_that("local_cp_slopes uses positive complier weights", {
  e <- c(0.2, 0.4, 0.6, 0.8)
  tau_c <- 1 + 5 * e + c(0.01, -0.03, 0.03, -0.01)
  df <- data.frame(
    ehat = rep(e, 2),
    tau_c = rep(tau_c, 2),
    pi_c = c(1, 1, 1, 1, 2, 2, 2, 2),
    z = rep(c(0, 1), each = 4)
  )
  out <- local_cp_slopes(df, ehat = "ehat", tau_c_hat = "tau_c", pi_c_hat = "pi_c", group = "z")
  expect_equal(out$fit, c("All units", "Treated units", "Control units"))
  expect_true(all(out$n == c(8L, 4L, 4L)))
  expect_true(all(abs(out$slope - 5) < 1e-8))
})
