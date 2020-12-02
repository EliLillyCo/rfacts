#' @title Write modified FACTS files.
#' @export
#' @description Write modified versions of existing FACTS files.
#'   This function can be used to tweak properties of a FACTS file
#'   such as maximum sample size, number of weeks between interims,
#'   allocation ratios, data generation parameters,
#'   and analysis priors.
#' @details A FACTS file has a special kind of XML format.
#'   Most of the content sits in an overarching `<facts>` tag,
#'   then a `<parameterSets>` tag, then a
#'   `<parameterSet>` tag, then a `<property>` tag.
#'   For example, here is the part of a FACTS file that controls
#'   the weeks between interims.
#'   ```xml
#'   <facts>
#'     <parameterSets type="NucleusParameterSet">
#'       <parameterSet name="nucleus">
#'         <property name="update_freq_save">4</property>
#'   ```
#'   To use the `write_facts()` function, you must first identify
#'   the parts of the FACTS file you want to modify (the `fields` argument)
#'   then the values that should be substituted in (the `values` argument).
#'   Given the XML above, to create new FACTS files with intervals
#'   5 and 6 instead of 4, you would set
#'   ```r
#'   fields <- tibble::tibble(
#'     field = "my_interval",
#'     type = "NucleusParameterSet",
#'     set = "nucleus",
#'     property = "update_freq_save"
#'   )
#'   values <- tibble::tibble(
#'     facts_file = "your_facts_file.facts",
#'     output = "output_file.facts",
#'     my_interval = c(5, 6)
#'   )
#'   ```
#'   and then call `write_facts(fields = fields, values = values)`.
#' @return The function writes FACTS XML files and
#'   returns a character vector with the paths to those files.
#' @param fields Data frame defining the kind of XML data to be replaced.
#'   It must have one row per field definition and the following columns:
#'   1. `field`: custom name of the field.
#'   2. `type`: value of the "type" attribute of the `<parameterSets>` tag.
#'   3. `set`: value of the "name" attribute of the `<parameterSet>` tag.
#'   4. `property`: value of the "name" attribute of the `<property>` tag.
#' @param values Data frame defining the FACTS files to generate.
#'   Must have one row per FACTS file and a column called `facts_file`
#'   with the names of the input FACTS files. An `output` column with the
#'   names of the output FACTS files is recommended but not required.
#'   (If `output` is not specified, the output FACTS files will be
#'   written to automatically generated paths inside `default_dir`.)
#'   Other columns must have names corresponding to elements of `fields$field`
#'   and contain values to insert into the FACTS files. These columns could
#'   be vectors or lists of vectors.
#' @param default_dir Directory to write the output FACTS files
#'   if `values` has no `output` column.
#' @examples
#' # Identify a source FACTS file.
#' facts_file <- get_facts_file_example("contin.facts")
#' # Create 4 new FACTS files with different numbers of max patients.
#' fields <- data.frame(
#'   field = "my_subjects",
#'   type = "NucleusParameterSet",
#'   set = "nucleus",
#'   property = "max_subjects"
#' )
#' values <- data.frame(
#'   facts_file = facts_file,
#'   output = c("_facts/out1000.facts", "_facts/out2000.facts"),
#'   my_subjects = c(1000, 2000)
#' )
#' default_dir <- tempfile()
#' write_facts(fields = fields, values = values, default_dir = default_dir)
#' list.files("_facts")
#' unlink("_facts", recursive = TRUE)
write_facts <- function(fields, values, default_dir = "_facts"){
  assert_df(fields)
  assert_df(values)
  assert_scalar_character(default_dir)
  assert_fields(fields)
  assert_values(values)
  assert_all_fields_defined(fields, values)
  fields <- convert_character_columns(fields)
  values <- convert_character_columns(values)
  values <- ensure_output_column(values, default_dir)

  lapply(
    split(values, f = seq_len(nrow(values))),
    write_facts_file,
    fields = fields
  )
  values$output
}

assert_fields <- function(fields) {
  cols <- sort(c("field", "type", "set", "property"))
  stopifnot(identical(sort(colnames(fields)), cols))
}

assert_values <- function(values) {
  stopifnot("facts_file" %in% colnames(values))
}

assert_all_fields_defined <- function(fields, values) {
  names <- setdiff(colnames(values), c("facts_file", "output"))
  stopifnot(all(names %in% fields$field))
}

convert_character_columns <- function(x) {
  for (index in seq_along(x)) {
    x[[index]] <- trn(
      is.list(x[[index]]),
      lapply(x[[index]], as.character),
      as.character(x[[index]])
    )
  }
  x
}

ensure_output_column <- function(values, default_dir) {
  if ("output" %in% colnames(values)) {
    return(values)
  }
  values$output <- output_column(values, default_dir)
  values
}

output_column <- function(values, default_dir) {
  hashes <- lapply(
    split(values, seq_len(nrow(values))),
    digest::digest,
    algo = "xxhash32"
  )
  file.path(default_dir, paste0(unlist(hashes), ".facts"))
}

write_facts_file <- function(fields, values) {
  file <- values$facts_file
  output <- values$output
  values <- as.list(values)
  values$facts_file <- NULL
  values$output <- NULL
  xml <- xml2::as_list(xml2::read_xml(facts_file))
  for (name in names(values)) {
    xml <- substitute_xml(
      xml = xml,
      field = as.list(fields[fields$field == name,]),
      value = values[[name]]
    )
  }
  xml2::write_xml(x = xml2::as_xml_document(xml), file = output)
}

substitute_xml <- function(xml, field, value) {
  index <- find_xml_index(xml, field)
  prior <- xml$facts[[index$paramsets]][[index$paramset]][[index$property]][[1]]
  if (is.character(prior) && length(prior) == 1L) {
    xml$facts[[index$paramsets]][[index$paramset]][[index$property]][[1]] <- value
  }
  xml
}

find_xml_index <- function(xml, field) {
  index_paramsets <- find_xml_index_scalar(
    xml$facts,
    "parameterSets",
    "type",
    field$type
  )
  index_paramset <- find_xml_index_scalar(
    xml$facts[[index_paramsets]],
    "parameterSet",
    "name",
    field$set
  )
  index_property <- find_xml_index_scalar(
    xml$facts[[index_paramsets]][[index_paramset]],
    "property",
    "name",
    field$property
  )
  list(
    paramsets = index_paramsets,
    paramset = index_paramset,
    property = index_property
  )
}

find_xml_index_scalar <- function(xml, tag, attr, element) {
  names <- names(xml)
  index <- vapply(seq_along(xml), function(index) {
    identical(bare_object(names[[index]]), tag) &&
      identical(bare_object(attr(xml[[index]], attr)), bare_object(element))
  }, FUN.VALUE = logical(1))
  assert_xml_found(index, tag, attr, element)
  which(index)
}

assert_xml_found <- function(index, tag, attr, element) {
  if (sum(index) < 1L) {
    stop0(
      "no XML tag ",
      tag,
      " found with ",
      attr,
      " ",
      element,
      " in the current piece of FACTS file XML."
    )
  }
  if (sum(index) > 1L) {
    stop0(
      "more than one XML tag ",
      tag,
      " found with ",
      attr,
      " ",
      element,
      " in the current piece of FACTS file XML."
    )
  }
}
