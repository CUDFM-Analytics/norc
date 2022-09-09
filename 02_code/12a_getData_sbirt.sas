/*
PROGRAM:   
PURPOSE:        NORC upload
PROGRAMMER:     K Wiggins
DATE:           08/28/2022
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          - if task_id in (193, 201) and Finished = 1 / Keep_or_delete = keep ;
                - sbirt is qualtrics export - start on row 3
                - template requires 55 columns;
-----------------------------------------------------------------------------------------------------
CHANGE LOG
 Date    By  Purpose
1. 01/15/22  KW  Copied from Dionisia's original to not mess with it
2. 08/28/22  KW  adapted for august upload; 88 

LAST RAN: 08/25/2022
*/

* Set global variables and function calls; 
* ROOT FOLDER  ---------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
* INCLUDE --------------------------------------------;
%include "&root/norc/code_folder/00_paths_lets.sas"; 
   *has paths and all let statements for project;

proc import 
    file = "&sbirt."
    out = sbirt0
    dbms = xlsx replace;
    datarow = 3;
run; *99, 109;

data sbirt1;
set  sbirt0;
where keep_or_delete = "KEEP"
AND 
task_id in ('193', '201');
GRANTEE = 'CO';
run; *88, 110 - dropped 6 entries from keep/delete;

proc freq data = sbirt1;
tables finished task_id sim_id;
run; *finished n=88 all value of 1 / task_id 193 n=51, 201 n=37;
*sim_id all 1 or 2;

proc sql; 
create table sbirt2 as 
select GRANTEE
        , task_id
        , sim_id         as PRACTICE_ID
        , AUD_pts_screen as SCREENING_PROCESS
        , screentools_1  as TOOL_SASQ
        , screentools_2  as TOOL_AUDIT3
        , screentools_3  as TOOL_AUDIT10
        , screentools__66_TEXT as TOOL_OTHER
        , patient_type_1 as SCREEN_18ABOVE
        , patient_type_2 as SCREEN_AGERANGE
        , patient_type_2_TEXT as SCREEN_AGERANGE_OPENEND
        , patient_type_3 as SCREEN_CONDITION
        , patient_type_3_TEXT as SCREEN_CONDITION_OPENEND
        , patient_type_4 as SCREEN_MAINTENANCE_PREVENTIVE
        , patient_type_5 as SCREEN_TELEHEALTH
        , patient_type_6 as SCREEN_WEB
        , patient_type__66_TEXT as SCREEN_OTHER
        , Frequency         as SCREENED_FREQUENCY
        , workflow_person_1 as INVOLVED_SELFADMINISTERED
        , workflow_person_2 as INVOLVED_CLINICIAN
        , workflow_person_3 as INVOLVED_BH
        , workflow_person_4 as INVOLVED_OTHERCLINICAL
        , workflow_person_5 as INVOLVED_OFFICEMANAGER
        , workflow_person_6 as INVOLVED_FRONTBACKSTAFF
        , workflow_person_7 as INVOLVED_PEERPROVIDER
        , workflow_person_8 as INVOLVED_PHARMACIST
        , workflow_person__66_TEXT as INVOLVED_OTHER
        , tools_1 as DOCUMENTATIONTOOL_NONE
        , tools_2 as DOCUMENTATIONTOOL_PAPERSCREEN
        , tools_3 as DOCUMENTATIONTOOL_PAPERHR
        , tools_4 as DOCUMENTATIONTOOL_EHRUNS /*change in excel after final export*/
        , tools_5 as DOCUMENTATIONTOOL_EHRST/*change in excel after final export*/
        , tools__66_TEXT as DOCUMENTATIONTOOL_OTHER
        , review_rslts as SCREENING_REVIEW_PROCESS_GENERAL
        , interpret_1 as REVIEWPROCESS_FLAGBI
        , interpret_2 as REVIEWPROCESS_COUNSELBI
        , interpret_3 as REVIEWPROCESS_NEEDBI
        , interpret_4 as REVIEWPROCESS_IDENTIFYAUDSX
        , interpret_5 as REVIEWPROCESS_PROMPTAUD
        , interpret__66_TEXT as REVIEWPROCESS_OTHER
        , positive_AUD as POSITIVE_INDIV/*change in excel after final export*/
        , further_assess_1 as POSITIVETOOL_DSM
        , further_assess_2 as POSITIVETOOL_AUDIT
        , further_assess_3 as POSITIVETOOL_CAGE
        , further_assess__66_TEXT as POSITIVETOOL_OTHER
        , feedback as SCREENING_RESULTS_FEEDBACK
        , care_AUD as PRACTICE_SUPPORT
        , support_1 as SUPPORT_BICLINICIAN
        , support_2 as SUPPORT_BIBH
        , support_3 as SUPPORT_EDUCATION
        , support_4 as SUPPORT_REFEREXTERNAL
        , support_5 as SUPPORT_REFERPEER
        , support_6 as SUPPORT_TREATMENT
        , support_7 as SUPPORT_RX
        , support_8 as SUPPORT_MAT
        , support__66_TEXT as SUPPORT_OTHER
from sbirt1;
quit; *88, 56 - will drop task_id later  ; 

* Get order of variables for upload; 

* Have to change template names bc > 32 bytes;
data norc.template_sbirt (keep=template field extract_comments);
set  norc.templates;
Field = tranwrd(Field, 'DOCUMENTATIONTOOL_EHRUNSTRUCTURED', 'DOCUMENTATIONTOOL_EHRUNS');
Field = tranwrd(Field, 'DOCUMENTATIONTOOL_EHRSTANDARDIZED', 'DOCUMENTATIONTOOL_EHRST');
Field = tranwrd(Field, 'POSITIVE_INDIVIDUAL_PROCESS_GENERAL', 'POSITIVE_INDIV');
where template contains 'SBI_RT';
run; *110, 3;

* Create macro with list of names in order;
proc sql noprint;
select Field
into :order separated by ' '
from norc.template_sbirt;
quit;

* re-order most recent iteration of work.sbirtX to match macro using retain;
data sbirt3;
retain &order.;
set  sbirt2;
run;

proc freq data = sbirt3;
tables _all_*task_id;
run;

* Split file by task_id and drop column, save to library 'norc';
data norc.sbirt_baseline (drop=task_id) norc.sbirt_post (drop=task_id);
set sbirt3;
if task_id = 193 then output norc.sbirt_baseline; 
if task_id = 201 then output norc.sbirt_post;  
run; *51,55 / 37,55;

* Export files;
proc export data = norc.sbirt_baseline
  outfile = "&norc/sbirt_baseline_&datestamp"
  dbms=xlsx replace;
run;

proc export data = norc.sbirt_post
  outfile = "&norc/sbirt_post_&datestamp"
  dbms=xlsx replace;
run;


* delete BAK files created by PROC EXPORT;
filename bak  "&norc/sbirt_post_20220828.xlsx.bak";
filename bak2 "&norc/sbirt_baseline_20220828.xlsx.bak"; 

data _null_;
 rc = fdelete("bak");
 rc = fdelete("bak2");
run;

filename bak clear; 
filename bak2 clear;
