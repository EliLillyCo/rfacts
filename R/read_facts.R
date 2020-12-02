#' @title Read parts of FACTS files.
#' @export
#' @description Read specific fields of a FACTS file.
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
#'   To use the `read_facts()` function, you must first identify
#'   the parts of the FACTS file you want to read using the `fields` argument.
#'   To read the above part of the XML, you would first define the
#'   `update_freq_save` field.
#'   ```r
#'   fields <- tibble::tibble(
#'     field = "my_interval",
#'     type = "NucleusParameterSet",
#'     set = "nucleus",
#'     property = "update_freq_save"
#'   )
#'   ```
#'   and then call `read_facts(input = "your_file.facts", fields = fields)`.
#' @return A one-row `tibble` with the requested fields from the FACTS file.
#' @param facts_file Character of length 1, path to FACTS XML file to read.
#' @param fields Data frame defining the kind of XML data to be read.
#'   It must have one row per field definition and the following columns:
#'   1. `field`: custom name of the field.
#'   2. `type`: value of the "type" attribute of the `<parameterSets>` tag.
#'   3. `set`: value of the "name" attribute of the `<parameterSet>` tag.
#'   4. `property`: value of the "name" attribute of the `<property>` tag.
#' @examples
#' facts_file <- get_facts_file_example("contin.facts")
#' fields <- data.frame(
#'   field = c("my_subjects", "my_vsr"),
#'   type = c("NucleusParameterSet", "EfficacyParameterSet"),
#'   set = c("nucleus", "resp2"),
#'   property = c("max_subjects", "true_endpoint_response")
#' )
#' read_facts(facts_file = facts_file, fields = fields)
read_facts <- function(facts_file, fields) {
  assert_scalar_character(facts_file)
  assert_df(fields)
  assert_fields(fields)
  fields <- convert_character_columns(fields)
  xml <- xml2::read_xml(facts_file)
  out <- lapply(
    split(fields, f = seq_len(nrow(fields))),
    read_facts_field,
    xml = xml
  )
  names(out) <- fields$field
  tibble::as_tibble(
    cbind(
      tibble::tibble(facts_file = facts_file),
      tibble::as_tibble(out)
    )
  )
}

read_facts_field <- function(field, xml) {
  property <- xml2::xml_find_first(xml, get_xpath(field))
  trn(
    length(xml2::xml_children(property)),
    list(unname(unlist(xml2::as_list(property)[[1]]))),
    xml2::xml_text(property)
  )
}
