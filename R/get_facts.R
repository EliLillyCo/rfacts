#' @title Locate an example FACTS file
#' @export
#' @seealso [run_facts()], [run_flfll()], [run_engine()], [run_engine_contin()]
#' @description Get the path to an example FACTS file inside rfacts itself.
#' @details The `rfacts` package comes with some example FACTS files.
#'   Use the `get_facts_file_example()` function to get the full path
#'   to an example FACTS file. Use this file to try out [run_flfll()],
#'   [run_engine_contin()], etc.
#' @return Character, the path to a FACTS file included with `rfacts`.
#' @param facts_file Character, name of a FACTS file.
#'   Usually has a `*.facts` file extension.
#'   Does not include the directory name.
#'   Possible choices:
#'   - "aipf_contin.facts" - Enrichment continuous.
#'   - "aipf_dichot.facts" - Enrichment dichotomous.
#'   - "aipf_tte.facts" - Enrichment time to event.
#'   - "broken.facts" - A broken FACTS file.
#'   - "contin.facts" - Core continuous.
#'   - "crm.facts" - N-CRM design.
#'   - "dichot.facts" - Core dichotomous.
#'   - "multep.facts" - Multiple endpoints.
#'   - "staged.facts" - Staged design.
#'   - "tte.facts" - Time to event.
#'   - "unsupported.facts" - FACTS file with an unsupported engine type.
#' @examples
#' # Only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts")
#' facts_file
#' out <- run_facts(
#'   facts_file,
#'   n_sims = 1,
#'   verbose = FALSE
#' )
#' read_patients(out)
#' }
get_facts_file_example <- function(facts_file) {
  path <- file.path("facts", facts_file)
  system.file(path, package = "rfacts", mustWork = TRUE)
}

#' @title List the names of simulation scenarios
#' @export
#' @seealso [get_param_dirs()], [run_facts()], [run_flfll()],
#'   [run_engine()], [run_engine_contin()]
#' @description Get the names of the simulation scenarios of a FACTS file.
#'   without actually running any simulations.
#'   These names usually come from the virtual subject response (VSR)
#'   scenarios, the accrual profiles, and the dropout profiles.
#' @return Character vector of FACTS simulation scenarios.
#' @inheritParams get_facts_version
#' @param verbose Logical, whether to print progress to the R console.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts")
#' get_facts_scenarios(facts_file)
#' }
get_facts_scenarios <- function(facts_file, verbose = FALSE) {
  out <- tempfile()
  run_flfll(facts_file, output_path = out, verbose = verbose)
  sans_ext <- sub("[.][^.]*$", "", basename(facts_file), perl = TRUE)
  out <- file.path(out, sans_ext)
  out <- list.dirs(out, recursive = FALSE)
  out <- basename(out)
  gsub(out, pattern = "_params$", replacement = "")
}

#' @title List supported FACTS versions
#' @export
#' @seealso [get_facts_version()], [run_engine_contin()]
#' @description List versions of FACTS supported by `rfacts`.
#'   You can supply any of these versions to functions engine-specific
#'   functions such as [run_engine_contin()].
#' @details If your FACTS file does not perfectly agree
#'   with one of the supported versions, `rfacts` will try to find
#'   the best version for you, either
#'   1. The greatest supported version less than or equal to the
#'   one in the FACTS file, or
#'   2. The lowest supported version if (1) does not exist.
#' @return A character vector of supported FACTS versions.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' get_facts_versions()
#' }
get_facts_versions <- function() {
  sort(unique(facts_versions()), decreasing = TRUE)
}

facts_versions <- function() {
  paths_engine()$facts_version
}

get_mono_flfll_paths <- function(facts_file, version) {
  mono <- get_path_version(paths_mono(), version, "path")
  flfll <- get_path_version(paths_flfll(), version, "path")
  list(mono = mono, flfll = flfll)
}

get_path_version <- function(paths, version, field) {
  versions <- paths$facts_version
  index <- versions == choose_version(version, versions)
  out <- paths[index,, drop = FALSE] # nolint
  first_elt(out[[field]])
}

#' @title Get the FACTS engine function matching your FACTS file
#' @export
#' @seealso [run_facts()], [run_engine()]
#' @description Identify the correct `run_engine_*()` function
#'   for your FACTS file.
#' @details For most cases, it is sufficient to call [run_facts()],
#'   or to call [run_flfll()] followed by [run_engine()]. But either way,
#'   you will need to know the arguments of the `run_engine_*()` function
#'   that corresponds to your FACTS file. Even if you are not calling this
#'   `run_engine_*()` directly, you will need to pass the arguments to `...`
#'   in [run_facts()] or [run_engine()]. `get_facts_engine()`
#'   identifies the correct `run_engine_*()` function so you can open the
#'   help file and read about the arguments, e.g. `?run_engine_contin`.
#' @return Character, the name of a FACTS engine function.
#' @inheritParams get_facts_version
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts")
#' out <- run_flfll(facts_file, verbose = FALSE) # Generate param files.
#' # Find the appropriate FACTS engine function.
#' get_facts_engine(facts_file)
#' # Read about the function arguments.
#' # You can pass these arguments to `...` in `run_facts()`
#' # or `run_engine()` or just call `run_engine_contin()` directly.
#' # ?run_engine_contin
#' # Call the FACTS engine function to run simulations.
#' # Alternatively, you could just call `run_engine()`.
#' run_engine_contin(out, n_sims = 1, verbose = FALSE, version = "6.2.5")
#' # See the results.
#' read_patients(out)
#' }
get_facts_engine <- function(facts_file) {
  name <- get_engine_name(facts_file)
  method <- utils::getS3method("run_engine_impl", class = name)
  grep("^run_engine_", all.names(body(method)), value = TRUE)
}

get_engine_name <- function(facts_file) {
  get_engine_field(facts_file = facts_file, field = "engine_name")
}

get_engine_path <- function(facts_file) {
  get_engine_field(facts_file = facts_file, field = "path")
}

get_engine_field <- function(facts_file, field) {
  set <- get_facts_param_set(facts_file)
  type <- get_facts_param_type(facts_file)
  version <- get_facts_version(facts_file)
  get_engine_impl(
    set = set,
    type = type,
    version = version,
    field = field
  )
}

get_engine_impl <- function(set, type, version, field) {
  db_engines <- paths_engine()
  index <- db_engines$param_set == set &
    db_engines$param_type == as.character(type)
  versions <- facts_versions()
  version <- choose_version(version, versions[index])
  index <- index & versions == version
  engine <- db_engines[[field]][index]
  engine <- first_elt(engine)
  if (!length(engine)) {
    stop0(
      "could not find FACTS engine compatible with set ",
      set, " type ", type, " version ", version
    )
  }
  engine
}

get_facts_param_set <- function(facts_file) {
  out <- facts_xml(facts_file)
  out <- xml2::xml_find_first(out, "//parameterSets/@type")
  xml2::xml_text(out)
}

get_facts_param_type <- function(facts_file) {
  out <- facts_xml(facts_file)
  out <- xml2::xml_find_first(out, "//property[@name='type']")
  out <- xml2::xml_text(out)
  out %||NA% "0"
}

#' @title Get FACTS version matching your FACTS file
#' @export
#' @seealso [get_facts_versions()]
#' @description Get the version of FACTS compatible with
#'   your `*.facts` file.
#' @return A version string.
#' @param facts_file Character, name of a FACTS file.
#'   Usually has a `*.facts` file extension.
#' @examples
#' facts_file <- get_facts_file_example("contin.facts")
#' facts_file
#' get_facts_version(facts_file)
get_facts_version <- function(facts_file) {
  out <- facts_xml(facts_file)
  out <- xml2::xml_find_first(out, "//facts/@version")
  xml2::xml_text(out)
}

facts_xml <- function(facts_file) {
  if (is.character(facts_file)) {
    return(xml2::read_xml(facts_file))
  }
  facts_file
}
