/*         
PURPOSE:        Merge survey and app; 
                put in order required by template
PROGRAMMER:     K Wiggins
DATE:           08/25/2022
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          
                Final result for upload should have 74 columns and be in order acc to &template_fields;
-----------------------------------------------------------------------------------------------------
CHANGE LOG
   Date         By      Purpose
1. 01/15/22     KW      Copied from Dionisia's original to not mess with it
2. 08/25/22     KW      Adapted from last iteration survey only, NORC

LAST RAN: 08/26/2022*/

* ROOT FOLDER  ---------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
* INCLUDE --------------------------------------------;
%include "&root/norc/code_folder/00_paths_lets.sas"; 
* has paths and all let statements for project;

* merge; 
proc sql; 
create table survey_app as
select a.*
    , b.*
from norc.survey as a
left join norc.app as b
on a.practice_id = b.practice_id; 
quit; 

* change . to 999;
proc stdize data=survey_app
    out=survey_app1
    reponly missing=999;
run; *44, 63;

* find template fields need to keep / order; 
proc sql;
select A
into :order separated by ' '
from norc.survey_field_order;
quit;

data survey_app1;
retain &order.;
set  survey_app;
run;

data norc.survey_baseline;
set  survey_app1;
run;

* Export files;
proc export data = norc.survey_baseline
    outfile = "&norc/survey_baseline_&datestamp"
    dbms=xlsx replace;
run;


* delete BAK files created by PROC EXPORT;
/*filename bak  "&norc/survey_post_20220825.xlsx.bak";*/
/*filename bak2 "&norc/survey_baseline_20220825.xlsx.bak"; */
/**/
/*data _null_;*/
/* rc = fdelete("bak");*/
/* rc = fdelete("bak2");*/
/*run;*/
/**/
/*filename bak clear; */
/*filename bak2 clear;*/
