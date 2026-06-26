\name{estimate_cp_inputs}
\alias{estimate_cp_inputs}
\title{Estimate basic CP-plot inputs}
\usage{
estimate_cp_inputs(data, y, z, x, family = stats::binomial())
}
\arguments{
\item{data}{A data frame.}
\item{y}{Character name of the outcome column.}
\item{z}{Character name of the binary treatment column.}
\item{x}{Character vector of covariate column names.}
\item{family}{Family passed to \code{stats::glm()} for the propensity score.}
}
\value{
The input data frame with added \code{ehat} and \code{tau_hat} columns.
}
\description{
Estimates propensity scores with \code{glm()} and CATEs with a simple
two-model linear-regression outcome contrast. This helper is intended for
transparent examples; users can supply estimates from any model to
\code{cp_plot()}.
}
