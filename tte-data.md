# Time-to-event data

Similar to the VPC for continuous data, the VPC for TTE data requires simulated data. In general, there are two distinct approach to simulate survival data:

- *Hazard integration*: Integrate the hazard over time, and at *any possible* observation timepoint randomly draw a binary value based on the probability of observing the event. The disadvantage of this method is that it is slow due to the numerical solving of the ODEs. Also, a dataset with a dense design grid has to be used for simulation, i.e. one that has observation times at every possible timepoint that an event can occur for all individuals.

- *Direct sampling*: Sample event times directly from the distribution used to model the data (e.g. Weibull, exponential, Gompertz). Advantages of this approach is that it is much faster, and it does not require a dense grid. The disadvantage with this approach is however that the hazard is assumed constant over time, so models with time-dependent hazards cannot easily be simulated with this approach. This approach is straightforward in R but cannot easily be implemented in NONMEM. Example will follow soon.

An example for time-to-event data is shown below. The datasets are supplied with the `vpc` library.

    data(rtte_obs_nm)
    data(rtte_sim_nm)

Treat RTTE as TTE, no stratification:

    vpc_tte(sim = rtte_sim_nm,
            obs = rtte_obs_nm,
            rtte = FALSE,
            sim_cols = list(dv = "dv", idv="t"),
            obs_cols = list(idv = "dt"))

Stratified for covariate and study arm, and binned and smooth:

    vpc_tte(sim = rtte_sim_nm,
            obs = rtte_obs_nm,
            stratify = c("sex","drug"),
            rtte = FALSE,
            bins = "kmeans",
            n_bins = 20,
            smooth = TRUE,
            sim_cols = list(dv = "dv", idv="t"),
            obs_cols = list(idv = "dt"))

Stratified for event number (RTTE) and study arm:

    vpc_tte(sim = rtte_sim_nm,
            obs = rtte_obs_nm,
            rtte = TRUE, rtte_calc_diff = TRUE, events = c(1:3),
            stratify=c("drug"),
            bins = "time",
            n_bins = 20,
            smooth = TRUE,
            sim_cols = list(dv = "dv", idv="t"),
            obs_cols = list(idv = "t"), verbose=TRUE)

## Confidence intervals

The `ci` argument sets the confidence interval of the Kaplan-Meier curve of the observed data, and `ci_sim` (default `c(0.05, 0.95)`) the confidence interval of the Kaplan-Meier curves from the simulated data:

    vpc_tte(sim = rtte_sim_nm,
            obs = rtte_obs_nm,
            rtte = FALSE,
            ci_sim = c(0.025, 0.975),       # 95% interval of the simulated curves
            sim_cols = list(dv = "dv", idv="t"),
            obs_cols = list(idv = "dt"))

## Notes on binning and smoothing

In principle, the `vpc_tte()` function does allow binning and *smoothing* like commonly applied to a regular *vpc*. However, the binning and smoothing often makes the bins go over the 0 - 100% interval and some elements of the confidence interval may not be shown correctly or even missing from the plot. It is therefore advised to not apply binning for time-to-event data, and to just use the *'bins'* generated from the simulated data. The bins are basically based on all unique timepoints for all events the simulations dataset.


## Kaplan-Meier Mean Covariate plots (KMMC)

KMMC plots have been [presented by Andy Hooker](https://www.page-meeting.org/default.asp?abstract=2564) as a model diagnostic for covariate inclusion. They can be created using the same `vpc_tte()` function by specifying the relevant predictor to the `kmmc` argument, as shown below. In contrast to regular time-to-event VPCs, binning is recommended for the KMMC plot. When stratified, the KMMC curve is computed per stratum.

    vpc_tte(sim = rtte_sim_nm,
            obs = rtte_obs_nm,
            rtte = FALSE,
            bins=c(10, 20, 40, 60, 80, 100), # binning is recommended with KMMC
            kmmc = "sex",
            sim_cols = list(dv = "dv", idv="t"),
            obs_cols = list(idv = "dt"))
