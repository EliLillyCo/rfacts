#' @export
#' @rdname facts_engines
run_engine_aipf_dichot <- function(
  param_files,
  n_sims = 1L,
  mode = c("", "r"),
  seed = NULL,
  analysis_data = NULL,
  analysis_mode = NULL,
  current_week = NULL,
  execdata = NULL,
  final = NULL,
  interim = NULL,
  mcmc_num = NULL,
  verbose = FALSE,
  version = NULL
) {
  run_engine_common_impl(
    param_files = param_files,
    n_sims = n_sims,
    mode = match.arg(mode),
    seed = seed,
    analysis_data = analysis_data,
    analysis_mode = analysis_mode,
    current_week = current_week,
    execdata = execdata,
    final = final,
    interim = interim,
    mcmc_num = mcmc_num,
    verbose = verbose,
    set = "AIPFParameterSet",
    type = "2",
    version = version
  )
}
