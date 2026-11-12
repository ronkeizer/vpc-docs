# Stratification

Example with stratification by covariate `sex`:

    vpc (sim = sim, obs = obs, stratify = c("sex"), facet = "rows")

The `vpc_` functions in this packages allow stratification by 2 variables (horizontal and vertical faceting). If more strata are desired, a new combined variable should be defined that defines the factors. When the stratification variables are factors, the order of the panels follows the factor levels.

Missing values of a stratification variable form their own stratum. With two stratification variables, they are labeled `"<NA>"` in the combined stratum (e.g. `"<NA>, X"`), so that they are kept separate from a literal value `"NA"`.

By default the same bins are used for every stratum. To determine bins separately for each stratum, use `bin_by_strata = TRUE`, see [Binning](binning.md).

## Stratification by color

`vpc_cens()` and `vpc_tte()` also accept a `stratify_color` argument. The VPC statistics are then calculated per value of that variable and drawn in separate colors (with a legend) within the same panel, while the facets are determined by `stratify` only:

    vpc_cens(sim = sim, obs = obs, lloq = 5,
             stratify = "study", stratify_color = "dose")

_Note: The output from the `vpc()` functions are ggplot2-objects, and they can easily be extended and themed using the well-known functions from the ggplot2 package. One cautionary note however is that you should refrain from applying any additional faceting functions after the VPC has been created. In other words, faceting should be done using the `vpc()` functions (`stratify`=... argument). Otherwise you will end up with funky (in the best case) or misleading (in the worst case) plots._
