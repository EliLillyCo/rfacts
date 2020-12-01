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
#'   fields <- data.frame(
#'     field = "my_interval",
#'     type = "NucleusParameterSet",
#'     set = "nucleus",
#'     property = "update_freq_save"
#'   )
#'   values <- data.frame(
#'     facts_file = "your_facts_file.facts",
#'     output = "output_file.facts",
#'     my_interval = c(5, 6)
#'   )
#'   ```
#'   and then call `write_facts(fields = fields, values = values)`.
#' @return The function writes FACTS XML files and
#'   invisibly returns a character vector with the paths to those files.
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
  
}
