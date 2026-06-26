\name{cp_plot}
\alias{cp_plot}
\title{Draw a CP plot}
\usage{
cp_plot(data, ehat, tau_hat, treat = NULL,
  point_labels = c("Control", "Treated"),
  title = NULL, alpha = 0.45, point_size = 1)
}
\arguments{
\item{data}{A data frame.}
\item{ehat}{Character name of the estimated propensity-score column.}
\item{tau_hat}{Character name of the estimated CATE column.}
\item{treat}{Optional character name of a 0/1 treatment indicator column.}
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
Draws a diagnostic plot of estimated CATEs against estimated propensity scores
and adds full-sample linear fits with weights \eqn{1}, \eqn{\hat e(X)}, and
\eqn{1-\hat e(X)}. When \code{treat} is supplied, it controls the point shapes
but not the regression samples.
}
