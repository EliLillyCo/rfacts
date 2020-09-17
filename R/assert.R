assert_good_version <- function(version) {
  if (version >= "6.2.4") {
    return()
  }
  stop0(
    "the version of your FACTS file must be at least 6.2.4. ",
    "Found ", version, "."
  )
}

assert_files_exist <- function(x) {
  assert_vector_character(x)
  stopifnot(file.exists(x))
}

assert_scalar_character <- function(x) {
  assert_scalar(x)
  assert_vector_character(x)
}

assert_vector_character <- function(x) {
  stopifnot(is.character(x))
}

assert_scalar_logical <- function(x) {
  assert_scalar(x)
  stopifnot(is.logical(x))
}

assert_scalar_numeric <- function(x) {
  assert_scalar(x)
  assert_vector_numeric(x)
}

assert_scalar <- function(x) {
  stopifnot(length(x) == 1L)
}

assert_vector_numeric <- function(x) {
  stopifnot(is.numeric(x))
}
