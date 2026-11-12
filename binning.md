# Binning

The vpc functions provides various options for binning (`bins=` argument):

- `time`:  Divide bins equally over time (or whatever independent variable is used). Recommended only when there is no observable clustering in the independent variable.
- `data`: Divide bins equally over the amount of data ordered by independent variable, i.e. each bin contains approximately the same number of observations. Recommended only when data are for nominal timepoints _and_ all datapoints are available.
- `density`: Divide bins based on data-density, i.e. place the bin-separators at nadirs in the density function. An approximate number of bins can be specified, but it is not certain that the algorithm will strictly use the specified number. More info in `?auto_bin()`.
- `jenks`: Default and recommended method. Jenk's natural breaks optimization, similar to K-means clustering.
- `kmeans`: K-means clustering.
- `pretty`, `quantile`, `hclust`, `sd`, `bclust`, `fisher`. Methods provided by the `classInt` package, see the package help for more information.
- a numeric vector with the bin separators, e.g. `bins = c(0, 2, 4, 6, 8, 12, 24)`.

The number of bins is set with `n_bins`. With the default `n_bins = "auto"`, the `classInt` methods determine the number of bins themselves, while `time`, `data`, and `density` revert to 8 bins.

## Binning per stratum

By default, the same bins are used for all strata. When the design differs between strata (e.g. different sampling schedules per study or dose group), the bins can be determined per stratum instead, with `bin_by_strata = TRUE` in `vpc()` and `vpc_cens()`. The automatic binning method is then applied to the data of each stratum separately:

    vpc(sim = sim, obs = obs, stratify = "study", bin_by_strata = TRUE)

Manual bins can be given per stratum by passing a list to `bins`, named by stratum (or unnamed, in the order of the strata). A list can also mix binning methods and numeric separators. Passing a list implies `bin_by_strata = TRUE`:

    vpc(sim = sim, obs = obs, stratify = "study",
        bins = list(A = c(0, 2, 6, 24), B = "jenks"))

`n_bins` can likewise be given per stratum, e.g. `n_bins = list(A = 5, B = 8)`. The bin separators shown in the plot are drawn per panel.

Some notes:

- With two stratification variables, the stratum name is the two values separated by a comma and a space, e.g. `"1, female"`. Missing values are shown as `"<NA>"`, and commas or backslashes within values are escaped by a backslash.
- Missing values of the stratification variable form their own stratum. For manual bins, use an `NA` name (or `"NA"`, when no stratum has the literal value `"NA"`).
- With per-stratum binning, `db$bins` in the vpcdb object (`vpcdb = TRUE`) is a named list with one vector of bin separators per stratum.
- Per-stratum binning is not available for `bins = "percentiles"`.
