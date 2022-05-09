# example R options set globally
#options(width = 60)

# example chunk options set globally
# knitr::opts_chunk$set(
#   comment = "#>",
#   collapse = TRUE
#   )

# generate r package bibliography
#bib_packages <- c(.packages(), 'bookdown', 'knitr', 'rmarkdown')
#knitr::write_bib(bib_packages, 'packages.bib')

# update bibliography
library(here)
library(rbbt)
ref_files <- list.files(here(), "*.qmd")
bbt_update_bib(ref_files, here("book.bib"))