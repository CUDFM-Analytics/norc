/*
PROJECT      FAST
PURPOSE:     NORC uploads, import raw survey file 
PROGRAMMER:  K Wiggins
LAST RAN     03-21-2023
PROCESS:     Danika exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
        
-----------------------------------------------------------------------------------------------------*/

* Raw survey file ; 
data WORK.SURVEY0     ;
     %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
     infile "&survey" 
     delimiter = ',' 
     MISSOVER 
     DSD 
     lrecl=32767 
     firstobs=2 
     ;
       informat recordid best32. ;
       informat prac_entity_split_id best32. ;  
       informat split_id_verify best32. ;
       informat name $53. ;
       informat zip best32. ;
       informat state $1. ;
       informat survey_dtd mmddyy10. ;
       informat consulted___1 best32. ;
       informat consulted___2 best32. ;
       informat consulted___3 best32. ;
       informat consulted___4 best32. ;
       informat consulted___5 best32. ;
       informat consulted___6 best32. ;
       informat consulted___7 best32. ;
       informat consulted___8 best32. ;
       informat consulted_other $60. ;  * updated to $60 from $1; 
       informat num_primary best32. ;
       informat fte_primary best32. ;
       informat num_psych best32. ;
       informat fte_psych best32. ;
       informat num_bhav best32. ;
       informat fte_bhav best32. ;
       informat num_nursing best32. ;
       informat num_front_office best32. ;
       informat num_peer_pvdr best32. ;
       informat num_pharm best32. ;
       informat num_other best32. ;
       informat patient_visits_wk best32. ;
       informat patient_provider_day best32. ;
       informat inpatientcare best32. ;
       informat race_white best32. ;
       informat race_black best32. ;
       informat race_native best32. ;
       informat race_hawaiian best32. ;
       informat race_asian best32. ;
       informat race_other best32. ;
       informat race_unknown best32. ;
       informat hispanic best32. ;
       informat non_hispanic best32. ;
       informat hispanic_unknown best32. ;
       informat age_0_17 best32. ;
       informat age_18_39 best32. ;
       informat age_40_59 best32. ;
       informat age_60_75 best32. ;
       informat age_76up best32. ;
       informat age_unk best32. ;
       informat gender_male best32. ;
       informat gender_female best32. ;
       informat gender_nonbinary best32. ;
       informat gender_none best32. ;
       informat demog_data best32. ;
       informat underserved best32. ;
       informat registry___1 best32. ;
       informat registry___2 best32. ;
       informat registry___3 best32. ;
       informat registry___4 best32. ;
       informat registry___5 best32. ;
       informat registry___6 best32. ;
       informat registry___7 best32. ;
       informat registry___8 best32. ;
       informat registry___9 best32. ;
       informat registry_config best32. ;
       informat teamlearn_formal_train best32. ;
       informat teamlearn_how_train best32. ;
       informat teamlearn_name_training best32. ;
       informat teamlearn_name_train_specify $60. ;
       informat train_together best32. ;
       informat train_small_teams best32. ;
       informat train_idv best32. ;
       informat fast_practice_survey_complete best32. ;

       format recordid best12. ;
       format prac_entity_split_id best12. ;
       format split_id_verify best12. ;
       format name $53. ;
       format zip best12. ;
       format state $1. ;
       format survey_dtd mmddyy10. ;
       format consulted___1 best12. ;
       format consulted___2 best12. ;
       format consulted___3 best12. ;
       format consulted___4 best12. ;
       format consulted___5 best12. ;
       format consulted___6 best12. ;
       format consulted___7 best12. ;
       format consulted___8 best12. ;
       format consulted_other $60.  ;     * updated to $60 from $1; 
       format num_primary best12.   ;
       format fte_primary best12.   ;
       format num_psych best12.     ;
       format fte_psych best12.     ;
       format num_bhav best12.      ;
       format fte_bhav best12. ;
       format num_nursing best12. ;
       format num_front_office best12. ;
       format num_peer_pvdr best12. ;
       format num_pharm best12. ;
       format num_other best12. ;
       format patient_visits_wk best12. ;
       format patient_provider_day best12.;
       format inpatientcare best12. ;
       format race_white best12. ;
       format race_black best12. ;
       format race_native best12. ;
       format race_hawaiian best12. ;
       format race_asian best12. ;
       format race_other best12. ;
       format race_unknown best12. ;
       format hispanic best12. ;
       format non_hispanic best12. ;
       format hispanic_unknown best12. ;
       format age_0_17 best12. ;
       format age_18_39 best12. ;
       format age_40_59 best12. ;
       format age_60_75 best12. ;
       format age_76up best12. ;
       format age_unk best12. ;
       format gender_male best12. ;
       format gender_female best12. ;
       format gender_nonbinary best12. ;
       format gender_none best12. ;
       format demog_data best12. ;
       format underserved best12. ;
       format registry___1 best12. ;
       format registry___2 best12. ;
       format registry___3 best12. ;
       format registry___4 best12. ;
       format registry___5 best12. ;
       format registry___6 best12. ;
       format registry___7 best12. ;
       format registry___8 best12. ;
       format registry___9 best12. ;
       format registry_config best12. ;
       format teamlearn_formal_train best12. ;
       format teamlearn_how_train best12. ;
       format teamlearn_name_training best12. ;
       format teamlearn_name_train_specify $60. ;
       format train_together best12. ;
       format train_small_teams best12. ;
       format train_idv best12. ;
       format fast_practice_survey_complete best12. ;

    input
        recordid
        prac_entity_split_id           
        split_id_verify
        name  $
        zip
        state  $
        survey_dtd
        consulted___1
        consulted___2
        consulted___3
        consulted___4
        consulted___5
        consulted___6
        consulted___7
        consulted___8
        consulted_other  $
        num_primary
        fte_primary
        num_psych
        fte_psych
        num_bhav
        fte_bhav
        num_nursing
        num_front_office
        num_peer_pvdr
        num_pharm
        num_other
        patient_visits_wk
        patient_provider_day
        inpatientcare
        race_white
        race_black
        race_native
        race_hawaiian
        race_asian
        race_other
        race_unknown
        hispanic
        non_hispanic
        hispanic_unknown
        age_0_17
        age_18_39
        age_40_59
        age_60_75
        age_76up
        age_unk
        gender_male
        gender_female
        gender_nonbinary
        gender_none
        demog_data
        underserved
        registry___1
        registry___2
        registry___3
        registry___4
        registry___5
        registry___6
        registry___7
        registry___8
        registry___9
        registry_config
        teamlearn_formal_train
        teamlearn_how_train
        teamlearn_name_training
        teamlearn_name_train_specify  $
        train_together
        train_small_teams
        train_idv
        fast_practice_survey_complete
    ;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
    run;
