% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_engine.R
\name{run_engine}
\alias{run_engine}
\title{Run trial simulations}
\usage{
run_engine(facts_file, ...)
}
\arguments{
\item{facts_file}{Character, name of a FACTS file.
Usually has a \verb{*.facts} file extension.}

\item{...}{Named arguments to the appropriate inner engine function,
such as \code{\link[=run_engine_contin]{run_engine_contin()}}. Use \code{\link[=get_facts_engine]{get_facts_engine()}}
to identify the appropriate engine function for your FACTS file.
Then, open the help file of that function to read about the arguments.}
}
\value{
Nothing.
}
\description{
For fine control over trial simulations,
you must first call \code{\link[=run_flfll]{run_flfll()}} and then call either \code{\link[=run_engine]{run_engine()}}
or one of the specific engine functions (such as \code{\link[=run_engine_contin]{run_engine_contin()}}).
The engines read the \verb{*.param} files generated by
\code{\link[=run_flfll]{run_flfll()}}, run the trial simulations, and save output
to a bunch of CSV files. You can find these CSV output files next to
the \verb{*.param} files.
}
\details{
If you need to repeatedly invoke an engine, as with most
trial execution mode workflows, \code{\link[=run_engine]{run_engine()}} is slow.
Instead, consider running \code{\link[=prep_param_files]{prep_param_files()}}
and then passing the result to one of the individual engine
functions (such as \code{\link[=run_engine_contin]{run_engine_contin()}}).
}
\examples{
# Can only run if system dependencies are configured:
if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
facts_file <- get_facts_file_example("contin.facts") # example FACTS file
out <- run_flfll(facts_file, verbose = FALSE) # Generate param files.
# Run the simulations.
run_engine(
  facts_file,
  param_files = out,
  n_sims = 1,
  verbose = FALSE
)
read_patients(out)
}
}
\seealso{
\code{\link[=get_facts_file_example]{get_facts_file_example()}}, \code{\link[=run_flfll]{run_flfll()}},
\code{\link[=get_facts_engine]{get_facts_engine()}}, \code{\link[=prep_param_files]{prep_param_files()}}
}
