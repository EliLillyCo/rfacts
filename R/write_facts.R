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
#'   be vectors or lists of vectors. In the former case, each element
#'   is a scalar replacement to a property. In the latter case,
#'   an XML property receives an entire vector as an item list,
#'   and the vector must be the same length as the original item list.
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
write_facts <- function(fields, values, default_dir = "_facts") {
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
  stopifnot(!anyDuplicated(fields$field))
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
  xml <- xml2::read_xml(file)
  for (name in names(values)) {
    substitute_xml(
      xml = xml,
      field = fields[fields$field == name,, drop = FALSE], # nolint
      value = values[[name]]
    )
  }
  fs::dir_create(dirname(output))
  xml2::write_xml(x = xml, file = output)
}

substitute_xml <- function(xml, field, value) {
  property <- xml2::xml_find_first(xml, get_xpath(field))
  trn(
    length(xml2::xml_children(property)),
    insert_xml_vector(property, value),
    insert_xml_scalar(property, value)
  )
}

get_xpath <- function(field) {
  paste0(
    "/facts/parameterSets[@type='",
    field$type,
    "']/parameterSet[@name='",
    field$set,
    "']/property[@name='",
    field$property,
    "']"
  )
}

insert_xml_scalar <- function(property, value) {
  xml2::xml_text(property) <- value
}

insert_xml_vector <- function(property, value) {
  list <- xml2::xml_child(property)
  value <- unlist(value)
  children <- xml2::xml_children(list)
  if (length(value) != length(children)) {
    stop0(
      "A FACTS XML replacement value can be a vector ",
      "but it must have the same length as the original ",
      "item list being replaced."
    )
  }
  for (index in seq_along(value)) {
    child <- children[[index]]
    xml2::xml_text(child) <- value[[index]]
  }
}
