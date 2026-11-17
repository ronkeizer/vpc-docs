# Continuous data

Load the library and get the observation data and simulation data.
In the first example, we'll use a simulated dataset included with the `vpc` package.

    library(vpc)
    vpc(sim = simple_data$sim, obs = simple_data$obs)
    vpc(sim = simple_data$sim, obs = simple_data$obs, lloq = 20)

However, instead we could use observation and simulation data from NONMEM, e.g. (not run):

    obs <- read_table_nm("sdtab1")   # an output table with at least ID, TIME, DV
    sim <- read_table_nm("simtab1")  # a simulation file with at least ID, TIME, DV

The `read_table_nm()` function <sup>\*1</sup> comes with the `vpc` library and is a fast way to read in output data created from the $TABLE record in NONMEM, including tables with multiple subproblems.

_Note: If you imported the data from NONMEM, the VPC function will automatically detect column names from NONMEM, such as ID, TIME, DV. If you simulated data in R or got the data from a different software, you will probably have to change the variable names for the dependent and independent variable, and the individual index. The ID column may be numeric or character (e.g. as produced by nlmixr2)._

Next, the VPC can simply be created using:

    vpc (sim = sim, obs = obs)

All the lines and *areas* shown in the plot can be customized in terms of the statistics they show (i.e. the bins, the quantiles for the confidence intervals, prediction-correction, etc), but also esthetic aspects such as the color, size, transparency, etc.

An example with more explicit use of options and theming:

    vpc(sim = sim,
           obs = obs,                               # supply simulation and observation dataframes
           obs_cols = list(
             dv = "dv",                             # these column names are the default,
             idv = "time"),                         # update these if different.
           sim_cols = list(
             dv = "sdv",
             idv = "time"),
           bins = c(0, 2, 4, 6, 8, 10, 16, 25),     # specify bin separators manually
           stratify = c("sex"),                     # multiple stratifications possible, just supply as vector
           pi = c(0.05, 0.95),                      # prediction interval simulated data to show
           ci = c(0.05, 0.95),                      # confidence intervals to show
           pred_corr = FALSE,                       # perform prediction-correction?
           show = list(obs_dv = TRUE),              # plot observations?
           facet = "rows",                          # wrap stratifications, or as "row" or "column"
           ylab = "Concentration",
           xlab = "Time (hrs)")



_<sup>*1</sup> originally written by Benjamin Guiastrennec._
