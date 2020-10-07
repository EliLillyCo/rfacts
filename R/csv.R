#' @title Read trial simulation results
#' @name facts_results
#' @seealso [get_facts_file_example()], [run_facts()], [run_flfll()],
#'   [run_engine()]
#' @description These functions read trial simulation results. The results were
#'   computed by FACTS (via [run_facts()] or [run_engine()] or
#'   one of the engine functions such as [run_engine_contin()])
#'   and are stored in CSV files. Different functions read different types
#'   of output. The functions are named according to the CSV files they read.
#'   For example, `read_patients()` reads all files named
#'   `patients00001.csv`, `patients00002.csv`, etc. The most important
#'   functions are `read_patients()` and `read_weeks()`.
#'   The `read_s1*()`, `read_s2*()`, and `read_master*()` functions
#'   are for staged designs. The `read_csv_special()` function allows you to
#'   supply a custom file name prefix such as "patients",
#'   but be warned: not every kind of CSV output file is tested in `rfacts`.
#' @return A data frame of trial simulation data. Each `read_*()` function
#'   returns different information, but all the `read_*()` functions
#'   support the following columns:
#' - `facts_file`: character, the base name of the FACTS file.
#' - `facts_scenario`: character, the name of the simulation scenario
#'   from FACTS. Usually, this factors in the virtual subject response
#'   (VSR) profile, accrual profile (how fast do patients enroll?)
#'   and dropout profile (how fast do they drop out?).
#' - `facts_sim`: integer, numeric index of the CSV file name. For example,
#'   the `facts_sim` of `patients00012.csv` is `12`. In trial execution mode,
#'   all these indices are 00000, so `facts_id` is much
#'   safer than `facts_sim` for packetized trial execution mode.
#' - `facts_id`: character, random unique id of each CSV file being read.
#'   Different for every call to `read_patients()` etc.
#'   Safer than `facts_sim` for aggregation over simulations.
#' - `facts_output`: character, type of output is in the data frame:
#'   `"patients"` for patients files, `"weeks"` for weeks files,
#'   `"mcmc"` for MCMC files, etc. These names adhere to established
#'   conventions in FACTS.
#' - `facts_csv`: character, full path to the original CSV files where
#'   FACTS stored the simulation output. Required for [overwrite_csv_files()].
#' - `facts_header`: a character vector of `\n`-delimited CSV file headers.
#'   Required for [overwrite_csv_files()].
#' @param csv_files Character vector of file paths.
#'   Either the directories containing the trial simulation
#'   results or the actual CSV file files themselves.
#' @param prefix Character, name of the prefix for `read_csv_special()`.
#'   `read_weeks(x)` is equivalent to `read_csv_special(x, prefix = "weeks")`.
#'   Be careful: not all kinds of CSV output are tested. We can only
#'   guarantee the file types with special functions will be read
#'   correctly, e.g. `read_patients()` and `read_weeks()`.
#' @param numbered Logical. If `TRUE`,
#'   only read the numbered files like `patients00001.csv`,
#'   `weeks00017.csv`, etc. If `FALSE`, only list the non-numbered files
#'   like `simulations.csv` and `simulations_freq_locf.csv`.
#'   Avoid `summary.csv` files. They are not reliable on Linux.
#' @examples
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' facts_file <- get_facts_file_example("contin.facts")
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
NULL

#' @export
#' @rdname facts_results
read_patients <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "patients")
}

#' @export
#' @rdname facts_results
read_weeks <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "weeks")
}

#' @export
#' @rdname facts_results
read_mcmc <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "mcmc")
}

#' @export
#' @rdname facts_results
read_s1_mcmc <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-mcmc")
}

#' @export
#' @rdname facts_results
read_s1_weeks <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-weeks")
}

#' @export
#' @rdname facts_results
read_s1_patients <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-patients")
}

#' @export
#' @rdname facts_results
read_s2_patients <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-patients")
}

#' @export
#' @rdname facts_results
read_s2_weeks <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-weeks")
}

#' @export
#' @rdname facts_results
read_s2_mcmc <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-mcmc")
}

#' @export
#' @rdname facts_results
read_master_mcmc <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-mcmc")
}

#' @export
#' @rdname facts_results
read_master_patients <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-patients")
}

#' @export
#' @rdname facts_results
read_master_weeks <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "s1-weeks")
}

#' @export
#' @rdname facts_results
read_cohorts <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "cohorts")
}

#' @export
#' @rdname facts_results
read_simulations <- function(csv_files) {
  read_csv_special_impl(csv_files, prefix = "simulations", numbered = FALSE)
}

#' @export
#' @rdname facts_results
read_csv_special <- function(csv_files, prefix, numbered = TRUE) {
  assert_no_summaries(prefix)
  read_csv_special_impl(csv_files, prefix = prefix, numbered = numbered)
}

assert_no_summaries <- function(prefix) {
  pattern <- "summar"
  if (any(grepl(pattern = pattern, x = prefix))) {
    stop0(
      "do not try to read summary.csv files. ",
      "FACTS does not generate them reliably."
    )
  }
}

read_csv_special_impl <- function(csv_files, prefix, numbered = TRUE) {
  csv_files <- get_csv_files(csv_files, numbered = numbered)
  pattern <- paste0("^", prefix)
  if (numbered) {
    pattern <- paste0(pattern, "[0-9]+")
  }
  pattern <- paste0(pattern, "\\.csv")
  keep <- grepl(pattern = pattern, x = basename(csv_files))
  if (!any(keep)) {
    message("No CSV files to read.")
    return(tibble::tibble())
  }
  csv_files <- csv_files[keep]
  out <- lapply(csv_files, read_csv_file, prefix = prefix)
  out <- do.call(rbind, out)
  cols <- colnames(out)
  cols <- tolower(cols)
  cols <- make.names(cols, unique = TRUE)
  colnames(out) <- cols
  out
}

csv_pattern <- function(numbered) {
  ifelse(numbered, "[0-9]+\\.csv", "[^0-9]+\\.csv")
}

read_csv_file <- function(csv_file, prefix) {
  lines <- readLines(csv_file)
  lines_header <- grep("^#", lines, value = TRUE)
  lines_meta <- lines_header[1]
  lines_cols <- lines_header[length(lines_header)]
  lines_body <- grep("^#", lines, value = TRUE, invert = TRUE)
  df_name <- parse_csv_name(csv_file, prefix = prefix)
  df_meta <- parse_csv_meta(lines_meta)
  chr_cols <- parse_csv_cols(lines_cols)
  df_body <- parse_csv_body(lines_body)
  df_body <- df_body[, seq_along(chr_cols), drop = FALSE]
  colnames(df_body) <- chr_cols
  df_meta <- cbind(df_name, df_meta)
  for (field in colnames(df_meta)) {
    df_body[[field]] <- df_meta[[field]]
  }
  df_body$facts_csv <- csv_file
  df_body$facts_header <- paste(lines_header, collapse = "\n")
  cols <- c(
    "facts_file",
    "facts_scenario",
    "facts_sim",
    "facts_id",
    "facts_output",
    "facts_csv",
    "facts_header",
    chr_cols
  )
  out <- df_body[, cols, drop = FALSE]
  tibble::as_tibble(out)
}

parse_csv_name <- function(csv_file, prefix) {
  sim <- csv_file
  sim <- basename(sim)
  sim <- gsub(sim, pattern = prefix, replacement = "", fixed = TRUE)
  sim <- gsub(sim, pattern = "\\.csv$", replacement = "")
  sim <- as.integer(sim)
  tibble::tibble(
    facts_sim = sim,
    facts_output = prefix,
    facts_id = random_id()
  )
}

random_id <- function() {
  basename(tempfile())
}

parse_csv_meta <- function(lines_meta) {
  pattern <- "\\#[\\.0-9]+:|\\#DE=[\\.0-9]+,|GUI=[\\.0-9]+,"
  out <- lines_meta
  out <- gsub(out, pattern = pattern, replacement = "")
  out <- gsub(out, pattern = ":", replacement = ",", fixed = TRUE)
  out <- strsplit(out, split = ",")
  out <- unlist(out)
  out <- out[seq_len(2)]
  names(out) <- c("facts_file", "facts_scenario")
  out <- as.list(out)
  out$facts_file <- paste0(out$facts_file, ".facts")
  as.data.frame(out, stringsAsFactors = FALSE)
}

parse_csv_cols <- function(lines_cols) {
  out <- gsub(lines_cols, pattern = "#", replacement = "", fixed = TRUE)
  out <- strsplit(out, split = ",")
  out <- unlist(out)
  out <- trimws(out)
  out <- tolower(out)
  out <- make.names(out, unique = TRUE)
  gsub(out, pattern = " |\\.", replacement = "_")
}

parse_csv_body <- function(lines_body) {
  utils::read.table(
    text = lines_body,
    sep = ",",
    na.strings = "-9999",
    strip.white = TRUE,
    header = FALSE,
    stringsAsFactors = FALSE
  )
}

#' @title List FACTS-generated CSV files
#' @export
#' @description List output CSV files in a directory or directories.
#' @return A character vector of names of CSV files.
#' @param csv_files Character vector of directories containing
#'   numbered CSV files
#' @param numbered Logical. If `TRUE`,
#'   only list the numbered files like `patients00001.csv`,
#'   `weeks00017.csv`, etc. If `FALSE`, only list the non-numbered files
#'   like `simulations.csv` and `simulations_freq_locf.csv`.
#'   Avoid `summary.csv` files. They are not reliable on Linux.
#' @examples
#' facts_file <- get_facts_file_example("contin.facts")
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' out <- run_facts(
#'   facts_file,
#'   n_sims = 2L,
#'   verbose = FALSE
#' )
#' get_csv_files(out)
#' }
get_csv_files <- function(csv_files, numbered = TRUE) {
  get_files(csv_files, pattern = csv_pattern(numbered))
}

#' @title Overwrite FACTS CSV output files
#' @export
#' @description [read_patients()] and friends read
#'   CSV output files from FACTS and return special aggregated data frames.
#'   `overwite_csv_files()` accepts such an aggregated data frame
#'   and writes the content to the original CSV files it came from.
#' @return Nothing.
#' @param x An aggregated data frame from [read_patients()]
#'   or similar function.
#' @examples
#' facts_file <- get_facts_file_example("contin.facts")
#' # Can only run if system dependencies are configured:
#' if (file.exists(Sys.getenv("RFACTS_PATHS"))) {
#' out <- run_facts(facts_file, n_sims = 2)
#' pats <- read_patients(out)
#' head(pats$visit_1)
#' pats$visit_1 <- 0
#' overwrite_csv_files(pats)
#' pats2 <- read_patients(out)
#' head(pats2$visit_1)
#' }
overwrite_csv_files <- function(x) {
  lapply(split(x, f = x$facts_csv), overwrite_csv_file)
  invisible()
}

overwrite_csv_file <- function(x) {
  path <- x$facts_csv[1]
  lines <- x$facts_header[[1]]
  cols <- grep("^facts_", x = colnames(x), invert = TRUE)
  content <- x[, cols, drop = FALSE]
  con <- textConnection(object = "lines", open = "a", local = TRUE)
  on.exit(close(con))
  utils::write.table(
    content,
    file = con,
    sep = ",",
    na = "-9999",
    row.names = FALSE,
    col.names = FALSE
  )
  writeLines(lines, path)
}
