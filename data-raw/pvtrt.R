## code to prepare `pvtrt` dataset goes here

pvtrt <- tibble::as_tibble(lme4::sleepstudy) |>
  dplyr::rename(rt = Reaction, day = Days, id = Subject) |>
  dplyr::mutate(
    id = stringr::str_c("s", as.numeric(id)),
    id = factor(id, levels = unique(id))
  )

usethis::use_data(pvtrt, overwrite = TRUE)
