% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep_param_files.R
\name{prep_param_files}
\alias{prep_param_files}
\title{Arrange the param files for the engines ahead of time.}
\usage{
prep_param_files(param_files)
}
\arguments{
\item{param_files}{A character vector of param files and/or directories
containing param files.}
}
\value{
A list of special \code{"params_files"} objects
that the engine functions can process fast.
}
\description{
If you call \code{prep_param_files()} ahead of time, subsequent calls
to the engines will initialize much faster. This is useful in situations
like trial execution mode, which require calling an engine function
on each new simulation. This function does not actually modify
the param files themselves on disk.
}
\details{
\code{prep_param_files()} searches for the required \verb{*.param} files
groups them by directory, sorts them, and returns the result
as a list of special \code{param_files} objects.
(It does not modify the actual contents of the \verb{*.param`` files.) This preprocessing step is fast when executed once, but slow when executed thousands of times. So if you need to call a }run_engine_*()\verb{function repeatedly, consider passing it an object from}prep_param_files()`.
}
\examples{
# Can only run if system dependencies are configured:
if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
facts_file <- get_facts_file_example("contin.facts")
out <- run_flfll(facts_file, verbose = FALSE)
param_files <- prep_param_files(out) # For speed.
param_files # Shows where the param files live and how they are organized.
run_engine_contin(
  param_files,
  n_sims = 2,
  verbose = FALSE,
  version = "6.2.5"
)
# Slower: run_engine_contin(out, n_sims = 2, verbose = FALSE) # nolint
}
}
\seealso{
\code{\link[=run_flfll]{run_flfll()}}, \code{\link[=run_engine]{run_engine()}}, \code{\link[=run_engine_contin]{run_engine_contin()}}
}
