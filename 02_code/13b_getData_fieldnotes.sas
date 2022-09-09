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
    num_ecounters_5 = "n Other"
/*    end_date        = "date session 6 completed";*/
where sim_id ne '';
format time: time_.;
run; *514, 28;

proc contents data = fn1 varnum;
title 'Abridged field notes Aug 2022';
run;

proc freq data = fn1;
tables sim_id num_ecounters: session_num: time: task: ;
run;


proc sort data = fn1; by sim_id; run;

data fn2; 
set  fn1;
practice_id = input(sim_id, best12.);
drop sim_id;
run; (514, 28;

* Subset to practices that are in baseline ; 
proc sql; 
create table fn3 as 
select * from fn2
where practice_id in (select practice_id 
                      from norc.survey_baseline);
run;
quit; *438, 32;

* Add date in the way requested;
data fn4;
set  fn3;
date_of_contact = input(task_assessment_period, $date_of_contact.);
run; *438, 29;

proc freq data = fn4;
tables date_of_contact;
run;

data fn_date;
set  fn4;
keep session_num: practice_id session_total date_of_contact;
session_total = sum(of session_num_:);
if session_total = . then delete;
if session_num_0 = 1 then delete; 
drop session_num_0;
run; *288, 1;

data fn_date2;
set  fn4;
keep session_num: practice_id date_of_contact;
session_total = sum(of session_num_1 -- session_num_8);
if session_total = . then delete;
if session_num_0 = 1 then delete; 
drop session_num_0;
run; *288, 10;

* use transpose variable to transpose session_num (type of session); 
%untranspose(data = fn_date2,out = t,by = practice_id);






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
