
/*
PROGRAM:   
PURPOSE:        NORC upload
PROGRAMMER:     K Wiggins
DATE:           08/28/2022
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          - if task_id in (193, 201) and Finished = 1 / Keep_or_delete = keep ;
                - sbirt is qualtrics export - start on row 3
                - template requires 55 columns;
-----------------------------------------------------------------------------------------------------*/
* ==== GLOBAL PATHS/ ALIASES  ===============================================================;
/*Uncomment if needed to run again from here*/

* CONFIG FILE: 
/*%INCLUDE "\\data.ucdenver.pvt\dept\SOM\FM\FM\Data_Management_Team\norc\code\00_config_20230320.sas"; */

* MACRO for checking ID's against the inclusion list: ; 
/*%INCLUDE "&NORC./code/macros/check_ids.sas"; */

* ==== IMPORT  ===============================================================================;
* Imported via wizard - idk it isn't working to get 999's on the char fields; 
data sbirt1 (drop=sim_id);
set  sbirt;
PRACTICE_ID = input(sim_id, 8.); 
/*where recordeddate ne '' */
/*AND   task_id in ('193', '201')*/
WHERE   sim_id ne ' '
AND     keep_or_delete = "KEEP";
GRANTEE = 'CO';
run; *[99, 110]
 *  aug[88, 110 - dropped 6 entries from keep/delete];

PROC SORT DATA = sbirt1 ; by practice_id ; RUN ;

proc sql; 
create table sbirt2 as 
select GRANTEE
        , task_id
        , PRACTICE_ID
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
from sbirt1
WHERE practice_id IN (SELECT prac_entity_split_id FROM out.inclusion);
quit; *apr 93  // feb 94, 56 // jan 88, 56 - will drop task_id later  ; 

proc freq data = sbirt2 ;
tables practice_id*task_id /norow nopercent nocol;
run; * feb = 93
finished jan = 90 
AUG n=88 all value of 1 / task_id 193 n=51, 201 n=37;
*sim_id all 1 or 2;

* Get order of variables for upload; 

* Have to change template names bc > 32 bytes;
data out.template_sbirt (keep=template field extract_comments);
set  out.templates;
Field = tranwrd(Field, 'DOCUMENTATIONTOOL_EHRUNSTRUCTURED', 'DOCUMENTATIONTOOL_EHRUNS');
Field = tranwrd(Field, 'DOCUMENTATIONTOOL_EHRSTANDARDIZED', 'DOCUMENTATIONTOOL_EHRST');
Field = tranwrd(Field, 'POSITIVE_INDIVIDUAL_PROCESS_GENERAL', 'POSITIVE_INDIV');
where template contains 'SBI_RT';
run; *77, 3;

* Create macro with list of names in order;
proc sql noprint;
select Field
into :order separated by ' '
from out.template_sbirt;
quit;

* remove all labels so you can export using labels for the longer column names only ; 
proc datasets lib = work;
modify sbirt2;
attrib _all_ label = ''; 
RUN ; 

* re-order most recent iteration of work.sbirtX to match macro using retain;
data sbirt3;
retain &order.;
set  sbirt2;
LABEL DOCUMENTATIONTOOL_EHRUNS = "DOCUMENTATIONTOOL_EHRUNSTRUCTURED"
      DOCUMENTATIONTOOL_EHRST  = "DOCUMENTATIONTOOL_EHRSTANDARDIZED"
      POSITIVE_INDIV           = "POSITIVE_INDIVIDUAL_PROCESS_GENERAL";
run; *93, 56;

* ==== SET to 999 where req'd (norc_templates_comments_extracted_20220824) ===================;
data sbirt4 (DROP=i);
set  sbirt3;
    array rcchr(38) 
             TOOL_SASQ
             TOOL_AUDIT3
             TOOL_AUDIT10
             SCREEN_18ABOVE
             SCREEN_AGERANGE
             SCREEN_CONDITION
             SCREEN_MAINTENANCE_PREVENTIVE
             SCREEN_TELEHEALTH
             SCREEN_WEB
             INVOLVED_SELFADMINISTERED
             INVOLVED_CLINICIAN
             INVOLVED_BH
             INVOLVED_OTHERCLINICAL
             INVOLVED_OFFICEMANAGER
             INVOLVED_FRONTBACKSTAFF
             INVOLVED_PEERPROVIDER
             INVOLVED_PHARMACIST
             DOCUMENTATIONTOOL_NONE
             DOCUMENTATIONTOOL_PAPERSCREEN
             DOCUMENTATIONTOOL_PAPERHR
             DOCUMENTATIONTOOL_EHRUNS
             DOCUMENTATIONTOOL_EHRST                
             REVIEWPROCESS_FLAGBI
             REVIEWPROCESS_COUNSELBI
             REVIEWPROCESS_NEEDBI
             REVIEWPROCESS_IDENTIFYAUDSX
             REVIEWPROCESS_PROMPTAUD
             POSITIVETOOL_DSM
             POSITIVETOOL_AUDIT
             POSITIVETOOL_CAGE
             SUPPORT_BICLINICIAN
             SUPPORT_BIBH
             SUPPORT_EDUCATION
             SUPPORT_REFEREXTERNAL
             SUPPORT_REFERPEER
             SUPPORT_TREATMENT
             SUPPORT_RX
             SUPPORT_MAT
;
    do i=1 to 38; 
if rcchr[i] = ' ' then rcchr[i] = "999";
    end;
RUN;  *;

**** SAVES TO OUT. ***********; 

data out.sbirt (DROP=i);
set  sbirt4    ;
    array rcnum(6) 
                  SCREENED_FREQUENCY  
                  SCREENING_PROCESS  
                  SCREENING_REVIEW_PROCESS_GENERAL              
                  SCREENING_RESULTS_FEEDBACK
                  POSITIVE_INDIV
                  PRACTICE_SUPPORT;
    do i=1 to 6; 
if rcnum[i] = . then rcnum[i] = 999;
    end;
RUN;  *;

proc contents data = out.sbirt_all_tasks varnum; 
RUN ; 


*** STOPPED HERE TO GET TASK_ID"S all ; 
* Check against inclusion file: ;
%check_ids(out=id_sbirt, b=out.sbirt); 
proc print data = id_sbirt; run ; 

* Split file by task_id and drop column, save to library 'norc';
data out.sbirt_baseline (drop=task_id) out.sbirt_post (drop=task_id);
set out.sbirt;
if task_id = 193 then output out.sbirt_baseline; 
if task_id = 201 then output out.sbirt_post;  
run; *APR= 50, 43 / 51,55 / 42, 56;

*** When exporting - export using labels so you can get the longer variable names ; 
ods excel file = "&out./sbirt.xlsx";
options(sheet_name = "sbirt");
proc print data = out.sbirt_all_tasks label ; 
RUN ; 
ods excel close ; 


* Export files;
ods excel file = "&out./sbirt_baseline.xlsx";
proc print data = out.sbirt_baseline noobs label ; 
RUN ; 

ods excel file = "&out./sbirt_post.xlsx";
PROC PRINT DATA = out.sbirt_post noobs label;
RUN ; 

ods excel close ; 


