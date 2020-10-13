---
name: Performance
about: "Runtime, memory, or storage inefficiency"
title: ""
labels: "topic: performance"
---

## Prework

* [ ] Read and agree to the [code of conduct](https://github.com/EliLillyCo/rfacts/blob/main/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/EliLillyCo/rfacts/blob/main/CONTRIBUTING.md).
* [ ] If there is [already a relevant issue](https://github.com/EliLillyCo/rfacts/issues), whether open or closed, comment on the existing thread instead of posting a new issue.
* [ ] This post does not contain any proprietary or confidential information. All information shared here is publicly visible.
* [ ] For any problem you identify, post a [minimal reproducible example](https://www.tidyverse.org/help/) so the maintainer can troubleshoot. A reproducible example is:
    * [ ] **Runnable**: post enough R code and data so any onlooker can create the error on their own computer.
    * [ ] **Minimal**: reduce runtime wherever possible and remove complicated details that are irrelevant to the issue at hand.
    * [ ] **Readable**: format your code according to the [tidyverse style guide](https://style.tidyverse.org/).

## Description

Please describe the performance issue.

## Reproducible example

* [ ] For any problem you identify, post a [minimal reproducible example](https://www.tidyverse.org/help/) so the maintainer can troubleshoot. A reproducible example is:
    * [ ] **Runnable**: post enough R code and data so any onlooker can create the error on their own computer.
    * [ ] **Minimal**: reduce runtime wherever possible and remove complicated details that are irrelevant to the issue at hand.
    * [ ] **Readable**: format your code according to the [tidyverse style guide](https://style.tidyverse.org/).

## Benchmarks

How poorly does `rfacts` perform? To find out, we recommend the [`proffer`](https://github.com/r-prof/proffer) package and take screenshots of the results displayed in your browser.

```r
library(rfacts)
library(proffer)
px <- pprof({
  # All your rfacts code goes here.
})
```
