# Code for the paper "Optimal Convergence for Agnostic Kernel Learning with Random Features"

## Environments
- Matlab 2023a

## Folders
- `./data` contains processed datasets in `.mat` files.
- `./results` records the variables in experiments and final results printed in `.pdf` files.


## How to RUN
- Tuning the hyperparameter $\sigma^2$: Run `run_select_sigma.m`.
- Tuning the hyperparameter $\lambda$: Run `run_select_lambda.m`.
- Comparison Experiment
  - Run `run_rf_leverage.m` to obtain figures in Figs. 4 - 5.
  - Run `draw_figs.m` to illustrate results w.r.t. $M$ in Fig. 6.
  - Run `run_table.m` to obtain results in TABLE II.