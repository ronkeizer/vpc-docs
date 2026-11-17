# Stratification

Example with stratification by covariate `sex`:

    vpc (sim = sim, obs = obs, stratify = c("sex"), facet = "rows")

`vpc()`, `vpc_cens()`, and `vpc_tte()` allow stratification by 2 variables (horizontal and vertical faceting); for repeated time-to-event data (`vpc_tte(rtte = TRUE)`) only 1 variable is supported. (`vpc_cat()` has no `stratify` argument, since its panels are the categories.) If more strata are desired, a new combined variable should be defined that defines the factors. When the stratification variables are factors, the order of the panels follows the factor levels.

Missing values of a stratification variable form their own stratum. With two stratification variables, they are labeled `"<NA>"` in the combined stratum (e.g. `"<NA>, X"`), so that they are kept separate from a literal value `"NA"`.

By default the same bins are used for every stratum. To determine bins separately for each stratum, use `bin_by_strata = TRUE`, see [Binning](binning.md).

## Stratification by color

`vpc_cens()` and `vpc_tte()` also accept a `stratify_color` argument (a single variable). The VPC statistics are then calculated per value of that variable and drawn in separate colors (with a legend) within the same panel.

In `vpc_cens()`, `stratify_color` can be combined with `stratify`, in which case the facets are determined by `stratify` only:

    vpc_cens(sim = sim, obs = obs, lloq = 5,
             stratify = "study", stratify_color = "dose")

In `vpc_tte()`, `stratify_color` is an alternative to `stratify`, and the two cannot be combined.

_Note: The output from the `vpc()` functions are ggplot2-objects, and they can easily be extended and themed using the well-known functions from the ggplot2 package. One cautionary note however is that you should refrain from applying any additional faceting functions after the VPC has been created. In other words, faceting should be done using the `vpc()` functions (`stratify`=... argument). Otherwise you will end up with funky (in the best case) or misleading (in the worst case) plots._
