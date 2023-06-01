# example R options set globally
#options(width = 60)

# example chunk options set globally

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

# generate/update bibliography only if rendering project
if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
  quit()
}

library(here)
library(rbbt)

diss_files <- list.files(here(), pattern = ".Rmd|.qmd", full.names = T)
byoc_valid_files <- list.files(here("articles/byoc-valid/07-publication"), pattern = ".Rmd|.qmd", full.names = T)
byoc_starch_files <- list.files(here("articles/byoc-starch/analysis/paper"), pattern = ".Rmd|.qmd", full.names = T)
mb11_file_files <- list.files(here("articles/mb11CalculusPilot/analysis/paper"), pattern = ".Rmd|.qmd", full.names = T)


file_names <- c(diss_files, byoc_valid_files, byoc_starch_files, mb11_file_files)
all_files <- file_names[stringr::str_detect(file_names, "supp-mat|fig_tab", negate = T)]
keys <- bbt_detect_citations(all_files)
bbt_ignore <- keys[grepl("fig-|tbl-", keys)]

try(
if(file.exists(here("book.bib"))) {
  bbt_update_bib(here(all_files),
    here("book.bib"),
    ignore = bbt_ignore,
    overwrite = T)
} else {
  refs <- rbbt::bbt_detect_citations(all_files)
  bbt_write_bib(here("book.bib"),
    keys = keys,
    ignore = bbt_ignore,
    overwrite = T,
    translator = "bibtex")
}
)
