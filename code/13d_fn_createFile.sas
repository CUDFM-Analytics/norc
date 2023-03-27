/*
PROGRAM:        NORC upload
PURPOSE:        Intervention Tracker / Field Note
PROGRAMMER:     K Wiggins
DATE:           02/16/23
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          Issues resolved from 13c_ file (things exported / sent to Sabrina to check);
                This file based on responses from questions in there;

---------------------------------------------------------------------------------------------*/
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


