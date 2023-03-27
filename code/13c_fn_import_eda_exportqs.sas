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
run; *2023/02/16: 54, 23 
      2022/09/14 - 54, 23 

08/30: 514, 28 when including session_num_0
when session_num_0 missing then 414, 26;
proc sort data = fn02; by practice_id; run;

proc freq data = fn02; 
tables practice_id; 
run; * now all have only 1 each; 

* Check if any practices not on baseline file; 
data fn02_id_check_baseline;
set  fn02;
if _n_ = 1
then do;
  declare hash d1 (dataset:"out.survey_baseline_20230321");
  d1.definekey("practice_id");
  d1.definedone();
end;
flag = (d1.check() = 0);
run;

proc print data = fn02_id_check_baseline;
where flag = 0; 
run;



* END --------------------------------------------------;

