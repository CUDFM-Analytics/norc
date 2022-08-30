/*
PROGRAM:   		NORC upload
PURPOSE:        Intervention Tracker / Field Note
PROGRAMMER:     K Wiggins
DATE:           08/28/2022
PROCESS:        Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:          Can't find old file, DD said no code - she's out this week so do my best
Variables needed, in order: 
		GRANTEE
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

-----------------------------------------------------------------------------------------------------
CHANGE LOG
 Date    By  Purpose
1. 08/28/22  KW  init

LAST RAN: 08/29/2022
*/

* Set global variables and function calls; 
* ROOT FOLDER  ---------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
* INCLUDE --------------------------------------------;
%include "&root/norc/code_folder/00_paths_lets.sas"; 
   *has paths and all let statements for project;

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
* why two task_id's if it's only post-intervention;

proc freq data = fn0;
tables session: ;
run;

* Dropping cols I know I don't need to see what's left;
data fn1;
retain sim_id;
set  fn0;
drop browser: 
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
	group_mtg_num   = "number of FAST group meetings practice participated in"
	group_mtg_focus = "main focus: monthly meeting"
	num_ecounters_1 = "n Virtual QI Team Meeting(s)"
	num_ecounters_2 = "n Virtual meetings Other"
	num_ecounters_3 = "n Phone"
	num_ecounters_4 = "n Email"
	num_ecounters_5 = "n Other"
	end_date        = "date session 6 completed";
where sim_id ne '';
format time: time_.;
run; *515, 30;

proc contents data = fn1 varnum;
title 'Abridged field notes Aug 2022';
run;

proc freq data = fn1;
run;

proc sort data = fn1; by sim_id; run;

data fn2; 
set  fn1;
practice_id = input(sim_id, best12.);
drop sim_id;
run;

proc sql; 
create table fn3 as 
select * from fn2
where practice_id in (select practice_id 
					  from norc.survey_baseline);
run;
quit; *438, 32;

proc export data = fn3
			outfile = "&norc/fn3_13a_raw_fieldnotes_&datestamp"
			dbms = xlsx replace; 
run;

*CHECKED COUNTS TO MAKE SURE EACH PRACTICE ID HAD ONE RESPONSE PER MONTH; 
* SEEMED OKAY; 
data fn_t;
set  fn3;
keep practice_id session: task_assessment_period;
run; 

proc sort data = fn_t;
by practice_id task_assessment_period; 
run;

proc freq data = fn3; 
tables practice_id*task_assessment_period;
run;

data fn_x;
set fn_t;
array vars session_num_0-session_num_8;                  *array of your columns to transpose;
do _t = 1 to dim(vars);              *iterate over the array (dim(vars) gives # of elements);
  if not missing(vars[_t]) then do;  *if the current array element's value is nonmissing;
    col1=vname(vars[_t]);            *then store the variable name from that array element in a var;
    col2=vars[_t];                   *and store the value from that array element in another var;
    output;                          *and finally output that as a new row;
  end;
end;
drop session_num_0-session_num_8 _t;                     *Drop the old vars (cols) and the dummy variable _t;
run;

proc freq data = fn3;
tables group_mtg_num group_mtg_focus session: ;
run;

proc print data = fn3;
var practice_id group_mtg_num session: ;
run;

GRANTEE
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
