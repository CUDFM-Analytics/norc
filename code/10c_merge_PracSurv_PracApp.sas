/*         
PURPOSE:        Merge survey and app; 
                put in order required by template
PROGRAMMER:     K Wiggins
LAST RAN        02/16/2023
PROCESS:        Danika exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          Final result for upload should have 64 columns and be in order acc to &template_fields;
-----------------------------------------------------------------------------------------------------
CHANGE LOG
   Date         By      Purpose
1. 01/15/22     KW      Copied from Dionisia's original to not mess with it
2. 08/25/22     KW      Adapted from last iteration survey only, NORC
3. 02/25/22     KW      Changed date stamps to match date of raw data

LAST RAN: 08/26/2022*/

* ==== GLOBAL PATHS/ ALIASES  ===============================================================;
* %INCLUDE "V:/Data_Management_Team/norc/code/00_config_20230320.sas";
* ==== MERGE  ===============================================================================;
proc sql; 
create table survey_app as
select a.*
    , b.*
from out.survey_20230320 as a
left join out.app as b
on a.practice_id = b.practice_id; 
quit; * 51, 64; 

* ==== MATCH TEMPLATE COLUMNS ===============================================================;
* find template fields need to keep / order; 
proc sql;
select A
into :order separated by ' '
from out.survey_field_order;
quit;

data survey_app2;
retain &order.;
set  survey_app;
run;

* ==== SET to 999 where req'd (norc_templates_comments_extracted_20220824) ===================;
data out.survey_baseline_20230321;
set  survey_app2;
    array missing {18}  SURVEY_CONSULT_CLINICIAN
                        SURVEY_CONSULT_BH
                        SURVEY_CONSULT_OTHER_CLINICAL
                        SURVEY_CONSULT_OFFICE_MANAGER
                        SURVEY_CONSULT_OFFICE_STAFF
                        SURVEY_CONSULT_PEER_PROVIDER
                        SURVEY_CONSULT_PHARMACIST
                        PRACTICE_OWNERSHIP_SOLO_GROUP
                        PRACTICE_OWNERSHIP_HOSPITAL
                        PRACTICE_OWNERSHIP_HMO
                        PRACTICE_OWNERSHIP_FQHC
                        PRACTICE_OWNERSHIP_NONFED_GVMT
                        PRACTICE_OWNERSHIP_ACADEMIC
                        PRACTICE_OWNERSHIP_FEDERAL
                        PRACTICE_OWNERSHIP_RURAL
                        PRACTICE_OWNERSHIP_IHS
                        INPATIENT_ADMISSIONS
                        PCMH;
    do i=1 to 18 ; 
    if missing[i] = . then missing[i] = 999;
    end;
RUN;  *feb [51,64];

* why do I create an i ? #DO Figure out how to array without it ; 
DATA out.survey_baseline_20230321 ; 
SET  out.survey_baseline_20230321 (drop=i) ; 
RUN ; 

* ==== EXPORT FILES TO UPLOAD ===============================================================;
proc export data = out.survey_baseline_20230321
    outfile = "&out/survey_baseline"
    dbms=xlsx replace;
run;


* delete BAK files created by PROC EXPORT;
/*filename bak "&out./survey_baseline.xlsx.bak"; */
/**/
/*data _null_;*/
/* rc = fdelete("bak");*/
/*run;*/
/**/
/*filename bak clear;*/

* Get list of variable names for contents, means, frequency export; 
%put List of Variables=%mf_getvarlist(out.survey_baseline_20230321);

* Run macro for univariate data (globals);
%summary(ds=out.survey_baseline_20230321,out=out.summary_survey);

* ==== EXPORT CONTENTS, FREQUENCIES, MEANS ===================================================;
* See 20_eda_report for code ; 
