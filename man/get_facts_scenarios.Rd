% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_facts.R
\name{get_facts_scenarios}
\alias{get_facts_scenarios}
\title{List the names of simulation scenarios}
\usage{
get_facts_scenarios(facts_file, verbose = FALSE)
}
\arguments{
\item{facts_file}{Character, name of a FACTS file.
Usually has a \verb{*.facts} file extension.}

\item{verbose}{Logical, whether to print progress to the R console.}
}
\value{
Character vector of FACTS simulation scenarios.
}
\description{
Get the names of the simulation scenarios of a FACTS file.
without actually running any simulations.
These names usually come from the virtual subject response (VSR)
scenarios, the accrual profiles, and the dropout profiles.
}
\examples{
# Can only run if system dependencies are configured:
if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
facts_file <- get_facts_file_example("contin.facts")
get_facts_scenarios(facts_file)
}
}
\seealso{
\code{\link[=get_param_dirs]{get_param_dirs()}}, \code{\link[=run_facts]{run_facts()}}, \code{\link[=run_flfll]{run_flfll()}},
\code{\link[=run_engine]{run_engine()}}, \code{\link[=run_engine_contin]{run_engine_contin()}}
}
