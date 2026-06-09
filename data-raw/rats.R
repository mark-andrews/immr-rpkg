## code to prepare `rats` dataset goes here
##
## Source: Tarone, R.E. (1982). The use of historical control information in
## testing for a trend in proportions. Biometrics, 38, 215-220.
## Reproduced as Table 5.1 in: Gelman, A., Carlin, J.B., Stern, H.S., Dunson,
## D.B., Vehtari, A., and Rubin, D.B. (2013). Bayesian Data Analysis, 3rd ed.
## Chapman & Hall/CRC.
## Original data from: sites.stat.columbia.edu/gelman/book/data/rats.asc
## Copied from: immr24/data/rats.csv (course data folder; no modifications)

rats <- readr::read_csv("inst/extdata/rats.csv", show_col_types = FALSE)

usethis::use_data(rats, overwrite = TRUE)
