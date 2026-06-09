## code to prepare `blp_short2` dataset goes here
##
## Source: British Lexicon Project (BLP).
## Keuleers, E., Lacey, P., Rastle, K., and Brysbaert, M. (2012). The British
## Lexicon Project: Lexical decision data for 28,730 monosyllabic and
## disyllabic English words. Behavior Research Methods, 44, 287-304.
## https://doi.org/10.3758/s13428-011-0118-4
## Data available at: http://crr.ugent.be/blp
## This is a short subset (58 words, 78 participants).
## Copied from: immr24/data/blp-short2.csv (course data folder; no modifications)
## TODO: clarify which subset and how it was drawn; check whether it matches
## a named BLP sub-release on OSF

blp_short2 <- readr::read_csv("inst/extdata/blp-short2.csv", show_col_types = FALSE) |>
  dplyr::rename(item = spelling) |>
  dplyr::mutate(
    item        = factor(item),
    participant = factor(participant)
  )

usethis::use_data(blp_short2, overwrite = TRUE)
