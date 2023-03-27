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
* Import file ; 
%INCLUDE "&import./prac_survey_raw.sas"; 
* alias ; 
%LET surv0 = work.survey0	; 

* ==== IMPORTED in 00_import_runfile ========================================================;
* march 21 =  // feb15 = 51, 70 // jan23 = 51, 70 // aug = 49,69;; 

PROC CONTENTS DATA = &surv0; RUN; 

* Remove the incorrect split_id field (prac_entity_split_id) > keep `split_id_verify`;
DATA &surv0;
SET  &surv0 ( DROP = prac_entity_split_id ) ;
RUN;  

PROC SORT DATA = &surv0;
BY split_id_verify; 
RUN; 

* confirm only one each ; 
PROC FREQ DATA = &surv0;
TABLES split_id_verify; 
RUN;  * 52 perfect -- and no duplicates!;

*AUG 2022: 
Per email thread with Sabrina re: multiple ID's, documented in doc file:;
/*data &surv0a;*/
/*set  &surv0;*/
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
from &surv0;
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

%LET surv_a = out.survey_20230320 ; 
*save to library;
data &surv_a;
set  survey4;
run; *44, 47;

* use date from last dataset, not date ran; 
proc sort data = &surv_a; by practice_id; run;

proc freq data = &surv_a;
run;

* Don't need to export: wait until merged with PracticeApp;
