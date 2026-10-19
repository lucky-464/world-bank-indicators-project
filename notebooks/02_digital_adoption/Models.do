clear all
set more off

* Set the working directory to the folder containing the panel
* Change this path if you move the project
cd "/Users/abhishek/Desktop/world-bank-indicators-project/notebooks/02_digital_adoption"

* Load the clean panel
import delimited "panel_task2.csv", clear

* Drop rows where the lag is missing (the first year per country)
drop if missing(it_lag1)

* Generate the interaction term
gen it_lag1_x_gap = it_lag1 * gender_gap

* --- Model 1: Productivity FE ---
* Outcome: slgdppcapemkd (GDP per person employed)
reghdfe slgdppcapemkd it_lag1 nygdppcapppkd seterenrr ///
    netrdgnfszs spurbtotlinzs egelcaccszs ///
    gov_wgi_ge_est gov_wgi_rq_est, ///
    absorb(country year) vce(cluster country)

estimates store m_prod

* --- Model 2: Female LFP FE ---
* Outcome: sltlfcactfezs (Female labour-force participation)
reghdfe sltlfcactfezs it_lag1 nygdppcapppkd seterenrr ///
    netrdgnfszs spurbtotlinzs egelcaccszs ///
    gov_wgi_ge_est gov_wgi_rq_est, ///
    absorb(country year) vce(cluster country)

estimates store m_lfp

* --- Model 3: Female LFP with gender gap interaction ---
reghdfe sltlfcactfezs it_lag1 gender_gap it_lag1_x_gap ///
    nygdppcapppkd seterenrr ///
    netrdgnfszs spurbtotlinzs egelcaccszs ///
    gov_wgi_ge_est gov_wgi_rq_est, ///
    absorb(country year) vce(cluster country)

estimates store m_int

* --- Export results to a text table ---
* Note: This requires outreg2 to be installed (ssc install outreg2)
outreg2 [m_prod m_lfp m_int] using "stata_coef_table.txt", replace
