arg_path <- function(flag, arg) {
  if (is.null(arg)) {
    return(character(0))
  }
  arg <- sanitize_paths(x = arg)
  arg_character(flag = flag, arg = arg)
}

arg_character <- function(flag, arg) {
  if (is.null(arg)) {
    return(character(0))
  }
  assert_scalar_character(arg)
  c(flag, arg)
}

arg_logical <- function(flag, arg) {
  if (is.null(arg)) {
    return(character(0))
  }
  assert_scalar_logical(arg)
  if (identical(arg, FALSE)) {
    return(character(0))
  }
  flag
}

arg_numeric <- function(flag, arg) {
  if (is.null(arg)) {
    return(character(0))
  }
  assert_scalar_numeric(arg)
  c(flag, as.character(arg))
}

arg_integer <- function(flag, arg) {
  if (is.null(arg)) {
    return(character(0))
  }
  assert_scalar_numeric(arg)
  c(flag, as.character(as.integer(arg)))
}

arg_integer_csv <- function(flag, arg) {
  if (is.null(arg)) {
    return(character(0))
  }
  assert_vector_numeric(arg)
  arg <- as.integer(arg)
  arg <- paste(arg, collapse = ",")
  c(flag, as.character(arg))
}
