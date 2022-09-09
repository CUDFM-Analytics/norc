/*
PROGRAM:         
PURPOSE:         NORC upload
PROGRAMMER:      K Wiggins
DATE:            08/25/2022
PROCESS:         Export from redcap report
NOTES:           
-----------------------------------------------------------------------------------------------------

LAST RAN: 08/26/2022
*/

* Set global variables and function calls; 
* ROOT FOLDER  ---------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
* INCLUDE --------------------------------------------;
%include "&root/norc/code_folder/00_paths_lets.sas"; 
         *has paths and all let statements for project;

proc import 
        file = "&application."
        out = app0
        dbms = csv replace;
run; *174, 23; 

proc sql; 
create table app1 as
select PRAC_ENTITY_SPLIT_ID AS PRACTICE_ID
     , PAYERMIX_MEDICARE as PAYER_PERCENTAGE_MEDICARE
     , PAYERMIX_MEDICAID as PAYER_PERCENTAGE_MEDICAID
     , PAYERMIX_DUAL as PAYER_PERCENTAGE_DUAL
     , PAYERMIX_PRIVATE as PAYER_PERCENTAGE_PRIVATE
     , PAYERMIX_NOINS_SELFPAY as PAYER_PERCENTAGE_NO_INSURANCE
     , PAYERMIX_OTHER as PAYER_PERCENTAGE_OTHER
     , type___1 as PRACTICE_OWNERSHIP_SOLO_GROUP
     , type___2 as PRACTICE_OWNERSHIP_HOSPITAL
     , type___3 as PRACTICE_OWNERSHIP_HMO
     , type___4 as PRACTICE_OWNERSHIP_FQHC
     , type___6 as PRACTICE_OWNERSHIP_NONFED_GVMT
     , type___7 as PRACTICE_OWNERSHIP_ACADEMIC
     , type___8 as PRACTICE_OWNERSHIP_FEDERAL
     , type___9 as PRACTICE_OWNERSHIP_RURAL
     , type___10 as PRACTICE_OWNERSHIP_IHS
     , type____777 as PRACTICE_OWNERSHIP_OTHER
     , FAST_APPLICATION_COMPLETE
     , PCMH
from app0 
where fast_application_complete = 2 ;
quit;

* Get practices that match practice survey;
*   Create macro list;
proc sql; 
select distinct practice_id into :pracid separated by ', '
    from norc.survey;
quit; 

* Filter based on macro list; 
proc sql; 
create table app2 as
    select *
    from app1 
    where practice_id in (&pracid.);
quit; *44, 18;  

* make sure none are dupes;
proc freq data = app2;
tables practice_id;
run;

*drop vars;
data app3 (drop=fast_application_complete);
set  app2;
run;

data norc.app;
set  app3;
run; *44, 17;
