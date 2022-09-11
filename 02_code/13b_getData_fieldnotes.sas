/*
PROGRAM:        NORC upload
PURPOSE:        Intervention Tracker / Field Note
PROGRAMMER:     K Wiggins
DATE:           08/28/2022
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          Can't find old file, DD said no code - she's out this week so do my best
                See readme_norc_aug_20220800.docx for details > Section FIELDNOTES

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
* macro for untranspose;
%include "C:/Users/wigginki/OneDrive - The University of Colorado Denver/sas/sas_macros/untranspose.sas";

proc import 
    file = "&fieldnote."
    out = fn0
    dbms = xlsx replace;
    datarow = 3;
run; *515, 126;

proc contents data = fn0;
run;

* I think formal_group is a FAST indicator but checking; 
* but then they have info in FFN columns (re: FAST) even if formal_group is 0 so IDK...;

proc freq data = fn0;
run; *save to logs/ results; 
*all 515 were 'keep';
* task_id's - one for during intervention, one for final;

proc freq data = fn0;
tables session: ;
run;

* Dropping cols I know I don't need to see what's left;
data fn1;
retain sim_id;
set  fn0;
drop browser: 
    task_id
    distribution: 
    IPAddress 
    Location: 
    Q88: 
    Qretired: 
    RE1: 
    RE5: 
    Userlanguage 
    Duration__in_seconds_
    startdate
    split_user_email_address
    assigned_entity_id 
    clinical_hit_advisor_pto 
    cohort 
    recipient: 
    Progress 
    keep_or_delete 
    FFN: 
    delete
    finished
    responseID
    ExternalReference
    desc:
    concerns
    pdf_export
    practice_type
    participants__66
    EndDate
    end_dtd
    entity_name
    entity_task_id
    practice_facilitator_pto
    practice_organization
    practice_site
    participants:
    elearn
    formal_group
    struggling
    no_encounters:
    status
    sbirt: 
    total_encounters
    recordeddate
    group_mtg_engage
    no_encounters_other
    group_mtg_num
    group_mtg_focus
    ;
label session_num_0 = session_num_0
    session_num_1   = purpose_kickoff
    session_num_2   = Purpose_admin
    session_num_3   = purpose_workflow
    session_num_4   = purpose_data_HIT
    session_num_5   = purpose_QI
    session_num_6   = purpose_engagement
    session_num_7   = purpose_training
    session_num_8   = purpose_other
/*    group_mtg_num   = "number of FAST group meetings practice participated in"*/
/*    group_mtg_focus = "main focus: monthly meeting"*/
    num_ecounters_1 = "n Virtual QI Team Meeting(s)"
    num_ecounters_2 = "n Virtual meetings Other"
    num_ecounters_3 = "n Phone"
    num_ecounters_4 = "n Email"
    num_ecounters_5 = "n Other";
/*    end_date        = "date session 6 completed";*/
where not(session_num_0 eq "1") or sim_id is missing;
format time: time_.;
run; *514, 28 when including session_num_0
when session_num_0 missing then 414, 26;

proc sort data = fn1; by sim_id; run;

data fn2; 
set  fn1;
practice_id = input(sim_id, best12.);
drop sim_id;
run; *414, 28;

* Subset to practices that are in baseline ; 
proc sql; 
create table fn3 as 
select * from fn2
where practice_id in (select practice_id 
                      from norc.survey_baseline);
run;
quit; *438, 32 with session_num_0 included
without session_num_0 then 365;

* Add date in the way requested;
data fn4;
set  fn3;
date_of_contact = input(task_assessment_period, $date_of_contact.);
run; *365, 27;

proc freq data = fn4;
tables date_of_contact;
run;

data fn_date;
set  fn4;
keep session_num: practice_id date_of_contact;
session_total = sum(of session_num_1 -- session_num_8);
if session_total = . then delete;
if session_num_0 = 1 then delete; 
drop session_num_0;
run; *288, 10;

data fn_date_t;
set  fn_date;
array d session_num_1-session_num_8;
do i=1 to dim(d);
    session_count = d{i};
    output;
    end;
keep session_count i practice_id date_of_contact;
run; *2304, 4;

data fn_date_t2 (drop=session_count);
set  fn_date_t;
where session_count = "1";
rename i = session_type;
run; *306, 3;

* drop session_num_ from fn4;
data fn5;
set  fn4; 
drop session_num: ;
run;

* Do same for number ecounters (sic);
proc freq data = fn4;
tables num: ; 
run;

data fn_encounters;
set  fn4;
keep num_: practice_id date_of_contact;
num_total = sum(of num_ecounters_1 -- num_ecounters_5);
if num_total = 0 then delete;
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

* Merge all; 
proc sort data = norc.fn_id_date; by practice_id; run;


proc sql; 
create table fn as 
select a.*
    , b.*
    , c.*
    , d.*
from norc.fn_id_date as a
left join norc.

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
