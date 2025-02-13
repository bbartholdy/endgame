## 👋 Welcome! 

![GitHub release (with filter)](https://img.shields.io/github/v/release/bbartholdy/endgame) 
[![Netlify Status](https://api.netlify.com/api/v1/badges/654e8f2b-273f-4ad4-bf70-5893719cb68c/deploy-status)](https://app.netlify.com/sites/myphd/deploys) [![build](https://github.com/bbartholdy/endgame/actions/workflows/build.yaml/badge.svg)](https://github.com/bbartholdy/endgame/actions/workflows/build.yaml)
![Thesis Status](https://img.shields.io/badge/Status-DEFENDED-green) [![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

**Disclaimer:** The site contains a bare-bones tracker to count the number of
visitors. No other information is recorded. The stats are publically available
[here](http://statcounter.com/p12714961/summary/?guest=1).

<!--
- 📁: [PDF](./link-to-pdf)
- :link: [HTML](link-to-site)
- 📁: [e-pub]()
-->

### Use

The reproducibility of this repository has not been tested comprehensively, so please let me know if you
encounter any issues.

To clone this repository you will need to use `--recurse-submodules`.

```sh
git clone --recurse-submodules git@github.com:bbartholdy/endgame.git
```

To load the necessary R dependencies, you will need the [**renv**](https://rstudio.github.io/renv/) package

```r
install.packages("renv")
```

Then

```r
renv::restore()
```

To preview the HTML version you can run Quarto via a terminal or R console

```sh
quarto preview
```

or

```r
quarto::quarto_preview()
```

To render the PDF version can run

```sh
quarto render --to pdf
```

or

```r
quarto::quarto_render("pdf")
```
