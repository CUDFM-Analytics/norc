/*
PROGRAM:        NORC upload
PURPOSE:        Intervention Tracker / Field Note
PROGRAMMER:     K Wiggins
DATE:           08/22
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          Can't find old file (jan upload of fieldnote), DD said no code - she's out this week so do my best
                See readme_norc_aug_20220800.docx for details > Section FIELDNOTES

                Per Dionisia email 9/13, only include entries with kick off date - 
                
                copied 13b_getData_fieldnotes to this and removed what was no longer needed, but want to keep 13b just in case

-----------------------------------------------------------------------------------------------------*/

%let fieldnote = &raw/FASTFieldnote_raw_20230310.xlsx;
%INCLUDE "&code/13a_formats_fieldnotes.sas";

proc import 
    file = "&fieldnote."
    out = fn00
    dbms = xlsx replace;
    datarow = 3;
run; *515, 126;

* Add labels to saved lib / raw import just in case; 
data    fn01;
set     fn00;
label   session_num_0 = session_num_0
        session_num_1   = purpose_kickoff
        session_num_2   = Purpose_admin
        session_num_3   = purpose_workflow
        session_num_4   = purpose_data_HIT
        session_num_5   = purpose_QI
        session_num_6   = purpose_engagement
        session_num_7   = purpose_training
        session_num_8   = purpose_other
        num_ecounters_1 = "n Virtual QI Team Meeting(s)"
        num_ecounters_2 = "n Virtual meetings Other"
        num_ecounters_3 = "n Phone"
        num_ecounters_4 = "n Email"
        num_ecounters_5 = "n Other";

run; *515, 126;

* Check where there was > 1 field note if split id had kickoff; 
PROC PRINT DATA = fn00 ; 
VAR   sim_id kickoff_date KEEP_OR_DELETE survey_id ;
WHERE sim_id in ('2429','3355')
AND   kickoff_date ne ' ' ; 
RUN ; 

* Dropping cols and keeping where kickoff_date isn't missing only
two practices had kickoff_date for more than 1 session, so I kept the earliest one;
data fn02 ( keep = practice_id
                     kickoff_date
                     num_ecounters:
                     session_num: 
                     time: ) ;
set  fn01;

practice_id = input(sim_id, best12.);
drop sim_id;

if sim_id = 2429 and entity_task_id = 18621 then delete;
if sim_id = 3355 and task_assessment_period = "Oct, 2020" then delete;  

where kickoff_date is not missing;
format time: $time_.;
run; *2023/04/04: 52, 23 
      2023/02/16: 54, 23 
      2022/09/14 - 54, 23 ;

PROC SQL; 
CREATE TABLE fn02a AS 
SELECT * from fn02 
WHERE practice_id IN (SELECT prac_entity_split_id FROM out.inclusion) ; 
QUIT ;  * 50 ; 

proc sort data = fn02a; by practice_id; run;

proc freq data = fn02a; 
tables practice_id; 
run; * now all have only 1 each; 
/**/
/** Check if any practices not on baseline file; */
/*data fn02_id_check_baseline;*/
/*set  fn02;*/
/*if _n_ = 1*/
/*then do;*/
/*  declare hash d1 (dataset:"out.survey_baseline_20230321");*/
/*  d1.definekey("practice_id");*/
/*  d1.definedone();*/
/*end;*/
/*flag = (d1.check() = 0);*/
/*run;*/
/**/
/*proc print data = fn02_id_check_baseline;*/
/*where flag = 0; */
/*run;*/

%INCLUDE "&code/13a_formats_fieldnotes.sas";

* Dropping cols and keeping where kickoff_date isn't missing only;
data out.fn_final
         (KEEP= PRACTICE_ID
                DATE_OF_CONTACT
                GRANTEE
                MODE
                MODE_OTHER
                DURATION
                PRIMARY_PURPOSE
                PRIMARY_PURPOSE_OTHER
                ADDITIONAL_KICKOFF
                ADDITIONAL_ADMIN
                ADDITIONAL_WORKFLOW
                ADDITIONAL_HIT
                ADDITIONAL_QUALITY
                ADDITIONAL_ENGAGEMENT
                ADDITIONAL_TRAINING
                ADDITIONAL_OTHER
                NOTES   
                );
RETAIN  GRANTEE
        PRACTICE_ID
        DATE_OF_CONTACT
        MODE
        MODE_OTHER
        DURATION
        PRIMARY_PURPOSE
        PRIMARY_PURPOSE_OTHER
        ADDITIONAL_KICKOFF
        ADDITIONAL_ADMIN
        ADDITIONAL_WORKFLOW
        ADDITIONAL_HIT
        ADDITIONAL_QUALITY
        ADDITIONAL_ENGAGEMENT
        ADDITIONAL_TRAINING
        ADDITIONAL_OTHER
        NOTES   
        ;
set  fn02;
where kickoff_date is not missing;

* Add columns needed;
GRANTEE                 = "CO";
MODE                    = 4;                * using kickoff_date only, all mode is virtual;
MODE_OTHER              = '';               * no kickoff_date meetings were other;
DATE_OF_CONTACT         = kickoff_date;     * per Dionisia only reporting this;
PRIMARY_PURPOSE         = 1;                * kickoff date is 1;
PRIMARY_PURPOSE_OTHER   = 999;
ADDITIONAL_KICKOFF      = 999;              * since this is kickoff, won't have additional;
NOTES                   = 999;

format DURATION $time_.;

*create cols from variables;
if session_num_2 = 1 then ADDITIONAL_ADMIN = 1;
    else ADDITIONAL_ADMIN = 999;
if session_num_3 = 1 then ADDITIONAL_WORKFLOW = 1;
    else ADDITIONAL_WORKFLOW = 999;
if session_num_4 = 1 then ADDITIONAL_HIT = 1;
    else ADDITIONAL_HIT = 999;
if session_num_5 = 1 then ADDITIONAL_QUALITY = 1;
    else ADDITIONAL_QUALITY = 999;
if session_num_6 = 1 then ADDITIONAL_ENGAGEMENT = 1;
    else ADDITIONAL_ENGAGEMENT = 999;
if session_num_7 = 1 then ADDITIONAL_TRAINING = 1;
    else ADDITIONAL_TRAINING = 999;
if session_num_8 = 1 then ADDITIONAL_OTHER = 1;
    else ADDITIONAL_OTHER = 999;

if time_virtual_grp_mtg = . then DURATION = 999;
    else DURATION = time_virtual_grp_mtg;   * using only the duration for the primary_purpose (kickoff);
run; *09/15: 52, 17;

* Export;
proc export data = out.fn_final
  outfile = "&out/InterventionTracker"
  dbms=xlsx replace;
run;

* ----- SECOND ATTEMPT: UPLOAD -------------------;
* wouldn't upload with practice 2224; 
data out.fn_final_update;
set  out.fn_final;
if practice_id = "2224" then delete; 
run; *51, 17;

proc export data = out.fn_final_update
  outfile = "&feb/InterventionTracker_remove2224_"
  dbms=xlsx replace;
run;

* Get list of variable names for contents, means, frequency export; 
%put List of Variables=%mf_getvarlist(out.survey_baseline_20230123);

* Run macro for univariate data (globals);
%summary(ds=out.fn_final,out=fn_summary);


* ==== EXPORT CONTENTS, FREQUENCIES, MEANS ===================================================;

ods excel file = "&FEB/summary_fieldnotes.xlsx"
    options ( sheet_name = "contents" 
              sheet_interval = "none");

ods excel options ( sheet_interval = "now" sheet_name = "contents") ;

proc contents data = out.fn_final varnum; run;

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
