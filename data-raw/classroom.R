## code to prepare `classroom` dataset goes here
##
## Source uncertain; likely drawn from or based on:
## Gelman, A. and Hill, J. (2007). Data Analysis Using Regression and
## Multilevel/Hierarchical Models. Cambridge University Press.
## Replication data at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/10285
## Possibly derived from: Hill, H.C., Rowan, B., and Ball, D.L. (2005).
## Effects of teachers' mathematical knowledge for teaching on student
## achievement. American Educational Research Journal, 42, 371-406.
## Copied from: immr24/data/classroom.csv (course data folder; no modifications)
## TODO: verify exact provenance and update this header accordingly

classroom <- readr::read_csv("inst/extdata/classroom.csv", show_col_types = FALSE) |>
  dplyr::mutate(
    classid  = factor(classid),
    schoolid = factor(schoolid),
    classid2 = factor(classid2)
  )

usethis::use_data(classroom, overwrite = TRUE)
