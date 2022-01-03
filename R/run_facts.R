#' @title Run FACTS
#' @export
#' @seealso [run_flfll()], [run_engine()], [get_facts_engine()]
#' @description Run FACTS trial simulations.
#' @details [run_facts()] calls [run_flfll()] and then [run_engine()].
#'   For finer control over trial simulation, you can call these
#'   latter two functions individually.
#' @return Character, path to the directory with FACTS output.
#' @inheritParams run_flfll
#' @inheritParams facts_engines
#' @param ... Named arguments to the appropriate FACTS engine function.
#'   Use [get_facts_engine()] to identify the appropriate
#'   engine function and then open the help file of that function to read
#'   about the arguments, e.g. `?run_engine_contin`.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts") # example FACTS file
#' out <- run_facts(
#'   facts_file,
#'   n_sims = 4,
#'   verbose = FALSE
#' )
#' # What results files do we have?
#' head(get_csv_files(out))
#' # Read all the "patients*.csv" files with `read_patients(out)`.
#' # For each scenario, we have files named
#' # patients00001.csv, patients00002.csv, patients00003.csv,
#' # and patients00004.csv.
#' read_patients(out)
#' }
run_facts <- function(
  facts_file,
  output_path = tempfile(),
  log_path = output_path,
  n_burn = NULL,
  n_mcmc = NULL,
  n_weeks_files = 1e4,
  n_patients_files = 1e4,
  n_mcmc_files = 0,
  n_mcmc_thin = NULL,
  flfll_seed = NULL,
  flfll_offset = NULL,
  n_sims,
  ...
) {
  args <- list(...)
  args$n_sims <- n_sims
  out <- run_flfll(
    facts_file = facts_file,
    output_path = output_path,
    log_path = output_path,
    n_burn = n_burn,
    n_mcmc = n_mcmc,
    n_weeks_files = n_weeks_files,
    n_patients_files = n_patients_files,
    n_mcmc_files = n_mcmc_files,
    n_mcmc_thin = n_mcmc_thin,
    flfll_seed = flfll_seed,
    flfll_offset = flfll_offset,
    max_sims = n_sims,
    verbose = args$verbose %||% FALSE
  )
  args$facts_file <- facts_file
  args$param_files <- out
  do.call(what = run_engine, args = args)
  out
}
