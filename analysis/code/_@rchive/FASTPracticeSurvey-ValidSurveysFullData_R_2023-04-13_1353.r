fn_survey <- function(){
	
	# Import Danika's raw version with responses, but it was subset
	surv1 <- read.csv(here::here("data_raw/FASTPracticeSurvey_raw_20230310.csv")) |> 
		select(-prac_entity_split_id)
	
	survey <- surv1 |> 
		
	  mutate(
	  	
	  	state.fct = factor(
	  		state,
	  		levels=c(1,2,3,4,5,6,7,8,9,10),
	  		labels=c("AR","CO","IA","KS","NE","NV","NM","OK","UT","WY")),
	  	
	  	demog_data.fct  = factor(
	  		demog_data,
	  		levels = c(1,2,3),
	  		labels = c("EHR query/extract",
	  							 "Manual count",
	  							 "Best estimate or informed approximation")),
	  	
	  	inpatientcare.fct = factor(
	  		inpatientcare,
	  		levels = c(1,0,`-1`),
	  		labels = c("Yes","No, but visit","No")
	  	),
	  	
	  	teamlearn_formal_train.fct = factor(
	  		teamlearn_formal_train,
	  		levels = c(`-55`,0,1),
	  		levels = c("I dont know","No","Yes")),
	  	
	  	teamlearn_how_train.fct    =factor(
	  		teamlearn_how_train,
	  		levels = c(1,2,3),
	  		labels = c("Entire practice","Smaller team","Individual")),
	  	
	  	train_together.fct        = factor(
	  		train_together,
	  		levels = c(2,1,0),
	  		labels = c("Always or Almost Always","Sometimes","Rarely or Never")),
	  	
	  	train_small_teams.fct     = factor(
	  		train_small_teams, 
	  		levels = c(2,1,0),
	  		labels = c("Always or almost always","Sometimes","Rarely or Never")),
	  	
	  	train_idv.fct             = factor(
	  		train_idv,
	  		levels = c(2,1,0),
	  		labels = c("Always or Almost Always","Sometimes","Rarely or Never"))
	  	) |> 
		
		labelled::set_variable_labels(
			  recordid="Record ID"
			, split_id_verify="Split ID"
			, name="Practice Name"
			, zip="Practice Zip Code"
			, state="Practice State"
			, survey_dtd="Date"
			, consulted___1="Consulted Clinician (MD, DO, NP, PA))"
			, consulted___2="Consulted Behavioral health clinician"
			, consulted___3="Consulted Other clinical staff"
			, consulted___4="Consulted Office manager"
			, consulted___5="Consulted Front/back office staff"
			, consulted___6="Consulted Peer provider"
			, consulted___7="Consulted Pharmacist"
			, consulted___8="Consulted Other"
			, consulted_other="Consulted Other: text"
			, num_primary="n Clinicians"
			, fte_primary="n Clinicians FTE"
			, num_psych="n Psychiatrists"
			, fte_psych="n Psychiatrists FTE"
			, num_bhav="n Behavioral Health Clinicians"
			, fte_bhav="n Behavioral Health Clinicians FTE"
			, num_nursing="n Nursing Staff"
			, num_front_office="n Front Office Staff"
			, num_peer_pvdr="n Peer Providers"
			, num_pharm="n Pharm"
			, num_other="n Other"
			, patient_visits_wk="Patient Visits per Week"
			, patient_provider_day="Average Patients Seen per Day"
			, inpatientcare="Clinicians inpatient care/ hospital admissions"
			, race_white="White"
			, race_black="Black/African American"
			, race_native="American Indian or Alaska Native"
			, race_hawaiian="Native Hawaiian or Other Pacific Islander "
			, race_asian="Asian"
			, race_other="Other or Mixed Race"
			, race_unknown="Race: Percent Unknown"
			, hispanic="Hispanic or Latino"
			, non_hispanic="Non-Hispanic or non-Latino"
			, hispanic_unknown="Ethnicity: Percent Unknown"
			, age_0_17="0-17"
			, age_18_39="18-39"
			, age_40_59="40-59"
			, age_60_75="60-75"
			, age_76up="76+"
			, age_unk="Age: Percent Unknown"
			, gender_male="Male (pct)"
			, gender_female="Female (pct)"
			, gender_nonbinary="Non-binary... (pct)"
			, gender_none="Prefer not to say (pct)"
			, demog_data="How obtained demo proportions"
			, underserved="Practice designated as MUA, MUP by HRSA"
			, registry___1="Registry Category Alcohol use disorder"
			, registry___2="Registry Category Opioid use disorder"
			, registry___3="Registry Category Ischemic vascular disease"
			, registry___4="Registry Category Hypertension"
			, registry___5="Registry Category High cholesterol"
			, registry___6="Registry Category Diabetes"
			, registry___7="Registry Category Prevention services"
			, registry___8="Registry Category High risk "
			, registry___9="Registry Category None"
			, registry_config="Practice registry, new conditions"
			, teamlearn_formal_train="Training in past 2 years"
			, teamlearn_how_train="Training Method"
			, teamlearn_name_training="Recalls Name of training, trainer, or subject"
			, teamlearn_name_train_specify="Name of training, trainer, or subject"
			, train_together="Train as practice team"
			, train_small_teams="Train in smaller teams"
			, train_idv="Train everyone individually"
			, fast_practice_survey_complete="Complete"
		)  
	
	saveRDS(survey, here::here("data/survey.RDS"))
	
	
	
}
