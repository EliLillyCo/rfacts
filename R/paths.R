#' @title Read paths to rfacts system dependencies
#' @export
#' @seealso rfacts_sitrep
#' @description Read the file specified by the `RFACTS_PATHS`
#'   environment variable.
#' @section Dependencies:
#'   `rfacts` has strict system requirements, and the installations
#'   vary from system to system. You need to specify the locations of
#'   system executables in a CSV file that lists the path and metadata
#'   of each executable. This file must have one row per executable
#'   and the following columns.
#'
#'   * `executable_type`: Must be "mono", "flfll", or "engine" to
#'     denote the general type of the executable.
#'   * `facts_version`: The version of FACTS with which this executable
#'     is compatible.
#'   * `path`: File path to the executable.
#'   * `engine_name`: For engines only. Name of the engine.
#'     Must be one of the engine types in the example CSV file at
#'     `system.file("example_paths.csv", package = "rfacts")`.
#'   * `param_set`: For engines only. Parameter set designation listed in the
#'     XML code of FACTS files for that engine. See
#'     `system.file("example_paths.csv", package = "rfacts")`
#'     for examples.
#'   * `param_type`: For engines only. Parameter type designation listed in the
#'     XML code of FACTS files for that engine. See
#'     `system.file("example_paths.csv", package = "rfacts")`
#'     for examples.
#'
#'   When you call a trial simulation function in `rfacts`,
#'   the package automatically reads this file
#'   and memorizes the contents for later use. The file at
#'   `system.file("example_paths.csv", package = "rfacts")`
#'   (`inst/example_paths.csv` in the package source.)
#'   has an example of such a file. All the columns in that file
#'   are required, and you may, remove, or modify rows to fit
#'   your specific system.
#'
#'   To enable `rfacts` to find this CSV file, you need to
#'   set the `RFACTS_PATHS` environment variable to the
#'   path to this file. The easiest way to do this is call
#'   `usethis::edit_r_environ()` to edit your `.Renviron` file
#'   and then add a new line with something like
#'   `RFACTS_PATHS=/path/to/file/paths.csv`. Then,
#'   restart your R session and call `Sys.getenv("RFACTS_PATHS")`
#'   to verify that this environment variable was set correctly.
#'
#'   The `rfacts_sitrep()` function inspects the current system dependency
#'   info and ensures each executable exists and has the correct permissions.
#'
#'   If you change the `RFACTS_PATHS` environment variable,
#'   you need to call [reset_rfacts_paths()] or restart R
#'   for the changes to take effect.
#' @return A data frame with paths and other metadata about `rfacts`
#'   system dependencies
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' rfacts_paths()
#' }
rfacts_paths <- function() {
  ensure_set_rfacts_paths()
  tibble::as_tibble(.rfacts$paths)
}

#' @title Reset system dependency info
#' @export
#' @seealso rfacts_paths, rfacts_sitrep
#' @description Reset system dependency information
#'   based on the current value of the `RFACTS_PATHS`
#'   environment variable.
#' @inheritSection rfacts_paths Dependencies
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' reset_rfacts_paths()
#' }
reset_rfacts_paths <- function() {
  set_rfacts_paths()
  invisible()
}

set_rfacts_paths <- function() {
  .rfacts$paths <- read_paths()
  .rfacts$paths_set <- TRUE
}

ensure_set_rfacts_paths <- function() {
  if (!.rfacts$paths_set) {
    set_rfacts_paths()
  }
}

paths_engine <- function() {
  ensure_set_rfacts_paths()
  paths <- .rfacts$paths
  paths[paths$executable_type == "engine", ]
}

paths_flfll <- function() {
  ensure_set_rfacts_paths()
  paths <- .rfacts$paths
  paths[paths$executable_type == "flfll", ]
}

paths_mono <- function() {
  ensure_set_rfacts_paths()
  paths <- .rfacts$paths
  paths[paths$executable_type == "mono", ]
}

read_paths <- function() {
  assert_rfacts_paths()
  out <- utils::read.table(
    file = Sys.getenv("RFACTS_PATHS"),
    sep = ",",
    strip.white = TRUE,
    header = TRUE,
    stringsAsFactors = FALSE
  )
  assert_paths_df(out)
  for (field in colnames(out)) {
    out[[field]] <- as.character(out[[field]])
  }
  out
}

assert_rfacts_paths <- function() {
  path <- Sys.getenv("RFACTS_PATHS")
  if (!file.exists(path)) {
    stop0(rfacts_paths_msg(path))
  }
}

rfacts_paths_msg <- function(path) {
  c(
    "The file path ",
    shQuote(path),
    " does not exist.",
    "Set the RFACTS_PATHS environment variable ",
    "to a valid path. See the configuration guide at ",
    "https://elilillyco.github.io/rfacts/articles/config.html ",
    "for detailed instructions."
  )
}

assert_paths_df <- function(paths) {
  cols <- c(
    "executable_type",
    "facts_version",
    "path",
    "engine_name",
    "param_set",
    "param_type"
  )
  lapply(cols, assert_paths_col, paths = paths)
  assert_executable_type(paths)
}

assert_executable_type <- function(paths) {
  out <- unname(sort(unique(paths$executable_type)))
  exp <- unname(sort(unique(c("mono", "flfll", "engine"))))
  if (!identical(out, exp)) {
    stop0(
      "in the file at RFACTS_PATHS, the executable_type column ",
      "must have entries for each of 'mono', 'flfll', and 'engine' ",
      "and no other values."
    )
  }
}

assert_paths_col <- function(col, paths) {
  if (is.null(paths[[col]])) {
    stop0(
      "required column ",
      col,
      " in the RFACTS_PATHS file is missing."
    )
  }
}

.rfacts <- new.env(parent = emptyenv())
.rfacts$paths_set <- FALSE
