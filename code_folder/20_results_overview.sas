/*
PROGRAM:   	Make report of output 
PURPOSE:    NORC upload
PROGRAMMER: K Wiggins
DATE:       08/28/2022
PROCESS:    Sabrina Lor exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:      
-----------------------------------------------------------------------------------------------------
LAST RAN: 08/28/2022
*/

* Set global variables and function calls; 
* ROOT FOLDER  ---------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
* INCLUDE --------------------------------------------;
%include "&root/norc/code_folder/00_paths_lets.sas"; 
   *has paths and all let statements for project;
* Macro for data_specs info ;
%include "C:/Users/wigginki/OneDrive - The University of Colorado Denver/Documents/projects/00_sas_macros/data_specs.sas";

title 'NORC Upload 08/2022: Practice Survey';
*Get column names;  
proc sql;
create table columns as
select *
from sashelp.vcolumn 
where libname = upcase("NORC") and memname IN ("SURVEY_BASELINE"
												"METRICS_BASELINE"
												"METRICS_POST"
												"SBIRT_BASELINE"
												"SBIRT_POST");
quit; *200, 18;

proc print data = columns noobs;
var memname name label type length format informat;
run;

data survey (keep=practice_id);
set  norc.survey_baseline;
practice_id_char = put(practice_id, best12.);
drop practice_id;
rename practice_id_char = practice_id;
run;

data practice (keep = file practice_id);
set norc.metrics_baseline
	norc.metrics_post
	survey
	norc.sbirt_baseline
	norc.sbirt_post
	indsname=indsname;
file = indsname;
run;

data norc.practiceIDs_uploaded_aug;
retain file practice_id;
set  practice;
run;

proc freq data = norc.practiceIDs_uploaded_aug;
tables file; 
run;


proc print data = norc.survey_baseline;
run;

	
