#' @export
#' @rdname facts_engines
run_engine_crm <- function(
  param_files,
  n_sims = 1L,
  mode = c("s", ""),
  directory = ".",
  allocator = NULL,
  charting_info = NULL,
  estimator = NULL,
  force_cohort = NULL,
  reduced_priority = NULL,
  version = NULL,
  verbose = FALSE
) {
  engine_path <- get_engine_impl(
    set = "CRMDesignParamSet",
    type = "0",
    version = version,
    field = "path"
  )
  mode <- match.arg(mode)
  args <- c(
    arg_character("d", directory),
    mode,
    arg_logical("a", allocator),
    arg_logical("c", charting_info),
    arg_logical("e", estimator),
    arg_logical("f", force_cohort),
    arg_logical("n", reduced_priority),
    arg_integer(character(0), n_sims)
  )
  run_param_files(
    param_files = param_files,
    engine_path = engine_path,
    args = args,
    verbose = verbose
  )
  invisible()
}
