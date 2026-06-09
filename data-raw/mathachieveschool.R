## code to prepare `mathachieveschool` dataset goes here
##
## Source: High School and Beyond survey, analysed in:
## Raudenbush, S.W. and Bryk, A.S. (2002). Hierarchical Linear Models:
## Applications and Data Analysis Methods, 2nd ed. Sage.
## School-level file; pupil-level file is in mathachieve.R.

mathachieveschool <- readr::read_csv(
  "inst/extdata/mathachieveschool.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(
    school  = factor(school),
    sector  = factor(sector),
    himinty = factor(himinty)
  )

usethis::use_data(mathachieveschool, overwrite = TRUE)
