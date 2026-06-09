## code to prepare `mathachieve` dataset goes here
##
## Source: High School and Beyond survey, analysed in:
## Raudenbush, S.W. and Bryk, A.S. (2002). Hierarchical Linear Models:
## Applications and Data Analysis Methods, 2nd ed. Sage.
## Widely used as a teaching example for multilevel models with group-level
## predictors. Pupil-level file; school-level file is in mathachieveschool.R.

mathachieve <- readr::read_csv(
  "inst/extdata/mathachieve.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(
    pupil    = factor(pupil),
    school   = factor(school),
    minority = factor(minority),
    sex      = factor(sex)
  )

usethis::use_data(mathachieve, overwrite = TRUE)
