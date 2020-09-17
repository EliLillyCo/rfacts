run_engine_common_impl <- function(
  param_files,
  n_sims,
  mode,
  seed,
  analysis_data = NULL,
  analysis_mode = NULL,
  arm_selection = NULL,
  armsdropped = NULL,
  complete_data_analysis = NULL,
  current_week = NULL,
  execdata = NULL,
  final = NULL,
  fsimdata = NULL,
  fsimexp = NULL,
  fsimparam = NULL,
  interim = NULL,
  keepfiles = NULL,
  mcmc_num = NULL,
  noadapt = NULL,
  s2_aux_paramfile = NULL,
  stage = NULL,
  verbose,
  set,
  type,
  version
) {
  engine_path <- get_engine_impl(
    set = set,
    type = type,
    version = version,
    field = "path"
  )
  args <- c(
    mode,
    arg_character("f", "{{param_file}}"), # placeholder for param file
    arg_integer("n", n_sims),
    arg_integer("--seed", seed),
    arg_path("--analysis-data", analysis_data),
    arg_logical("--analysis-mode", analysis_mode),
    arg_logical("--arm-selection", arm_selection),
    arg_integer_csv("--armsdropped", armsdropped),
    arg_logical("--complete-data-analysis", complete_data_analysis),
    arg_numeric("--current-week", current_week),
    arg_path("--execdata", execdata),
    arg_logical("--final", final),
    arg_path("--fsimdata", fsimdata),
    arg_logical("--fsimexp", fsimexp),
    arg_path("--fsimparam", fsimparam),
    arg_integer("--interim", interim),
    arg_logical("--keepfiles", keepfiles),
    arg_integer("--mcmc-num", mcmc_num),
    arg_logical("--noadapt", noadapt),
    arg_path("--s2-aux-paramfile", s2_aux_paramfile),
    arg_integer("--stage", stage)
  )
  attr(args, "param_file_index") <- 3 # faster than replacing {{param_file}}
  run_param_files(
    param_files = param_files,
    engine_path = engine_path,
    args = args,
    verbose = verbose
  )
  invisible()
}
