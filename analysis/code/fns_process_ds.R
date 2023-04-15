
# PURPOSE	Create datasets, fns that only need to be sourced once
# README	readme
# DATE		2023-04-13

# Packages
pacman::p_load(tidyverse,
							 here,
							 croquet,
							 openxlsx)

# 1: Survey ==================================================================
source(here::here("code/fns_process/fn_survey.R"))

survey <- readRDS(here::here("data/survey.RDS"))

wb <- createWorkbook()
add_labelled_sheet(survey)
saveWorkbook(wb, here::here("data/survey_labelled.xlsx"))


# 2: App ==================================================================
source(here::here("code/fns_process/fn_app.R"))

app <- readRDS(here::here("data/app.RDS"))

wb <- createWorkbook()
add_labelled_sheet(app)
saveWorkbook(wb, here::here("data/app_labelled.xlsx"))
