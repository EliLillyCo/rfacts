#' @title Engine-specific trial simulation functions
#' @name facts_engines
#' @seealso [run_engine()], [get_facts_file_example()],
#'   [get_facts_engine()], [run_facts()], [run_flfll()].
#' @description These functions are the inner functions called by
#'   [run_engine()]. In this help file, only the most common engine functions
#'   are listed. To identify the appropriate engine function
#'   for your FACTS file, call [get_facts_engine()].
#'  - [run_engine_aipf_contin()]: Enrichment continuous.
#'  - [run_engine_aipf_dichot()]: Enrichment dichotomous.
#'  - [run_engine_aipf_tte()]: Enrichment time to event.
#'  - [run_engine_contin()]: Core continuous.
#'  - [run_engine_crm()]: continual reassessment method (CRM).
#'  - [run_engine_dichot()]: Core dichotomous.
#'  - [run_engine_multep()]: Multiple endpoint.
#'  - [run_engine_tte()]: Time to event.
#' @details If you need to repeatedly invoke an engine, as with most
#'   trial execution mode workflows, these engine functions may be slow
#'   on their own. To avoid the most severe sources of slowness,
#'   consider running [prep_param_files()]
#'   and then passing the result to one of the individual engine
#'   functions (such as [run_engine_contin()]).
#' @return Nothing.
#' @param param_files Character vector of file paths or the output
#'   of [prep_param_files()]. If a character vector, the elements
#'   can be directories containing `*.param` files or the paths to the
#'   `*.param` files themselves.
#'   Such a directory is returned by [run_flfll()].
#' @param n_sims Positive integer, number of simulations per param file.
#' @param mode Character scalar: `"s"` for simulation mode in non-enrichment
#'   designs, `""` for simulation mode in enrichment designs,
#'   `"r"` for execution mode, and `"p"` for prediction mode.
#'   For the CRM engine, `mode` needs to be `"s"` or `""`.
#' @param seed Positive integer, random number generator seed for the
#'   actual trial simulations. Use this `seed` argument instead of
#'   `flfll_seed` ([run_facts()], [run_flfll()]) to control
#'   pseudo-randomness in the actual trial simulations. `flfll_seed`
#'   only controls how the `*.param` files are generated.
#' @param analysis_data Character, analysis mode patient data file name.
#' @param analysis_mode Logical, whether to activate analysis mode.
#' @param arm_selection Logical, whether to activate arm selection.
#' @param armsdropped Character, a comma-separated collection of integers
#'   indicating dropped arms.
#' @param complete_data_analysis Logical, whether to do a complete
#'   data analysis.
#' @param current_week Numeric, current time in weeks.
#' @param execdata Character, name of the execution mode patient file.
#' @param final Logical, whether to do the final analysis.
#'   For execution mode only.
#' @param fsimdata Character, prediction mode patient data file name.
#' @param fsimexp Logical. For expert use only.
#' @param fsimparam Character, name of the prediction mode `*.param` file.
#' @param interim Integer, interim number.
#' @param keepfiles Logical, whether to deactivate cleanup of
#'   extraneous staged design files.
#' @param mcmc_num Integer, MCMC file number. For analysis mode only.
#' @param noadapt Logical, whether to deactivate adaptive actions
#'   in prediction mode.
#' @param s2_aux_paramfile Character, name of the stage 2 execution
#'   auxiliary `*.param` file.
#' @param stage Integer, trial design stage. For staged designs only.
#' @param allocator Logical, allocator/execution/recommender mode. CRM only.
#' @param charting_info Logical, unused.
#' @param estimator Logical, use estimator. CRM only.
#' @param directory Character, working directory. CRM only.
#' @param force_cohort Logical, whether to force small cohort run-in to end.
#'   CRM only.
#' @param reduced_priority Logical, whether to run at reduced priority.
#'   CRM only.
#' @param verbose Logical, whether to print progress information to the R
#'   console.
#' @param version Character scalar, version of FACTS corresponding to the
#'   FACTS file. Get by calling [get_facts_version()] on your FACTS file.
#'   See possible versions with [get_facts_versions()].
#'   Do not supply `version` to [run_engine()]. [run_engine()]
#'   detects the version automatically from the FACTS file and
#'   passes it to the appropriate engine function.
#' @examples
#' facts_file <- get_facts_file_example("contin.facts")
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' out <- run_flfll(facts_file, verbose = FALSE) # Generate param files.
#' # Identify which engine you need.
#' get_facts_engine(facts_file)
#' # Run the sims with the engine function or `run_engine()`.
#' run_engine_contin(out, n_sims = 1, verbose = FALSE, version = "6.2.5")
#' read_patients(out)
#' }
NULL
