fn_app<- function(){
	
	app0 <- read.csv(here("data_raw/FASTApplication_20230413.csv"))
	
	app  <- app0 |> 
		# select(spec_family   = specialty___1,
		# 			 spec_internal = specialty___2,
		# 			 spec_peds     = specialty___3,
		# 			 spec_mixed_pc = specialty___4,
		# 			 spec_nurse    = specialty___5,
		# 			 spec_obgyn    = specialty___6,
		# 			 spec_other    = specialty____777,
		# 			 type_solo     = type___1,
		# 			 type_hosp     = type___2,
		# 			 type_hmo      = type___3,
		# 			 type_nfgc     = type___4,
		# 			 type_ahc      = type___5,
		# 			 type_fed      = type___6,
		# 			 type_other    = type____777,
		# 			 everything())  |> 
	mutate(status.fct = factor(
		status,
		levels = c("1","2","3","4","5"),
		labels = c("Never Enrolled","Active","Paused","Complete","Dropped")),
		
	 consort_dropout_code.fct = factor(
	 	consort_dropout_code,
	 	levels=c("0","1","2","3","4","5","6"),
	 	labels = c("Not Eligible",
	 						 "No Response",
	 						 "Decided not to sign practice agreement",
	 						 "Signed agreement, did not complete survey",
	 						 "Completed survey, did not host kick off meeting",
	 						 "Withdrew after kick off",
	 						 "Withdrew before final assessments")),
		
		prac_dropout.fct = factor(
			prac_dropout,
			levels = c("4","1","2","5","3"),
			labels = c("Application Incomplete",
								 "Practice not eligible",
								 "Practice unable to support project objectives",
								 "Completed FAST term",
								 "Other"))) |> 
		
		labelled::set_variable_labels(
			
			pcmh = "PCMH accreditation"
			, payermix_medicare = "Medicare only"
			, payermix_medicaid = "Medicaid only"
			, payermix_dual = "Dual Medicare and Medicaid"
			, payermix_private = "Commercial or Private Insurance"
			, payermix_other = "Other Payer Category"
			, payermix_noins_selfpay = "Self-pay or uninsured"
			, payermix_total = "Payermix Total"
			, fast_application_complete = "Application Complete"
			, type___1 = "Clinician-owned"
			, type___2 = "Hospital or Health"
			, type___3 = "HMO"
			, type___4 = "FQHC"
			, type___5 = "FQHC Look-Alike"
			, type___6 = "Non-federal Government Clinic"
			, type___7 = "Academic Health Center"
			, type___8 = "Federal"
			, type___9 = "RHC"
			, type___10 = "IHS"
			, type____777 = "Type: Other"
			, record_id = "Record ID"
			, prac_entity_split_id = "Split ID"
			, clinicname = "Practice Name"
			, eligible = "Practice Eligible for FAST"
			, intervention_arm = "Intervention Arm"
			, clinicname_preferred = "Preferred Practice Name"
			, specialty___1 = "Family Medicine"
			, specialty___2 = "Internal Medicine"
			, specialty___3 = "Pediatrics"
			, specialty___4 = "Mixed primary care"
			, specialty___5 = "Nurse-led primary care"
			, specialty___6 = "Ob/Gyn"
			, specialty____777 = "Specialty: Other"
			, status = "Status"
			, dropout_dtd = "End Date"
			, consort_dropout_code = "Consort Dropout Code"
			, prac_dropout = "End Reason"
			, kickoff_mtg_dtd = "Kick-Off Meeting Date"
		)
	
	saveRDS(app, here::here("data/app.RDS"))
	write.csv(app, here::here("data/app.csv"))
	
}

app <- fn_app()
