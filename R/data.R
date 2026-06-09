#' Rat tumour incidence data
#'
#' Tumour incidence in 71 groups (batches) of female lab rats from a study on
#' the carcinogenic effects of phenformin.
#' The data are widely used as a worked example for hierarchical binomial models
#' and Bayesian partial pooling.
#'
#' @format A tibble with 71 rows and 3 columns:
#' \describe{
#'   \item{batch}{Integer. Batch (group) number, 1 to 71.}
#'   \item{m}{Integer. Number of rats in the batch that developed a tumour.}
#'   \item{n}{Integer. Total number of rats in the batch.}
#' }
#'
#' @source Tarone, R.E. (1982). The use of historical control information in
#'   testing for a trend in proportions. \emph{Biometrics}, \strong{38},
#'   215--220.
#'   Reproduced as Table 5.1 in: Gelman, A., Carlin, J.B., Stern, H.S., Dunson,
#'   D.B., Vehtari, A., and Rubin, D.B. (2013). \emph{Bayesian Data Analysis},
#'   3rd ed. Chapman & Hall/CRC.
#'   Raw data at \url{https://sites.stat.columbia.edu/gelman/book/data/rats.asc}.
"rats"


#' Classroom mathematics achievement data
#'
#' Mathematics test scores for 1,190 students nested within 312 classrooms and
#' 107 schools.
#' The three-level structure (student, classroom, school) makes this a standard
#' teaching example for multilevel models.
#'
#' @format A tibble with 1,190 rows and 5 columns:
#' \describe{
#'   \item{mathscore}{Integer. Student mathematics test score.}
#'   \item{ses}{Numeric. Student socioeconomic status (standardised).}
#'   \item{classid}{Factor. Unique classroom identifier (312 levels).}
#'   \item{schoolid}{Factor. School identifier (107 levels).}
#'   \item{classid2}{Factor. Classroom number within school (levels 1 to 9).}
#' }
#'
#' @source Provenance uncertain; likely derived from or related to data used in:
#'   Gelman, A. and Hill, J. (2007). \emph{Data Analysis Using Regression and
#'   Multilevel/Hierarchical Models}. Cambridge University Press.
#'   Replication data at
#'   \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/10285}.
#'   Possibly based on: Hill, H.C., Rowan, B., and Ball, D.L. (2005). Effects
#'   of teachers' mathematical knowledge for teaching on student achievement.
#'   \emph{American Educational Research Journal}, \strong{42}, 371--406.
"classroom"


#' Per capita alcohol consumption by country and year
#'
#' Recorded per capita alcohol consumption (litres of pure alcohol, adults aged
#' 15 and over) for 190 countries over the period 1985 to 2008.
#' Sourced from the WHO Global Information System on Alcohol and Health (GISAH).
#'
#' @format A tibble with 411 rows and 3 columns:
#' \describe{
#'   \item{country}{Factor. Country name. Levels are in alphabetical order.}
#'   \item{year}{Integer. Year of measurement (1985 to 2008).}
#'   \item{alcohol}{Numeric. Recorded per capita consumption in litres of pure
#'     alcohol per year.}
#' }
#'
#' @source World Health Organization Global Information System on Alcohol and
#'   Health (GISAH).
#'   \url{https://www.who.int/data/gho/indicator-metadata-registry/imr-details/462}
"alcohol"


#' British Lexicon Project: short subset
#'
#' A short subset of lexical decision data from the British Lexicon Project
#' (BLP), covering 58 words and 78 participants.
#' Participants responded to visually presented words and nonwords; only the
#' word trials are included here.
#' Response times are in milliseconds; missing values indicate non-responses or
#' excluded trials.
#'
#' @format A tibble with 662 rows and 6 columns:
#' \describe{
#'   \item{item}{Factor. Word spelling.}
#'   \item{participant}{Factor. Participant identifier.}
#'   \item{rt}{Numeric. Lexical decision response time in milliseconds.
#'     \code{NA} indicates a missing or excluded response.}
#'   \item{old20}{Numeric. Orthographic Levenshtein distance to the 20 nearest
#'     orthographic neighbours (OLD20); a measure of orthographic similarity to
#'     other words.}
#'   \item{nletters}{Integer. Number of letters in the word.}
#'   \item{freq}{Numeric. Word frequency (per million words, CELEX corpus).}
#' }
#'
#' @source Keuleers, E., Lacey, P., Rastle, K., and Brysbaert, M. (2012). The
#'   British Lexicon Project: Lexical decision data for 28,730 monosyllabic and
#'   disyllabic English words. \emph{Behavior Research Methods}, \strong{44},
#'   287--304. \doi{10.3758/s13428-011-0118-4}.
#'   Full dataset at \url{http://crr.ugent.be/blp}.
"blp_short2"


#' Psychomotor vigilance task reaction time data
#'
#' Reaction times from a psychomotor vigilance task (PVT) administered to 18
#' participants over ten days of partial sleep deprivation (three hours per
#' night).
#' The data are a renamed and relabelled version of \code{lme4::sleepstudy},
#' which was originally collected by Belenky et al. (2003).
#' Subject labels have been changed from numeric codes (308, 309, ...) to
#' \code{s1}, \code{s2}, and so on.
#'
#' @format A tibble with 180 rows and 3 columns:
#' \describe{
#'   \item{rt}{Numeric. Mean reaction time in milliseconds on the PVT for that
#'     day.}
#'   \item{day}{Integer. Day of sleep deprivation (0 to 9; day 0 is baseline
#'     before deprivation began).}
#'   \item{id}{Factor. Participant identifier (\code{s1} to \code{s18}).}
#' }
#'
#' @source Belenky, G., Wesensten, N.J., Thorne, D.R., Thomas, M.L., Sing,
#'   H.C., Redmond, D.P., Russo, M.B., and Balkin, T.J. (2003). Patterns of
#'   performance degradation and restoration during sleep restriction and
#'   subsequent recovery: A sleep dose-response study.
#'   \emph{Journal of Sleep Research}, \strong{12}, 1--12.
#'   \doi{10.1046/j.1365-2869.2003.00337.x}.
#'   Available in R as \code{lme4::sleepstudy}.
"pvtrt"
