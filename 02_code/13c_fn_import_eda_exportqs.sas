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

-----------------------------------------------------------------------------------------------------
CHANGE LOG
Date    By      Purpose
09/09   KTW     Updated paths / global variables
09/15   KTW     Refactored, reran (changed fn ds names added #'s
*/

* Set global variables and function calls; 
* ROOT FOLDER  ---------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
* INCLUDE --------------------------------------------;
%include "&root/norc/02_code/00_paths_aliases.sas"; 
   *has paths and all let statements for project;
%include "&code/13a_fn_formats.sas";

proc import 
    file = "&fieldnote."
    out = fn00
    dbms = xlsx replace;
    datarow = 3;
run; *515, 126;

* Add labels to saved lib / raw import just in case; 
data    norc.fn00_raw;
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

proc freq data = norc.fn00_raw;
run;

proc contents data = norc.fn00_raw;
run;

* Dropping cols and keeping where kickoff_date isn't missing only;
data fn01;
set  norc.fn00_raw;
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
proc sort data = fn01; by sim_id; run;

proc freq data = fn01; 
tables practice_id; 
run;

* 3355 just put their kick off date in a different session_num?? - maybe they all did even when it wasn't session_1??;
proc print data = fn1;
where sim_id in ('2429','3355');
run;

data norc.fn01_dupes;
set  fn01;
where sim_id in ('2429','3355');
run;

        * Export to send to Sabrina to check sim_id (on the other file, the sim_id wasn't a duplicate but was in fact incorrect...);
        proc export data = norc.fn01_dupes
          outfile = "&norc/fn_dups_&datestamp"
          dbms=xlsx replace;
        run;
        * Per Sabrina - those are indeed duplicates from same practice; 


* Check if any practices not on baseline file; 
data norc.fn02_id_check_baseline;
set fn01;
if _n_ = 1
then do;
  declare hash d1 (dataset:"norc.survey_baseline");
  d1.definekey("practice_id");
  d1.definedone();
end;
flag = (d1.check() = 0);
run;

proc print data = norc.fn02_id_check_baseline;
where flag = 0; 
run;

proc export data = norc.fn02_id_check_baseline
  outfile = "&norc/fn_v_baseline_&datestamp"
  dbms=xlsx replace;
run;

* END --------------------------------------------------;

