/*
PROJECT      FAST
PURPOSE:     EDA
PROGRAMMER:  K Wiggins
LAST RAN     03-16/2023
PROCESS:     For running eda > keep open during processing ;
NOTES:       ;
        
-----------------------------------------------------------------------------------------------------*/

* ==== GLOBAL PATHS/ ALIASES  ===============================================================;
%INCLUDE "V:/Data_Management_Team/norc/code/00_config_20230320.sas";   

PROC TABULATE
DATA=OUT.INCLUSION;
VAR  prac_entity_split_id ;
	TABLE prac_entity_split_id * (N)	;
RUN;

* SURVEY BASELINE RESULTS ; 

ods excel file = "&FEB/summary_practice_survey.xlsx"
    options ( sheet_name = "contents" 
              sheet_interval = "none");

ods excel options ( sheet_interval = "now" sheet_name = "contents") ;

proc print data=out.summary_survey ; RUN ; 

proc contents data = out.survey_baseline_20230321 varnum; run;

ods excel options ( sheet_interval = "now" sheet_name = "num") ;

proc print data = surv_sum ; run ;

ods excel options ( sheet_interval = "now" sheet_name = "cat") ;

PROC FREQ 
     DATA = out.survey_baseline_20230123;
     TABLES PRACTICE_ID 
            SURVEY_CONSULT_OTHER
            PRACTICE_ID*DATA_SOURCE 
            PRACTICE_ID*GENDER_COLLECTED
            PRACTICE_ID*RACE_COLLECTED  
            PRACTICE_ID*ETHNICITY_COLLECTED
                / norow nopercent nocol;
     TITLE  'Frequencies for Survey Baseline Fields, Feb 2023 Upload (Jan2023 data)';
RUN; 
TITLE; 

ods excel options ( sheet_interval = "now" sheet_name = "metrics") ;

proc print data = &template_fields;
where Template contains 'Process';
run;

proc contents data = out.metrics_baseline label varnum; run;

ods excel options ( sheet_interval = "now" sheet_name = "num") ;

proc print data = metrics_sum ; run ;

ods excel options ( sheet_interval = "now" sheet_name = "pre_post") ;

ods text = "SplitID 2224 had to be removed for upload to be successful";

PROC FREQ 
     DATA = metrics4;
     TABLES practice_id*task_id
                / norow nopercent nocol ;
     format task_id $metrics.;
     TITLE  'Frequencies for Metrics Baseline, Post Results (Jan2023 data)';
RUN; 
TITLE; 

ods excel close; 
run;



* ==== EXPORT CONTENTS, FREQUENCIES, MEANS ===================================================;
proc print data=out.summary_sbirt_bl; run ; 

ods excel file = "&FEB/sbirt_metrics.xlsx"
    options ( sheet_name = "contents" 
              sheet_interval = "none"
              flow = "tables");

ods excel options ( sheet_interval = "now" sheet_name = "labels_contents") ;

proc contents data = out.sbirt_baseline varnum; 
proc contents data = out.sbirt_post     varnum; run;

ods excel options ( sheet_interval = "now" sheet_name = "num") ;

proc print data = sbirt_summary ; run ;

ods excel options ( sheet_interval = "now" sheet_name = "pre_post") ;

PROC FREQ 
     DATA = sbirt5;
     TABLES practice_id*task_id
                / norow nopercent nocol ;
     TITLE  'Frequencies for Metrics Baseline, Post Results (Jan2023 data)';
RUN; 
TITLE; 

ods excel options ( sheet_interval = "now" sheet_name = "bl_freq") ;

proc freq data = out.sbirt_baseline; 
tables practice_id*_all_;
run; 

ods excel options ( sheet_interval = "now" sheet_name = "post_freq") ;

proc freq data = out.sbirt_post; 
tables practice_id*_all_;
run;

ods excel close; 
run;



