---
name: Performance
about: "Runtime, memory, or storage inefficiency"
title: ""
labels: "topic: performance"
---

## Prework

* [ ] I understand and agree to the [code of conduct](https://github.com/EliLillyCo/rfacts/blob/master/CODE_OF_CONDUCT.md).
* [ ] I understand and agree to the [contributing guidelines](https://github.com/EliLillyCo/rfacts/blob/master/CONTRIBUTING.md).
* [ ] This post does not contain any proprietary or confidential information. I understand that all information I share here is publicly visible.
* [ ] Be considerate of the maintainer's time and make it as easy as possible to troubleshoot any problems you identify. Read [here](https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example) and [here](https://www.tidyverse.org/help/) to learn about minimal reproducible examples. Format your code according to the [tidyverse style guide](https://style.tidyverse.org/) to make it easier for others to read.

## Description

Please describe the performance issue.

## Reproducible example

Be considerate of the maintainer's time and make it as easy as possible to troubleshoot any problems you identify. Read [here](https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example) and [here](https://www.tidyverse.org/help/) to learn about minimal reproducible examples. Format your code according to the [tidyverse style guide](https://style.tidyverse.org/) to make it easier for others to read.

## Benchmarks

How poorly does `rfacts` perform? To find out, we recommend the [`proffer`](https://github.com/EliLillyCo/proffer) package and take screenshots of the results displayed in your browser.

```r
library(rfacts)
library(proffer)
px <- pprof({
  # All your rfacts code goes here.
})
```
