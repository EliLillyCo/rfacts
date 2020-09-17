`%||%` <- function(x, y) {
  if (is.null(x) || length(x) <= 0) {
    y
  }
  else {
    x
  }
}

`%||NA%` <- function(x, y) {
  if (is.null(x) || length(x) <= 0 || anyNA(x)) {
    y
  }
  else {
    x
  }
}

choose_version <- function(version, choices) {
  if (!length(choices)) {
    return(character(0))
  }
  if (!length(version)) {
    return(max(choices))
  }
  if (all(choices > version)) {
    return(min(choices))
  }
  max(choices[choices <= version])
}

first_elt <- function(x) {
  if (length(x)) {
    return(x[[1]])
  }
}

get_files <- function(x, pattern) {
  unique(unlist(lapply(x, get_files_in_dir, pattern = pattern)))
}

get_files_in_dir <- function(x, pattern) {
  if (dir.exists(x)) {
    x <- list.files(
      x,
      pattern = pattern,
      full.names = TRUE,
      recursive = TRUE
    )
  }
  normalizePath(x, mustWork = FALSE)
}

run_linux <- function(command, args, verbose) {
  dest <- ">/dev/null"
  if (verbose) {
    dest <- "" # nocov
  }
  command <- paste(c(command, args, dest), collapse = " ")
  code <- system(command)
  handle_exit_code(code, command)
}

handle_exit_code <- function(code, command) {
  if (code != 0L) {
    stop0(shQuote(command), " failed with exit code ", code)
  }
}

sanitize_paths <- function(x) {
  x <- path.expand(x)
  x <- gsub(" ", "\\\ ", x, fixed = TRUE)
  gsub("\t", "\\\ ", x, fixed = TRUE)
}

pattern_param <- "\\.param$|\\.bcrm$"
pattern_packet <- paste0(pattern_param, "|\\.dat$")

stop0 <- function(...) {
  stop(..., call. = FALSE)
}

warn0 <- function(...) {
  warning(..., call. = FALSE)
}
