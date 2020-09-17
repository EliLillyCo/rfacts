run_param_files <- function(param_files, engine_path, args, verbose) {
  UseMethod("run_param_files")
}

run_param_files.character <- function(
  param_files,
  engine_path,
  args,
  verbose
) {
  param_files <- new_param_file_list(param_files)
  lapply(
    param_files,
    run_param_dir,
    engine_path = engine_path,
    args = args,
    verbose = verbose
  )
}

run_param_files.param_files <- function(
  param_files,
  engine_path,
  args,
  verbose
) {
  run_param_dir(
    param_files = param_files,
    engine_path = engine_path,
    args = args,
    verbose = verbose
  )
}

run_param_files.default <- function(
  param_files,
  engine_path,
  args,
  verbose
) {
  lapply(
    param_files,
    run_param_dir,
    engine_path = engine_path,
    args = args,
    verbose = verbose
  )
}

run_param_dir <- function(param_files, engine_path, args, verbose) {
  # Yes, we really do want to change the working directory here.
  old <- setwd(param_files$directory) # nolint
  on.exit(setwd(old)) # nolint
  lapply(
    param_files$files,
    run_param_file,
    engine_path = engine_path,
    args = args,
    verbose = verbose
  )
}

run_param_file <- function(file, engine_path, args, verbose) {
  args[attr(args, "param_file_index")] <- basename(file)
  run_linux(command = engine_path, args = args, verbose = verbose)
}
