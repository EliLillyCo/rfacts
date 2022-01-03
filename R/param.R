#' @title List the paths to the param files
#' @description List the paths to the all the param files
#'   in a directory or directories.
#' @export
#' @return Character vector of paths to param files.
#' @param param_files Character vector of directories containing param files.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts")
#' dir <- run_flfll(facts_file, verbose = FALSE)
#' get_param_files(dir)
#' }
get_param_files <- function(param_files) {
  get_files(param_files, pattern = pattern_param)
}

#' @title List the directories containing param files
#' @export
#' @seealso [get_facts_scenarios()], [run_facts()], [run_flfll()],
#'   [run_engine()], [run_engine_contin()]
#' @description Get the directory paths containing param files.
#'   This helps us run FACTS simulation scenarios one at a time.
#' @details When you run [run_flfll()] or [run_facts()], `rfacts`
#'   creates a directory. This directory has a bunch of
#'   subdirectories, each corresponding to a single simulation scenario
#'   (VSR profile x accrual profile x dropout profile, etc).
#' @return Character vector of FACTS simulation scenario directories.
#' @param param_files Character, path to a top-level
#'   directory containing param files. [run_flfll()] and [run_facts()]
#'   return paths you can supply to `param_files` in `get_param_dirs()`.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts")
#' param_files <- run_flfll(facts_file, verbose = FALSE)
#' scenarios <- get_param_dirs(param_files)
#' scenarios
#' scenario <- scenarios[1]
#' run_engine_contin(scenario, n_sims = 2, verbose = FALSE, version = "6.2.5")
#' read_patients(scenario)
#' }
get_param_dirs <- function(param_files) {
  out <- list.files(
    param_files,
    pattern = pattern_param,
    recursive = TRUE,
    full.names = TRUE
  )
  unique(dirname(out))
}
