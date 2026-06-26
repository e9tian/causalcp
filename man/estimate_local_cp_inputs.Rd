\name{estimate_local_cp_inputs}
\alias{estimate_local_cp_inputs}
\title{Estimate basic local CP-plot inputs}
\usage{
estimate_local_cp_inputs(data, y, d, z, x,
  family = stats::binomial(), min_first_stage = 1e-6)
}
\arguments{
\item{data}{A data frame.}
\item{y}{Character name of the outcome column.}
\item{d}{Character name of the treatment column.}
\item{z}{Character name of the binary instrument column.}
\item{x}{Character vector of covariate column names.}
\item{family}{Family passed to \code{stats::glm()} for the IV propensity score.}
\item{min_first_stage}{Minimum absolute first stage used before setting the Wald ratio to \code{NA}.}
}
\value{
The input data frame with added \code{ehat}, \code{delta_y}, \code{delta_d},
\code{pi_c_hat}, and \code{tau_c_hat} columns.
}
\description{
Estimates IV propensity scores with \code{glm()} and conditional reduced-form
and first-stage contrasts with simple linear models. This helper is intended
for transparent examples; users can supply estimates from any model to
\code{local_cp_plot()}.
}
