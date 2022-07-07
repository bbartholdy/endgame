# example R options set globally
#options(width = 60)

# example chunk options set globally

# knitr::opts_chunk$set(
#   comment = "#>",
#   collapse = TRUE
#   )

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  warning = FALSE,
  message = FALSE,
  echo = FALSE
  )

# generate r package bibliography
#bib_packages <- c(.packages(), 'bookdown', 'knitr', 'rmarkdown')
#knitr::write_bib(bib_packages, 'packages.bib')

# set ggplot theme

calculus_palette <- c(
  "#782386",
  "#ab1866",
  "#d1295a",
  "#e05b5c",
  "#ffcc66"
)

# generate/update bibliography
if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
  quit()
}

library(here)

ref_files <- list.files(here(), ".qmd|.Rmd")
keys <- rbbt::bbt_detect_citations(ref_files)

try(
  if (file.exists(here("book.bib"))) {
    rbbt::bbt_update_bib(
      ref_files, 
      here("book.bib"),
      ignore = keys[grepl("fig-", keys)]) # detect figure references
  } else {
    rbbt::bbt_write_bib(
      here("book.bib"), 
      keys = keys, 
      ignore = keys[grepl("fig-", keys)]) # detect figure references
  }
)