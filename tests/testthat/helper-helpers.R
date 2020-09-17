skip_paths <- function() {
  skip_if(Sys.getenv("RFACTS_PATHS") == "")
}

exempt_cols <- function() {
  c("facts_id", "facts_csv", "facts_header")
}

facts_engine_6001 <- function(engine_file) {
  paste0(gsub("\\.x$", "", engine_file), "6.0.0.1")
}

facts_engine_625 <- function(engine_file) {
  paste0(gsub("\\.x$", "", engine_file), "6.0.0.4")
}

list_facts_files <- function() {
  list.files(
    system.file("facts", package = "rfacts", mustWork = TRUE),
    pattern = "\\.facts$"
  )
}

unique_weeks_files <- function(dir) {
  out <- get_csv_files(dir)
  out <- grep(out, pattern = "weeks[0-9]+\\.csv$", value = TRUE)
  out <- basename(out)
  unique(out)
}
