\name{causalcp_result}
\alias{causalcp_result}
\alias{print.causalcp_result}
\title{Causal CP result object}
\usage{
\method{print}{causalcp_result}(x, ...)
}
\arguments{
\item{x}{A \code{causalcp_result} object.}
\item{...}{Unused.}
}
\value{
The input object, invisibly.
}
\description{
Objects returned by \code{cp_plot()} and \code{local_cp_plot()} contain a
\code{ggplot} object, slope summaries, and the filtered plotting data.
}
