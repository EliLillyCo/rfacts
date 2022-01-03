#' rfacts: interface to FACTS on Unix-like systems
#' @docType package
#' @description Call FACTS from R.
#' @name rfacts-package
#' @aliases rfacts
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts") # example FACTS file
#' out <- run_facts(
#'   facts_file,
#'   n_sims = 4,
#'   verbose = FALSE
#' )
#' # What results files do we have?
#' head(get_csv_files(out))
#' # Read all the "patients*.csv" files with `read_patients(out)`.
#' # For each scenario, we have files named
#' # patients00001.csv, patients00002.csv, patients00003.csv,
#' # and patients00004.csv.
#' read_patients(out)
#' }
#' @importFrom digest digest
#' @importFrom fs dir_create
#' @importFrom tibble as_tibble tibble
#' @importFrom utils compareVersion read.table write.table
#' @importFrom xml2 as_list read_xml write_xml xml_find_first xml_child
#'   xml_children xml_find_first xml_text
NULL
