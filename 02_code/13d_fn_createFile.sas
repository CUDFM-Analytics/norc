/*
PROGRAM:        NORC upload
PURPOSE:        Intervention Tracker / Field Note
PROGRAMMER:     K Wiggins
DATE:           08/28/2022
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          Issues resolved from 13c_ file (things exported / sent to Sabrina to check);
                This file based on responses from questions in there;

-----------------------------------------------------------------------------------------------------
CHANGE LOG
Date    By      Purpose
09/09   KTW     Updated paths / global variables
                re-ran all code
*/

* Set global variables and function calls; 
* ROOT FOLDER  ---------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
* INCLUDE --------------------------------------------;
%include "&root/norc/02_code/00_paths_aliases.sas"; 
   *has paths and all let statements for project;
%include "&code/13a_formats_fieldnotes.sas";

* Dropping cols and keeping where kickoff_date isn't missing only;
data norc.fn_final
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
set  norc.fn_raw;
where kickoff_date is not missing;

* Add columns needed;
GRANTEE                 = "CO";
MODE                    = 1;                * using kickoff_date only so all mode is virtual;
MODE_OTHER              = 999;              * no kickoff_date meetings were other;
DATE_OF_CONTACT         = kickoff_date;     * per Dionisia only reporting this;
PRIMARY_PURPOSE         = 1;                * kickoff date is 1;
PRIMARY_PURPOSE_OTHER   = 999;
ADDITIONAL_KICKOFF      = 999;              * since this is kickoff, won't have additional;
PRACTICE_ID             = input(sim_id, best12.);   * make numeric to merge / use only practiceid's in baseline;
NOTES                   = 999;

format DURATION time_.;

if practice_id = '2429' and num_ecounters_4 = 2 then delete;    * was duplicate (per Sabrina, 13c_);
if practice_id = '3355' and num_ecounters_4 = 3 then delete;    * was duplicate (per Sabrina, 13c_);

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
proc export data = norc.fn_final
  outfile = "&norc/InterventionTracker_&datestamp"
  dbms=xlsx replace;
run;

* ----- SECOND ATTEMPT: UPLOAD -------------------;
* wouldn't upload with practice 2224; 
data norc.fn_final_update;
set  norc.fn_final;
if practice_id = "2224" then delete; 
run; *51, 17;

proc export data = norc.fn_final_update
  outfile = "&norc/InterventionTracker_attempt2_&datestamp"
  dbms=xlsx replace;
run;
