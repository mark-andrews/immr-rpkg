## code to prepare `alcohol` dataset goes here
##
## Source: World Health Organization Global Information System on Alcohol and
## Health (GISAH). Per capita recorded alcohol consumption (litres of pure
## alcohol) for adults aged 15 and over.
## https://www.who.int/data/gho/indicator-metadata-registry/imr-details/462
## Copied from: immr24/data/alcohol.csv (course data folder; no modifications)
## TODO: verify exact download URL and year of retrieval

alcohol <- readr::read_csv("inst/extdata/alcohol.csv", show_col_types = FALSE) |>
  dplyr::mutate(
    country = factor(country, levels = sort(unique(country)))
  )

usethis::use_data(alcohol, overwrite = TRUE)
