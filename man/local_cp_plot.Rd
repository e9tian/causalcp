\name{local_cp_plot}
\alias{local_cp_plot}
\title{Draw a local CP plot}
\usage{
local_cp_plot(data, ehat, tau_c_hat, pi_c_hat, group = NULL,
  point_labels = c("Control", "Treated"),
  title = NULL, alpha = 0.35, point_size = 0.8)
}
\arguments{
\item{data}{A data frame.}
\item{ehat}{Character name of the estimated IV propensity-score column.}
\item{tau_c_hat}{Character name of the estimated conditional complier treatment effect column.}
\item{pi_c_hat}{Character name of the estimated complier score or first-stage column used as weights.}
\item{group}{Optional character name of a 0/1 instrument-group column.}
\item{point_labels}{Two labels for control and treated points.}
\item{title}{Optional plot title.}
\item{alpha}{Point alpha.}
\item{point_size}{Point size.}
}
\value{
A \code{causalcp_result} object with elements \code{plot}, \code{slopes}, and
\code{data_used}.
}
\description{
Draws a diagnostic plot of modeled conditional Wald estimates against estimated
IV propensity scores and adds \code{pi_c_hat}-weighted linear fits.
}
