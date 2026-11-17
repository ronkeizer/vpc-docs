# Censored data

The `vpc_cens()` function can be used to create a VPC for the probability of left- or right-censoring such as in the case of data being lower than the lower limit of quantification (&lt;LLOQ) or being above the upper limit of quantification (&gt;ULOQ).

There is no need to add a variable to the dataset to flag the censored cases, the function only requires the `lloq` or `uloq`. Make sure you set the censored cases to any value below `lloq` or above `uloq`, respectively.

_Note: do **not** set the values exactly at the limit, since then these values will be assumed to be actually measured at the limit._

_Note: missing values (`NA`) are **not** treated as censored. Records with a missing dependent variable are removed with a warning. To count a value as censored, supply a value below `lloq` (or above `uloq`)._

The example below artificially induces an LLOQ of 30 for the example dataset, and generates a VPC for the probability of left-censoring.

    vpc_cens(sim = simple_data$sim, obs = simple_data$obs, lloq = 30)

The vpc for the uncensored (continuous) data will show the censoring limit as a horizontal line, and will also visualize the uncensored simulated data below `lloq` or above `uloq`:

    vpc(sim = simple_data$sim, obs = simple_data$obs, lloq = 30)

Observed percentiles that fall within the censored part of the distribution are not shown. The lower and upper observed percentile lines are drawn separately, so a censored lower percentile in a bin does not hide the upper one.

## Stratification

`vpc_cens()` supports faceting with `stratify`, and coloring with `stratify_color`. With `stratify_color`, the observed fraction and simulated confidence interval are calculated per color stratum and drawn in separate colors:

    vpc_cens(sim = sim, obs = obs, lloq = 5, stratify_color = "dose")

Bins can also be determined per stratum with `bin_by_strata = TRUE`, see [Binning](binning.md).

## Censored values in the vpcdb object

Internally, censored values are represented as `-Inf` (below `lloq`) or `Inf` (above `uloq`), also after prediction- or reference-correction. They are returned that way in `obs$dv` and `sim$dv` of the vpcdb object (`vpcdb = TRUE`), and are not drawn by `plot_vpc()`. Code that used `is.na()` to find censored values in the vpcdb data should use `is.infinite()` instead. The `log_y` floor (`log_y_min`) does not apply to censored values.

`quantile_cens()` follows the same conventions: `-Inf`/`Inf` (and values beyond `limit`) are censored, and `NA` is ignored.
