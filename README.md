# causalcp

`causalcp` draws CP plots and local CP plots for causal diagnostic summaries.
It is developed for the paper "Bracketing Relationships of Weighted Average
Treatment Effects" by Pengfei Tian, Fan Yang, and Peng Ding
([arXiv:2606.11715](https://arxiv.org/abs/2606.11715)).

The core functions assume that users have already estimated propensity scores
and conditional treatment effects:

```r
fit <- cp_plot(df, ehat = "ehat", tau_hat = "tau_hat", treat = "z")
fit$plot
fit$slopes
```

For IV settings:

```r
fit <- local_cp_plot(
  df,
  ehat = "ehat",
  tau_c_hat = "tau_c_hat",
  pi_c_hat = "delta_d",
  group = "z"
)
fit$plot
fit$slopes
```
