/*
PROGRAM:        NORC upload
PURPOSE:        Intervention Tracker / Field Note
PROGRAMMER:     K Wiggins
DATE:           08/28/2022
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          Can't find old file, DD said no code - she's out this week so do my best
                See readme_norc_aug_20220800.docx for details > Section FIELDNOTES

                Per Dionisia email 9/13, only include entries with kick off date - 
                
                copied 13b_getData_fieldnotes to this and removed what was no longer needed, but want to keep 13b just in case

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

proc import 
    file = "&fieldnote."
    out = fn0
    dbms = xlsx replace;
    datarow = 3;
run; *515, 126;

proc freq data = fn0;
tables session: ;
run;

proc contents data = fn0;
run;

* Add labels to saved lib / raw import just in case; 
data    norc.fn_raw;
set     fn0;
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

* Dropping cols and keeping where kickoff_date isn't missing only;
data fn1;
set  norc.fn_raw;
keep practice_id
     kickoff_date
     num_ecounters:
     session_num: 
     time: ;
practice_id = input(sim_id, best12.);
drop sim_id;
where kickoff_date is not missing;
format time: time_.;
run; *2022/09/14 - 54, 23 

08/30: 514, 28 when including session_num_0
when session_num_0 missing then 414, 26;

proc sort data = fn1; by sim_id; run;

proc freq data = fn1; 
tables practice_id; 
run;

* 3355 just put their kick off date in a different session_num?? - maybe they all did even when it wasn't session_1??;
proc print data = fn1;
where sim_id in ('2429','3355');
run;

        * Export to send to Sabrina to check sim_id (on the other file, the sim_id wasn't a duplicate but was in fact incorrect...);
        proc export data = norc.fn_dup
          outfile = "&norc/fn_dups_&datestamp"
          dbms=xlsx replace;
        run;
        * Per Sabrina - those are indeed duplicates from same practice; 

* change to numeric so you can use only the practice_id's submitted in baseline? ; 
data fn2; 
set  fn1;

run; *54, 23 09/15
414, 28;

* Remove duplicate entries from 2429, 3355
I randomly kept the one with the highest email count (also had the right date format for 3355); 
data fn3; 
set  fn2;
if practice_id = '2429' and num_ecounters_4 = 2 then delete;
if practice_id = '3355' and num_ecounters_4 = 3 then delete;
drop num_ecounters: ;
run; *52, 18;

        * Check if any practices not on baseline file; 
        data norc.fn_compare_bl;
        set fn2;
        if _n_ = 1
        then do;
          declare hash d1 (dataset:"norc.survey_baseline");
          d1.definekey("practice_id");
          d1.definedone();
        end;
        flag = (d1.check() = 0);
        run;

        proc print data = norc.fn_compare_bl;
        where flag = 0; 
        run;

        proc export data = norc.fn_compare_bl
          outfile = "&norc/fn_v_baseline_&datestamp"
          dbms=xlsx replace;
        run;

proc print data = fn3;
run;

proc freq data = fn3;
tables time:; 
run;
* use virtual for all mode, mode_other make 999 (all meetings were virtual);
data fn4;
set  fn3;
GRANTEE             = "CO";
MODE                = 1;
MODE_OTHER          = 999;
DATE_OF_CONTACT     = kickoff_date;
PRIMARY_PURPOSE     = 1;
ADDITIONAL_KICKOFF  = 999;
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
else DURATION = time_virtual_grp_mtg time_.;
NOTES = 999;
run;

proc contents data = fn4 varnum; 
run;

data fn_encounters_t;
set  fn_encounters;
array d num_ecounters_1-num_ecounters_5;
do i=1 to dim(d);
    encounter_types_n = d{i};
    output;
    end;
drop num_ecounters: num_total;
rename i = encounter_type;
run; *1440, 5;

data fn_encounters_t2;
set  fn_encounters_t;
where encounter_types_n > 0;
run; *from 1440 to 586;

data fn_encounters_t3;
set  fn_encounters_t2; 
mode = put(encounter_type, encounter_type.);
run;

* drop num_ecounter from fn5;
data fn6 (drop=num_ecounter: ); 
set  fn5;
rename other_ecounter_type = mode_other;
run; *365, 13;


* Do for time; 
proc freq data = fn4;
tables time: ; 
run;

data fn_time;
set  fn4;
keep time: practice_id date_of_contact;
time_total = sum(of time_virtual_grp_mtg -- time_other_enc_type);
if time_total = . then delete;
drop time_prepare time_total;
run; *288, 9;

proc sort data = fn_time; by practice_id date_of_contact; run;
proc transpose data = fn_time out=fn_time2;
by practice_id date_of_contact;
run;

data fn_time3;
set  fn_time2;
if col1 = . then delete; 
rename col1 = duration
     _name_ = mode_type;
drop _label_;
run;

*drop time from fn6; 
data fn7;
set  fn6;
drop time: kickoff_date survey_id task_assessment_period;
run; *365, 3; 

* save final versions: ;
data norc.fn_id_date; 
set  fn7;
run;

data norc.fn_time;
set  fn_time3;
run;

data norc.fn_encounters;
set  fn_encounters_t3;
run;

data norc.fn_session;
set  fn_date_t2;
run;  

proc sort data = norc.fn_id_date; by practice_id; run;


* Export files (copied from sbirt code, ctrl_h replace for fn);


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
