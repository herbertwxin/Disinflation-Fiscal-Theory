# Disinflation-Fiscal-Theory
Preview of draft and code on my working paper "Difference in cost of disinflation between monetary-led and fiscal-led regime"

## Dynare (.mod) file naming convention
The dynare file used in this project follows the following naming convention. 
"modeltype_surplusrule_longtermdebt_zerolowerbound"
i.e. (The framework the model uses)_(surplus rule for the model)_(whether long term debt is enabled)_(ZLB enfored)
example: "NK_SS_LTB" means under simple NK framework with simpel surplus rule and long-term debt

### Explanation to abbreviation
NK - Simple New Keyesian
SW - Smets & Wouters (2007)
SS - Simple surplus rule
CS - Complex surplus rule
LTB - Long-term debt

## Simple Model (Simple NK)
Run the Plot_Simple_IRF.mlx to produce all the IRFs for the simple model.
autoplot_simple.m is the MATLAB function behind for all the disinflation simulation.
Zero lower bound is hardcoded into the disinflation simulation function.


## Smets and Wouters Model
