#' @title Check configuration of system dependencies
#' @export
#' @seealso rfacts_paths
#' @description Examine the file paths to executables and check
#'   that they exist and have the correct permissions.
#' @inheritSection rfacts_paths Dependencies
#' @return A data frame of information on the status of each executable.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' rfacts_sitrep()
#' }
rfacts_sitrep <- function() {
  ensure_set_rfacts_paths()
  paths <- .rfacts$paths
  exists <- file.exists(paths$path)
  is_executable <- unname(file.access(paths$path, mode = 1L) == 0L)
  tibble::tibble(
    executable_type = paths$executable_type,
    facts_version = paths$facts_version,
    exists = exists,
    is_executable = is_executable,
    path = paths$path
  )
}
