/*
PROJECT      FAST
PURPOSE:     NORC upload: Survey
PROGRAMMER:  K Wiggins
LAST RAN     02/16/2023
PROCESS:     Danika exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:       - Use split_id_verify 
             - Use dupdelete remove 1's : No longer in file, but was in Aug... 
             Checks:
                 - no keep / etc columns - all look complete - so kept all.
                 - 2022/08/20: Sent duplicate practice_id's to Sabrina Lor - practice_id 35, 141 this time 
             Expect: 
                 Final result for upload should have 74 columns and be in order acc to &template_fields;
        
-----------------------------------------------------------------------------------------------------*/

* ==== GLOBAL PATHS/ ALIASES  ===============================================================;
%INCLUDE "V:/Data_Management_Team/norc/code/00_globals_20230200.sas"; 

* ==== IMPORT ===============================================================================;
* feb15 = 51, 70 // jan23 = 51, 70 // aug = 49,69;
* comparing raw to import, the survey_other is only bringing in the first letter of text - fix; 
data WORK.SURVEY0     ;
     %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
     infile 'S:/FM/FM/Data_Management_Team/raw data/FASTPracticeSurvey_raw_20230120.csv' 
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

PROC CONTENTS DATA = survey0; RUN; 

* Remove the incorrect split_id field (prac_entity_split_id) > keep `split_id_verify`;
DATA survey0;
SET  survey0 ( DROP = prac_entity_split_id ) ;
RUN;  

PROC SORT DATA = survey0;
BY split_id_verify; 
RUN; 

* confirm only one each ; 
PROC FREQ DATA = survey0;
TABLES split_id_verify; 
RUN;  * feb15 yay;

*AUG 2022: 
Per email thread with Sabrina re: multiple ID's, documented in doc file:;
/*data survey0a;*/
/*set  survey0;*/
/*if name = "Aspen Internal Medicine Consultants" then prac_entity_split_id = 3106;*/
/*if name = "Denver Family Medicine" then prac_entity_split_id = 2070;*/
/*if name = "Internal Medical Associates of Lafayette" then prac_entity_split_id = 2601;*/
/*run;*/

proc sql; 
create table survey1 as 
select split_id_verify      as PRACTICE_ID
    , zip                   as ZIPCODE
    , consulted___1         as SURVEY_CONSULT_CLINICIAN
    , consulted___2         as SURVEY_CONSULT_BH
    , consulted___3         as SURVEY_CONSULT_OTHER_CLINICAL
    , consulted___4         as SURVEY_CONSULT_OFFICE_MANAGER
    , consulted___5         as SURVEY_CONSULT_OFFICE_STAFF
    , consulted___6         as SURVEY_CONSULT_PEER_PROVIDER
    , consulted___7         as SURVEY_CONSULT_PHARMACIST
    , consulted_other       as SURVEY_CONSULT_OTHER
    , num_primary           as TOTAL_PRIMARY_CARE
    , fte_primary           as FTE_PRIMARY_CARE
    , num_psych             as TOTAL_PSYCH
    , fte_psych             as FTE_PSYCH
    , num_bhav              as TOTAL_BH
    , fte_bhav              as FTE_BH
    , num_nursing           as TOTAL_DIRECT_PT_CARE
    , num_front_office      as TOTAL_OFFICE_STAFF
    , num_peer_pvdr         as TOTAL_PEER_PROVIDERS
    , num_pharm             as TOTAL_PHARMACIST
    , num_other             as TOTAL_OTHER
    , inpatientcare         
    , patient_provider_day  as PATIENT_DAILY_NUMBER
    , race_white            as PERCENTAGE_WHITE
    , race_black            as PERCENTAGE_BLACK
    , race_native           as PERCENTAGE_AIAN
    , race_asian            as PERCENTAGE_ASIAN
    , race_hawaiian         as PERCENTAGE_NHPI
    , race_other            as PERCENTAGE_OTHER_MIXED
    , race_unknown          as PERCENTAGE_UNKNOWN
    , hispanic              as HISPANIC_LATINX_PERCENT
    , non_hispanic          as NON_HISPANIC_LATINX
    , hispanic_unknown      as HISPANIC_LATINX_UNKNOWN
    , age_0_17              as PATIENT_AGE_0_17
    , age_18_39             as PATIENT_AGE_18_39
    , age_40_59             as PATIENT_AGE_40_59
    , age_60_75             as PATIENT_AGE_60_75
    , age_76up              as PATIENT_AGE_76_OLDER
    , gender_male           as GENDER_IDENTITY_MEN
    , gender_female         as GENDER_IDENTITY_WOMEN
    , gender_nonbinary      as GENDER_IDENTITY_NB
    , gender_none           as GENDER_IDENTITY_UNKNOWN
    , demog_data            as DATA_SOURCE
from survey0;
quit; *;

* Create calculated variables for 'x_collected';
data survey2;
set  survey1;

if hispanic_latinx_unknown = 100 then ETHNICITY_COLLECTED = 0;
    else ETHNICITY_COLLECTED = 1;

if GENDER_IDENTITY_UNKNOWN = 100 then GENDER_COLLECTED = 0;
    else GENDER_COLLECTED = 1;

if PERCENTAGE_UNKNOWN = 100 then RACE_COLLECTED = 0;
    else RACE_COLLECTED = 1;

Grantee = 'CO';

RUN; 
*49, 47;

* Recode inpatient care, then drop
    > original: 1) Yes, 0) No clinicians visit patients in hosp, -1) No Hospital-based staff provides 
    > for norc: 1) Yes, 2) No clinicians visit patients in hosp,  3) No Hospital-based staff provides;

PROC FREQ 
DATA   = survey2; 
TABLES inpatientcare;
RUN; 

DATA survey3;
SET  survey2;
IF inpatientcare = -1     THEN INPATIENT_ADMISSIONS = 3;
ELSE IF inpatientcare = 0 THEN INPATIENT_ADMISSIONS = 2;
ELSE IF inpatientcare = 1 THEN INPATIENT_ADMISSIONS = 1;
ELSE INPATIENT_ADMISSIONS = 999;
RUN; *49, 48;
* feb (jan) : original had 35                        n=7                            n=6
* aug:        original had 34 (-1 --> recode to "3") n=7 (0 --> recoded to "2") and n=5 (1) ;

PROC FREQ DATA = survey3;
TABLES inpatient:;
RUN; 
* feb     value 1 (n=6), value 2 (n=7) value 3 (n=35) value 999 (n=3)
  jan now value 1 (n=6), value 2 (n=7) value 3 (n=35) value 999 (n=3);

DATA survey4 (drop=inpatientcare);
SET  survey3;
RUN; *49, 47;

/*            * Find instances with >1 practice_id and send to Sabrina Lor;*/
            proc sql; 
            create table survey_multiple_ids as 
            select *
                , count(practice_id)
            from survey4
            group by practice_id
            having count(practice_id) >1;
            quit; * 0 rows;
/**/
/*            * exported and sent to Sabrina Lor 08/25/2022;*/
/*                        proc export data = norc.survey_multiple_ids*/
/*                            outfile = "&norc/pracsurvey_mult_&datestamp"*/
/*                            dbms=xlsx replace;*/
/*                        run;*/

*save to library;
data out.survey_20230120;
set  survey4;
run; *44, 47;

* use date from last dataset, not date ran; 
proc sort data = out.survey_20230120; by practice_id; run;

proc freq data = out.survey_20230120;
run;

* Don't need to export: wait until merged with PracticeApp;
