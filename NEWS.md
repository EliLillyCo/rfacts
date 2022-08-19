# Version 0.2.1

* Fix HTML docs.

# Version 0.2.0

* Add a `max_sims` argument to `run_flfll()` because `-nSims` in FLFLL can no longer safely be set to 1. (FLFLL 6.4.1 now uses `-nSims` to set the number of CRM cohort files.)
* Manually disable packetization with the `-packet` flag in FLFLL >= 6.4.1.

# Version 0.1.1

* Remove LazyData in the DESCRIPTION to address CRAN check notes.

# Version 0.1.0

* Add new function `read_facts()` to read arbitrary XML fields of FACTS files.
* Add new function `write_facts()` to programmatically generate modified copies of FACTS files.

# Version 0.0.2

* Mention CRAN in docs.
* Use single quotes to reference software names in the `DESCRIPTION`.
* Avoid `\dontrun{}` in examples. Instead, check if the required system dependencies are configured. Most of the examples need to be skipped because `rfacts` relies on system dependencies that are proprietary and not publicly available. To obtain the system dependencies, contact Berry Consultants: <https://www.berryconsultants.com/software/>.
* Always write to temp files in the README, examples, tests, and vignettes.

# Version 0.0.1

* First version
