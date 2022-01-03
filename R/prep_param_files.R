#' @title Arrange the param files for the engines ahead of time.
#' @export
#' @seealso [run_flfll()], [run_engine()], [run_engine_contin()]
#' @description If you call `prep_param_files()` ahead of time, subsequent calls
#'   to the engines will initialize much faster. This is useful in situations
#'   like trial execution mode, which require calling an engine function
#'   on each new simulation. This function does not actually modify
#'   the param files themselves on disk.
#' @details `prep_param_files()` searches for the required `*.param` files
#'   groups them by directory, sorts them, and returns the result
#'   as a list of special `param_files` objects.
#'   (It does not modify the actual contents of the `*.param`` files.)
#'   This preprocessing step is fast when executed once,
#'   but slow when executed thousands of times.
#'   So if you need to call a `run_engine_*()` function repeatedly,
#'   consider passing it an object from `prep_param_files()`.
#' @return A list of special `"params_files"` objects
#'   that the engine functions can process fast.
#' @param param_files A character vector of param files and/or directories
#'   containing param files.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts")
#' out <- run_flfll(facts_file, verbose = FALSE)
#' param_files <- prep_param_files(out) # For speed.
#' param_files # Shows where the param files live and how they are organized.
#' run_engine_contin(
#'   param_files,
#'   n_sims = 2,
#'   verbose = FALSE,
#'   version = "6.2.5"
#' )
#' # Slower: run_engine_contin(out, n_sims = 2, verbose = FALSE) # nolint
#' }
prep_param_files <- function(param_files) {
  new_param_file_list(param_files)
}

new_param_file_list <- function(param_files) {
  param_files <- path.expand(param_files)
  assert_files_exist(param_files)
  params <- find_param_files(param_files)
  dirs <- unique(dirname(params))
  files <- lapply(dirs, get_files_in_dir, pattern = pattern_param)
  if (!length(unlist(files))) {
    stop0("please supply param files or a directory containing some.")
  }
  lapply(
    seq_along(dirs),
    new_param_file_env,
    dirs = dirs,
    files = files
  )
}

find_param_files <- function(param_files) {
  out <- lapply(param_files, get_files_in_dir, pattern = pattern_param)
  unique(unlist(out))
}

new_param_file_env <- function(index, dirs = dirs, files = files) {
  out <- new.env(hash = TRUE, parent = emptyenv(), size = 2L)
  out$directory <- dirs[[index]]
  out$files <- files[[index]]
  class(out) <- c("param_files", class(out))
  lockEnvironment(out, bindings = TRUE)
  out
}

#' @export
print.param_files <- function(x, ...) {
  print(as.list(x))
}
