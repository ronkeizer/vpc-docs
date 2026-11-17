# Overview functionality

There are four main functions in the vpc package:

- `vpc()`: VPC for continuous data
- `vpc_cat()`: VPC for categorical data
- `vpc_cens()`: VPC for censored continuous data (e.g. data < LOQ)
- `vpc_tte()`: VPC for (repeated) time-to-event data

The main arguments to these function are the `sim` and `obs` arguments, which specify a simulation dataset and an observation dataset. All other arguments can be used to customize data parsing and visual appearance of the VPC such as stratification and binning. All four functions will return a ggplot2 object.

## Using PsN-generated data

The `vpc` tool in PsN conveniently outputs observation and simulation data from a NONMEM model, and calculates statistics for the VPC. The `vpc` package in R can use these observation and simulation data files and create a VPC from that. This is easily implemented using e.g.:

    vpc(psn_folder = "vpc_dir1")

This will automatically excract the simulation and observation data, perform the required calculations, and plot the VPC. Note that the `psn_folder` argument is available for all four `vpc_`-functions.

## Separation of calculations and plotting

With the *vpc* package you can easily separate the process of calculating the statistics and plotting of those statistics. This can be useful if the calculation of the statistics is slow, or if you want to use the statistics for numerical comparisons.

By default, using one of the four functions listed above, both the calculations and the plotting is done in a single step, and the statistics are not made available. To create a vpc *database* object and not directly plot the statistics, use the `vpcdb=TRUE` argument:

    vpc1 <- vpc(sim = sim, obs = obs, vpcdb = TRUE)

This will return the statistics as a *list*. You can inspect the data and stats in the database object by just calling it on the console:

    vpc1

You can then use the `plot_vpc()` function to actually plot the *vpc*, potentially changing some of the layout or theming of the *vpc*:

    plot_vpc(
      vpc1,
      show = list(obs_dv = TRUE, obs_ci = FALSE),
      xlab = "Time (hours)", ylab = "Concentration", title="VPC!")

If you want to use a standard or custom ggplot-theme, just add it on top (load the ggplot2 library first):

    plot_vpc(vpc1) + theme_bw()

See the customization section for more information regarding theming and plotting.

_Note: in the vpcdb object, censored observations are stored as `-Inf` (below `lloq`) or `Inf` (above `uloq`), see [Censored data](censored-data.md)._
