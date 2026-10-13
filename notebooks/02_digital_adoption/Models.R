library(fixest)
library(readr)
library(dplyr)

df <- read_csv("panel_task2.csv", show_col_types = FALSE)

# drop rows with missing lag (first year per country)
df <- df %>% filter(!is.na(IT_lag1))

regressors <- c(
  "IT_lag1",
  "NY.GDP.PCAP.PP.KD",
  "SE.TER.ENRR",
  "NE.TRD.GNFS.ZS",
  "SP.URB.TOTL.IN.ZS",
  "EG.ELC.ACCS.ZS",
  "GOV_WGI_GE_EST",
  "GOV_WGI_RQ_EST"
)

formula_str <- paste(
  "SL.GDP.PCAP.EM.KD ~",
  paste(regressors, collapse = " + "),
  "| country + year"
)

form <- as.formula(formula_str)

m_prod <- feols(form, data = df, cluster = ~country)

summary(m_prod)

withr::with_options(
  list(width = 200),
  etable(m_prod, file = "r_results_productivity.txt", replace = TRUE)
)
formula_lfp_str <- paste(
  "SL.TLF.CACT.FE.ZS ~",
  paste(regressors, collapse = " + "),
  "| country + year"
)

df <- df %>% mutate(IT_lag1_x_gap = IT_lag1 * gender_gap)

interaction_regs <- c(
  "IT_lag1",
  "gender_gap",
  "IT_lag1_x_gap",
  "NY.GDP.PCAP.PP.KD",
  "SE.TER.ENRR",
  "NE.TRD.GNFS.ZS",
  "SP.URB.TOTL.IN.ZS",
  "EG.ELC.ACCS.ZS",
  "GOV_WGI_GE_EST",
  "GOV_WGI_RQ_EST"
)

formula_int_str <- paste(
  "SL.TLF.CACT.FE.ZS ~",
  paste(interaction_regs, collapse = " + "),
  "| country + year"
)

form_int <- as.formula(formula_int_str)

m_int <- feols(form_int, data = df, cluster = ~country)

summary(m_int)

etable(m_int, file = "r_results_interaction.txt", replace = TRUE)

form_lfp <- as.formula(formula_lfp_str)

m_lfp <- feols(form_lfp, data = df, cluster = ~country)

summary(m_lfp)

etable(m_lfp, file = "r_results_flfp.txt", replace = TRUE)

