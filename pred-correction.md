# Prediction / reference correction

## Prediction-corrected VPC (pcVPC)

An explanation of prediction-correction and why it is (sometimes) necessary is provided in [this article by Bergstrand et al.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3085712). Prediction correction is implemented in this package using the `pred_corr` argument to the `vpc()` function. For example, the following command will perform the prediction-correction and also plot the observed data:

    vpc (sim = sim, obs = obs, pred_corr = TRUE, show=list(obs_dv = TRUE, obs_ci = TRUE))

_Note: if there is a lower limit to the observations, this needs to be specified too using the `pred_corr_lower_bnd=` argument._

The population prediction is read from the `pred` column (`PRED` for NONMEM data). When PRED is taken from the simulated data, the first replicate is used, so its records (`id`, `idv`) should be in the same order as the observed data.

### Additive (LTBS) correction

The default is the multiplicative correction of Bergstrand et al. For log-transform-both-sides (LTBS) models, an additive correction can be used with `pred_corr_method = "additive"` (or the shortcut `ltbs = TRUE`). This computes `dv + (pred_bin - pred)`, where `pred_bin` is the median prediction in the bin:

    vpc(sim = sim, obs = obs, pred_corr = TRUE, pred_corr_method = "additive")

The additive form assumes that `dv` and `pred` are _already on the log scale_ in both the observed and simulated data. No transformation is done internally, so `log_y` cannot be combined with it, and `pred_corr_lower_bnd` is ignored. For many LTBS workflows, the default multiplicative correction on linear-scale data combined with `log_y = TRUE` is already adequate.

### pcVPC with censored data

When `pred_corr = TRUE` is combined with `lloq` or `uloq`, observed and simulated data are handled identically:

1. Censoring is determined on the _uncorrected_ DV.
2. The median prediction per bin is calculated from all records in the bin, including censored ones.
3. Only non-censored values are prediction-corrected.
4. Censored values are kept (ranked below `lloq` or above `uloq`) when calculating percentiles. Percentiles that fall within the censored part of the distribution are not shown.

Since corrected values are no longer on the scale of the limit of quantification, they are not compared to the limit again, and the LLOQ/ULOQ line is not drawn.

## Reference-corrected VPC (rcVPC)

A reference-corrected VPC ([Ibrahim et al., AAPS J 2025](https://doi.org/10.1208/s12248-025-01065-2)) normalizes observed and simulated data to a _reference_ dataset, in which selected independent variables (e.g. dose, covariates, time) are set to reference values. Compared to a pcVPC, it also corrects for the variability, and the corrected data stay on the scale of the reference dataset.

To create an rcVPC, supply simulations of the reference dataset with the `sim_ref` argument. `sim_ref` must have the same format and columns as `sim`, including the population prediction in the `pred` column:

    vpc(sim = sim, obs = obs, sim_ref = sim_ref)

Some notes:

- Records are matched **by position**, so `obs` and every replicate in `sim` and `sim_ref` must contain the same records in the same order.
- The correction is done per record, before binning.
- For data on the normal scale (default), the lower bound is taken from `pred_corr_lower_bnd` (default 0). Records with DV at or below the lower bound are excluded with a warning.
- For data on the log scale, use `pred_corr_method = "additive"` (or `ltbs = TRUE`) to select the log-scale equations. `pred_corr_lower_bnd` is then ignored, and negative (log-scale) DV values are valid.
- Censored data are handled as for the pcVPC, except that simulated values are censored _after_ correction, so that the variability correction is based on all simulated data.
- `pred_corr` and `sim_ref` cannot be combined.

The implementation was validated against Pharmpy's implementation of the PsN rcVPC.
