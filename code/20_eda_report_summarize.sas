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
    TABLE prac_entity_split_id * (N)    ;
RUN;

* RESULTS; 

ods excel file = "&FEB/sbirt_metrics.xlsx"
    options ( sheet_name = "contents" 
              sheet_interval = "none"
              flow = "tables");

ods excel options ( sheet_interval = "now" sheet_name = "survey") ;

proc print data=out.summary_survey ; RUN ; 

ods excel options ( sheet_interval = "now" sheet_name = "metrics_bl") ;

proc print data = &template_fields;
where Template contains 'Process';
run;

proc print data = out.summary_metrics_bl ; RUN ; 

ods excel options ( sheet_interval = "now" sheet_name = "metrics_post") ;

proc print data = out.summary_metrics_post ; RUN ; 

ods excel options ( sheet_interval = "now" sheet_name = "metrics_pre_post") ;

PROC SQL ; 
CREATE TABLE metrics_pre_post AS 
SELECT practice_ID AS PRE
     , practice_ID IN (SELECT practice_ID from out.metrics_post ) AS post 
FROM out.metrics_baseline ; 
QUIT ; 

PROC PRINT DATA = metrics_pre_post ; RUN ; 

ods excel options ( sheet_interval = "now" sheet_name = "sbirt_bl") ;


*** ENDED / START HERE 03/27/2023; 


ods excel options ( sheet_interval = "now" sheet_name = "means") ;

proc print data = fn_summary ; run ;

ods excel options ( sheet_interval = "now" sheet_name = "frequencies") ;

PROC FREQ 
     DATA = out.fn_final_update;
     TABLES _all_ / norow nopercent nocol;
     TITLE  'Frequencies for Fieldnotes, Feb 2023 Upload (Jan2023 data)';
RUN; 
TITLE; 

ods excel close; 
run;



