
# rfacts

[![cran](https://www.r-pkg.org/badges/version/rfacts)](https://cran.r-project.org/package=rfacts)
[![active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![check](https://github.com/EliLillyCo/rfacts/workflows/check/badge.svg)](https://github.com/EliLillyCo/rfacts/actions?query=workflow%3Acheck)
[![lint](https://github.com/EliLillyCo/rfacts/workflows/lint/badge.svg)](https://github.com/EliLillyCo/rfacts/actions?query=workflow%3Alint)
[![codecov](https://codecov.io/gh/EliLillyCo/rfacts/branch/master/graph/badge.svg?token=3T5DlLwUVl)](https://codecov.io/gh/EliLillyCo/rfacts)

The rfacts package is an R interface to the [Fixed and Adaptive Clinical
Trial Simulator (FACTS)](https://www.berryconsultants.com/software/) on
Unix-like systems. It programmatically invokes
[FACTS](https://www.berryconsultants.com/software/) to run clinical
trial simulations, and it aggregates simulation output data into tidy
data frames. These capabilities provide end-to-end automation for
large-scale simulation workflows, and they enhance computational
reproducibility. For more information, please visit the [documentation
website](https://elilillyco.github.io/rfacts/).

## Disclaimer

`rfacts` is not a product of nor supported by [Berry
Consultants](https://www.berryconsultants.com/). The code base of
`rfacts` is completely independent from that of
[FACTS](https://www.berryconsultants.com/software/), and the former only
invokes the latter though dynamic system calls.

## Limitations

  - FACTS files prior to version 6.2.4 are unsupported.
  - `rfacts` only works on Unix-like systems.
  - `rfacts` requires paths to pre-compiled versions of Mono, FLFLL, and
    the FACTS Linux engines. See the installation instructions below and
    the [configuration
    guide](https://elilillyco.github.io/rfacts/articles/config.html).

## Installation

To install the latest release from CRAN, open R and run the following.

``` r
install.packages("rfacts")
```

To install the latest development version:

``` r
install.packages("remotes")
remotes::install_github("EliLillyCo/rfacts")
```

Next, set the `RFACTS_PATHS` environment variable appropriately. For
instructions, please see the [configuration
guide](https://elilillyco.github.io/rfacts/articles/config.html).

## Run FACTS simulations

First, create a `*.facts` XML file using the
[FACTS](https://www.berryconsultants.com/software/) GUI. The `rfacts`
package has several built-in examples, included with permission from
Berry Consultants LLC.

``` r
library(rfacts)

# get_facts_file_example() returns the path to
# an example a FACTS file from rfacts itself.
# For your own FACTS files you create yourself in the FACTS GUI,
# you can skip get_facts_file_example().
facts_file <- get_facts_file_example("contin.facts")

basename(facts_file)
#> [1] "contin.facts"
```

Then, run trial simulations with `run_facts()`. By default, the results
are written to a temporary directory. Set the `output_path` argument to
customize the path.

``` r
out <- run_facts(
  facts_file,
  n_sims = 2,
  verbose = FALSE
)

out
#> [1] "/tmp/RtmpFv78Hj/file427b6fd72e42"

head(get_csv_files(out))
#> [1] "/tmp/RtmpFv78Hj/file427b6fd72e42/contin/acc1_drop1_resp1_params/patients00001.csv"          
#> [2] "/tmp/RtmpFv78Hj/file427b6fd72e42/contin/acc1_drop1_resp1_params/patients00002.csv"          
#> [3] "/tmp/RtmpFv78Hj/file427b6fd72e42/contin/acc1_drop1_resp1_params/weeks_freq_ignore_00001.csv"
#> [4] "/tmp/RtmpFv78Hj/file427b6fd72e42/contin/acc1_drop1_resp1_params/weeks_freq_ignore_00002.csv"
#> [5] "/tmp/RtmpFv78Hj/file427b6fd72e42/contin/acc1_drop1_resp1_params/weeks_freq_locf_00001.csv"  
#> [6] "/tmp/RtmpFv78Hj/file427b6fd72e42/contin/acc1_drop1_resp1_params/weeks_freq_locf_00002.csv"
```

Use `read_patients()` to read and aggregate all the `patients*.csv`
files. `rfacts` has several such functions, including `read_weeks()` and
`read_mcmc()`.

``` r
read_patients(out)
#> # A tibble: 2,400 x 15
#>    facts_file facts_scenario facts_sim facts_id facts_output facts_csv
#>    <chr>      <chr>              <int> <chr>    <chr>        <chr>    
#>  1 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  2 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  3 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  4 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  5 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  6 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  7 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  8 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  9 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> 10 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> # … with 2,390 more rows, and 9 more variables: facts_header <chr>,
#> #   subject <int>, region <int>, date <dbl>, dose <int>, lastvisit <int>,
#> #   dropout <int>, baseline <lgl>, visit_1 <dbl>
```

## The simulation process

`run_facts()` has two sequential stages:

1.  `run_flfll()`: generate the `*.param` files and the folder structure
    for the FACTS Linux engines.
2.  `run_engine()`: execute the instructions in the `*.param` files to
    conduct trial simulations and produce CSV output.

<!-- end list -->

``` r
out <- run_flfll(facts_file, verbose = FALSE)
run_engine(facts_file, param_files = out, n_sims = 4, verbose = FALSE)
read_patients(out)
#> # A tibble: 4,800 x 15
#>    facts_file facts_scenario facts_sim facts_id facts_output facts_csv
#>    <chr>      <chr>              <int> <chr>    <chr>        <chr>    
#>  1 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  2 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  3 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  4 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  5 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  6 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  7 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  8 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  9 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> 10 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> # … with 4,790 more rows, and 9 more variables: facts_header <chr>,
#> #   subject <int>, region <int>, date <dbl>, dose <int>, lastvisit <int>,
#> #   dropout <int>, baseline <lgl>, visit_1 <dbl>
```

`run_engine()` automatically detects the Linux engine required for your
FACTS file. If you know the engine in advance, you can use a specific
engine function such as `run_engine_contin()` or `run_engine_dichot()`.

``` r
out <- run_flfll(facts_file, verbose = FALSE)
run_engine_contin(param_files = out, n_sims = 4, verbose = FALSE)
read_patients(out)
#> # A tibble: 4,800 x 15
#>    facts_file facts_scenario facts_sim facts_id facts_output facts_csv
#>    <chr>      <chr>              <int> <chr>    <chr>        <chr>    
#>  1 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  2 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  3 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  4 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  5 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  6 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  7 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  8 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  9 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> 10 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> # … with 4,790 more rows, and 9 more variables: facts_header <chr>,
#> #   subject <int>, region <int>, date <dbl>, dose <int>, lastvisit <int>,
#> #   dropout <int>, baseline <lgl>, visit_1 <dbl>
```

If you are unsure which engine function to use, call
`get_facts_engine()`

``` r
get_facts_engine(facts_file)
#> [1] "run_engine_contin"
```

## Run a single scenario

If we take control of the simulation process, we can pick and choose
which FACTS simulation scenarios to run and read.

``` r
# Example FACTS file built into rfacts.
facts_file <- get_facts_file_example("contin.facts")

# Set up the files for the scenarios.
param_files <- run_flfll(facts_file, verbose = FALSE)

# Each scenario has its own folder with internal parameter files.
scenarios <- get_param_dirs(param_files) # not in rfacts <= 1.0.0
scenarios
#> [1] "/tmp/RtmpFv78Hj/file427b68486ae6/contin/acc1_drop1_resp1_params"
#> [2] "/tmp/RtmpFv78Hj/file427b68486ae6/contin/acc1_drop1_resp2_params"
#> [3] "/tmp/RtmpFv78Hj/file427b68486ae6/contin/acc2_drop1_resp1_params"
#> [4] "/tmp/RtmpFv78Hj/file427b68486ae6/contin/acc2_drop1_resp2_params"

# Let's pick one of those scenarios and run the simulations.
scenario <- scenarios[1]
run_engine_contin(scenario, n_sims = 2, verbose = FALSE)
read_patients(scenario)
#> # A tibble: 600 x 15
#>    facts_file facts_scenario facts_sim facts_id facts_output facts_csv
#>    <chr>      <chr>              <int> <chr>    <chr>        <chr>    
#>  1 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  2 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  3 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  4 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  5 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  6 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  7 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  8 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  9 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> 10 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> # … with 590 more rows, and 9 more variables: facts_header <chr>,
#> #   subject <int>, region <int>, date <dbl>, dose <int>, lastvisit <int>,
#> #   dropout <int>, baseline <lgl>, visit_1 <dbl>
```

## Parallel computing

rfacts makes it straightforward to parallelize across simulations.
First, use `run_flfll()` to create a directory of param files. Be sure
to supply an `output_path` that all the parallel workers can access
(e.g. no `tempfile()`s).

``` r
library(rfacts)
facts_file <- get_facts_file_example("contin.facts")
param_files <- file.path(getwd(), "param_files")
run_flfll(facts_file, param_files)
#> [1] "/home/c240390/projects/rfacts/param_files"
```

Next, write a custom function that accepts the param files, runs a
single simulation for each param file, and returns the important data in
memory. Be sure to set a unique seed for each simulation iteration.

``` r
sim_once <- function(iter, param_files) {
  # Copy param files to a temp file in order to
  # (1) Avoid race conditions in parallel processing, and
  # (2) Make things run faster: temp files are on local node storage.
  out <- tempfile()
  fs::dir_copy(path = param_files, new_path = out)
  
  # Run the engine once per param file.
  run_engine_contin(out, n_sims = 1L, seed = iter)
  
  # Return aggregated patients files.
  read_patients(out) # Reads fast because `out` is a tempfile().
}
```

At this point, we should test this function locally without parallel
computing.

``` r
library(dplyr)

# All the patients files were named patients00001.csv,
# so do not trust the facts_sim column.
# For data post-processing, use the facts_id column instead.
lapply(seq_len(4), sim_once, param_files = param_files) %>%
  bind_rows()
#> # A tibble: 4,800 x 15
#>    facts_file facts_scenario facts_sim facts_id facts_output facts_csv
#>    <chr>      <chr>              <int> <chr>    <chr>        <chr>    
#>  1 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  2 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  3 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  4 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  5 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  6 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  7 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  8 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#>  9 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> 10 contin.fa… acc1_drop1_re…         1 file427… patients     /tmp/Rtm…
#> # … with 4,790 more rows, and 9 more variables: facts_header <chr>,
#> #   subject <int>, region <int>, date <dbl>, dose <int>, lastvisit <int>,
#> #   dropout <int>, baseline <lgl>, visit_1 <dbl>
```

Parallel computing happens when we call `sim_once()` repeatedly over
several parallel workers. A powerful and convenient parallel computing
solution is [`clustermq`](https://mschubert.github.io/clustermq/). Here
is a sketch of how to use it with `rfacts`. `mclapply()` from the
`parallel` package is a quick and dirty alternative.

``` r
# Configure clustermq to use our grid and your template file.
# If you are using a scheduler like SGE, you need to write a template file
# like clustermq.tmpl. To learn how, visit
# https://mschubert.github.io/clustermq/articles/userguide.html#configuration-1
options(clustermq.scheduler = "sge", clustermq.template = "clustermq.tmpl")

# Run the computation.
library(clustermq)
patients <- Q(
  fun = sim_once,
  iter = seq_len(50),
  const = list(params = params),
  pkgs = c("fs", "rfacts"),
  n_jobs = 4
) %>%
  bind_rows()

# Show aggregated patient data.
patients
```

Alternatives to `clustermq` include `parallel::mclapply()`,
`furrr::future_map()`, and `future.apply::future_lapply()`.

## Helpers

Various `get_facts_*()` functions interrogate FACTS files.

``` r
get_facts_scenarios(facts_file)
#> [1] "acc1_drop1_resp1" "acc1_drop1_resp2" "acc2_drop1_resp1" "acc2_drop1_resp2"
get_facts_version(facts_file)
#> [1] "6.2.5.22668"
get_facts_versions()
#> [1] "6.3.1"   "6.2.5"   "6.0.0.1"
```
