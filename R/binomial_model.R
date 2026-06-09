#' Fit a binomial model
#'
#' Estimates the probability of success from binomial count data.
#' Handles a single pooled estimate, unpooled per-group estimates, and a
#' multilevel (partial pooling) model, without requiring the caller to deal
#' with `cbind`, `family = binomial()`, log-odds transforms, or the underlying
#' model objects.
#'
#' @param successes <[`data-masking`][rlang::args_data_masking]> Number of
#'   successes. Unquoted column name when `data` is supplied, or a numeric
#'   vector.
#' @param trials <[`data-masking`][rlang::args_data_masking]> Number of trials.
#' @param group <[`data-masking`][rlang::args_data_masking]> Optional grouping
#'   variable. When omitted, a single pooled probability is estimated.
#' @param data A data frame.
#' @param multilevel Logical. When `TRUE` and `group` is supplied, fits a
#'   multilevel model with normally distributed random intercepts via
#'   [lme4::glmer()]. Default `FALSE`.
#' @param conf_level Confidence level. Default `0.95`.
#'
#' @return An object of class `binomial_model`. Components vary by model type:
#'
#' **Pooled** (no `group`):
#' - `$estimate` — probability estimate
#' - `$conf_int` — named vector `c(lower, upper)` on the probability scale
#'
#' **Unpooled** (`group`, `multilevel = FALSE`):
#' - `$estimates` — tibble with columns `group`, `estimate`, `lower`, `upper`
#'
#' **Multilevel** (`group`, `multilevel = TRUE`):
#' - `$estimate` — grand mean probability (fixed effect, probability scale)
#' - `$conf_int` — CI on the grand mean
#' - `$prediction_int` — predictive interval for a new group
#'   (grand mean ± z·τ, probability scale)
#' - `$tau` — random-effects SD on the log-odds scale
#' - `$estimates` — tibble of partial-pooled per-group probabilities
#' - `$random_effects` — tibble of group-level deviations (log-odds scale)
#'
#' All types also store the underlying model object as `$model`.
#'
#' @examples
#' # Single group
#' M1 <- binomial_model(m, n, data = dplyr::filter(rats, batch == 42))
#' M1$estimate
#' M1$conf_int
#'
#' # All groups pooled into one estimate
#' M2 <- binomial_model(m, n, data = rats)
#'
#' # Unpooled: separate estimate per group
#' M3 <- binomial_model(m, n, group = batch, data = rats)
#' M3$estimates
#'
#' # Multilevel: partial pooling across groups
#' M4 <- binomial_model(m, n, group = batch, data = rats, multilevel = TRUE)
#' M4$estimate
#' M4$conf_int
#' M4$prediction_int
#' M4$tau
#' M4$estimates
#'
#' @importFrom rlang enquo eval_tidy quo_is_null
#' @export
binomial_model <- function(successes, trials, group = NULL, data = NULL,
                           multilevel = FALSE, conf_level = 0.95) {
  m <- rlang::eval_tidy(rlang::enquo(successes), data)
  n <- rlang::eval_tidy(rlang::enquo(trials), data)
  group_quo <- rlang::enquo(group)
  alpha <- 1 - conf_level

  if (rlang::quo_is_null(group_quo)) {
    .binomial_pooled(m, n, alpha, conf_level)
  } else {
    g <- rlang::eval_tidy(group_quo, data)
    if (multilevel) {
      .binomial_multilevel(m, n, g, alpha, conf_level)
    } else {
      .binomial_unpooled(m, n, g, alpha, conf_level)
    }
  }
}

.binomial_pooled <- function(m, n, alpha, conf_level) {
  df  <- data.frame(m = m, n = n)
  fit <- glm(cbind(m, n - m) ~ 1, data = df, family = binomial())
  ci  <- confint.default(fit, level = conf_level)
  structure(
    list(
      type       = "pooled",
      conf_level = conf_level,
      estimate   = plogis(coef(fit)[[1L]]),
      conf_int   = c(lower = plogis(ci[1L, 1L]), upper = plogis(ci[1L, 2L])),
      model      = fit
    ),
    class = "binomial_model"
  )
}

.binomial_unpooled <- function(m, n, g, alpha, conf_level) {
  # Use direct computation rather than a GLM so that batches with m = 0 or
  # m = n do not produce degenerate (±Inf) log-odds. Wilson score intervals
  # are used because they remain well-behaved at the boundaries.
  groups  <- if (is.factor(g)) levels(g) else sort(unique(g))
  m_j     <- vapply(groups, function(v) sum(m[g == v]), numeric(1L))
  n_j     <- vapply(groups, function(v) sum(n[g == v]), numeric(1L))
  cis     <- mapply(.wilson_ci, m_j, n_j, alpha, SIMPLIFY = TRUE)
  structure(
    list(
      type       = "unpooled",
      conf_level = conf_level,
      estimates  = tibble::tibble(
        group    = as.character(groups),
        estimate = m_j / n_j,
        lower    = cis["lower", ],
        upper    = cis["upper", ]
      )
    ),
    class = "binomial_model"
  )
}

.wilson_ci <- function(m, n, alpha) {
  z      <- qnorm(1 - alpha / 2)
  p      <- m / n
  denom  <- 1 + z^2 / n
  centre <- (p + z^2 / (2 * n)) / denom
  hw     <- z * sqrt(p * (1 - p) / n + z^2 / (4 * n^2)) / denom
  lower <- centre - hw
  upper <- centre + hw
  c(
    lower = if (lower < .Machine$double.eps) 0 else lower,
    upper = if (upper > 1 - .Machine$double.eps) 1 else upper
  )
}

.binomial_multilevel <- function(m, n, g, alpha, conf_level) {
  df  <- data.frame(m = m, n = n, group = factor(g))
  fit <- lme4::glmer(
    cbind(m, n - m) ~ 1 + (1 | group),
    data = df, family = binomial()
  )
  b    <- lme4::fixef(fit)[[1L]]
  b_se <- as.numeric(sqrt(vcov(fit)[1L, 1L]))
  z    <- qnorm(1 - alpha / 2)
  tau  <- sqrt(as.numeric(lme4::VarCorr(fit)$group))

  coef_df  <- coef(fit)$group
  re_obj   <- lme4::ranef(fit, condVar = TRUE)
  re_df    <- re_obj$group
  # Conditional variance of each xi_j given data and estimated parameters.
  # postVar is a 1x1xJ array; as.numeric() flattens it to a length-J vector.
  cond_var <- as.numeric(attr(re_df, "postVar"))
  beta_j   <- coef_df[, 1L]
  # Approximate SE: combines conditional uncertainty in xi_j with uncertainty
  # in the grand mean b (treated as independent — a standard approximation).
  se_j     <- sqrt(cond_var + b_se^2)

  structure(
    list(
      type           = "multilevel",
      conf_level     = conf_level,
      estimate       = plogis(b),
      conf_int       = c(lower = plogis(b - z * b_se),
                         upper = plogis(b + z * b_se)),
      prediction_int = c(lower = plogis(b - z * tau),
                         upper = plogis(b + z * tau)),
      mu             = b,
      tau            = tau,
      estimates      = tibble::tibble(
        group    = rownames(coef_df),
        estimate = plogis(beta_j),
        lower    = plogis(beta_j - z * se_j),
        upper    = plogis(beta_j + z * se_j)
      ),
      random_effects = tibble::tibble(
        group         = rownames(re_df),
        random_effect = re_df[, 1L]
      ),
      model = fit
    ),
    class = "binomial_model"
  )
}

#' @export
print.binomial_model <- function(x, ...) {
  pct <- round(x$conf_level * 100)
  if (x$type == "pooled") {
    cat("Binomial model (pooled)\n\n")
    cat(sprintf("  Estimate  :  %.4f\n", x$estimate))
    cat(sprintf("  %d%% CI    :  [%.4f, %.4f]\n",
                pct, x$conf_int["lower"], x$conf_int["upper"]))
  } else if (x$type == "unpooled") {
    cat("Binomial model (unpooled)\n\n")
    print(x$estimates, ...)
  } else {
    cat("Binomial model (multilevel)\n\n")
    cat(sprintf("  Grand mean      :  %.4f  [%.4f, %.4f]  (%d%% CI)\n",
                x$estimate, x$conf_int["lower"], x$conf_int["upper"], pct))
    cat(sprintf("  Prediction int  :  [%.4f, %.4f]  (%d%% PI for new group)\n",
                x$prediction_int["lower"], x$prediction_int["upper"], pct))
    cat(sprintf("  Mu              :  %.4f  (grand mean, log-odds)\n", x$mu))
    cat(sprintf("  Tau             :  %.4f  (random-effects SD, log-odds)\n",
                x$tau))
    cat("\nGroup estimates (partial pooling):\n")
    print(x$estimates, ...)
  }
  invisible(x)
}
