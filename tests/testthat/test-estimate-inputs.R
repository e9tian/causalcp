test_that("estimate_cp_inputs returns ehat and tau_hat", {
  set.seed(1)
  n <- 80
  df <- data.frame(x = rnorm(n))
  df$z <- rbinom(n, 1, plogis(df$x))
  df$y <- 1 + df$x + df$z * (0.5 + df$x) + rnorm(n, sd = 0.1)
  out <- estimate_cp_inputs(df, y = "y", z = "z", x = "x")
  expect_true(all(c("ehat", "tau_hat") %in% names(out)))
  expect_equal(nrow(out), n)
  expect_true(all(is.finite(out$ehat)))
  expect_true(all(is.finite(out$tau_hat)))
})

test_that("estimate_local_cp_inputs returns local IV plotting inputs", {
  set.seed(2)
  n <- 100
  df <- data.frame(x = rnorm(n))
  df$z <- rbinom(n, 1, plogis(df$x))
  df$d <- rbinom(n, 1, plogis(-0.2 + 0.8 * df$z + 0.2 * df$x))
  df$y <- 1 + df$x + 2 * df$d + rnorm(n, sd = 0.1)
  out <- estimate_local_cp_inputs(df, y = "y", d = "d", z = "z", x = "x")
  expect_true(all(c("ehat", "delta_y", "delta_d", "tau_c_hat", "pi_c_hat") %in% names(out)))
  expect_equal(nrow(out), n)
})
