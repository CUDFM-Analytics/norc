/*
PROJECT      FAST
PURPOSE:     EDA
PROGRAMMER:  K Wiggins
LAST RAN     03-16/2023
PROCESS:     For running eda > keep open during processing ;
NOTES:       ;
        
-----------------------------------------------------------------------------------------------------*/

* ==== GLOBAL PATHS/ ALIASES  ===============================================================;
/*%INCLUDE "V:/Data_Management_Team/norc/code/00_config_20230320.sas";   */

TITLE "Total practices (n) to include in final submission files" ; 
PROC TABULATE
DATA=OUT.INCLUSION;
VAR  prac_entity_split_id ;
    TABLE prac_entity_split_id * (N)    ;
RUN;
TITLE; 

%LET n_pracs = 50 ; 

DATA out.practiceID_survey (keep = practice_id survey present); 
SET  out.survey_baseline
     out.metrics
     out.sbirt
     out.fieldnote indsname=source ;
present = 1; 
survey = scan(source,2,'.'); 
RUN ; 


PROC SORT DATA = out.practiceID_survey NODUPKEY ; by _ALL_ ; RUN ;  * 198 ; 

data out.task_ids (keep=practice_id task_id dsname);
set  out.metrics 
     out.sbirt  indsname=source ;
dsname = scan(source,2,'.'); 
RUN ; 

PROC SQL;
CREATE TABLE out.tbl_surv_prac AS 
SELECT survey
     , count(practice_id) as n_pracs
     , case
        when survey = "SURVEY_BASELINE" then 'REDCAP Reports (2): Application, Survey'
        else 'Qualtrics'
     end as Source
     , case
        when survey = "SURVEY_BASELINE" then 'Baseline Only (1)'
        when survey = "METRICS" then 'Baseline, Post (2)'
        when survey = "SBIRT" then 'Baseline, Post (2)'
        else 'Final Only (1)'
        end as Uploads
FROM out.practiceID_survey
GROUP BY survey;
QUIT ; 

TITLE "Task IDs for SBIRT, Metrics Files" ; 
PROC FREQ DATA = out.practiceID_survey ; 
TABLES practice_id*survey / norow nocol nopercent out=out.tbl_prac_by_survey; 
RUN ; 



***** EXPORT *****************************************************; 

ods excel file = "&out/eda_fast_20230404.xlsx" options(flow = "tables"
                                                       embedded_titles="yes"
                                                       contents = "yes" 
                                                       autofilter = "all" 
                                                       frozen_headers = "yes"
                                                       frozen_rowheaders="1"
                                                       );

ods proclabel = "1) Uploads: Broad Overview"; 

title link="#'The Table of Contents'!a1"  "Return to TOC";
TITLE "Upload Overview" ; 
TITLE2 "Total Uploads: 6"; 
PROC PRINT DATA = out.tbl_surv_prac noobs; 
RUN ; 
title2; 

ods proclabel = "2) Practice ID Frequencies per Report Type"; 

title link="#'The Table of Contents'!a1"  "Return to TOC";
PROC FREQ 
     DATA = out.practiceID_survey;
     TABLES practice_id*survey / norow nocol nopercent ;* PLOTS = freqplot(type=dotplot scale=percent) out=out_ds;
RUN; 
TITLE; 

ods proclabel = "3) Metrics Task ID Frequencies" ; 

title link="#'The Table of Contents'!a1"  "Return to TOC";
TITLE2 "Task ID frequencies by practice ID, Metrics"; 
PROC FREQ DATA = out.task_ids ; 
where dsname = "METRICS";
TABLES practice_id*task_id / norow nocol nopercent ; 
RUN ; 
TITLE2 ; 

ods proclabel = "4) RESULTS: Survey Baseline"; 

title link="#'The Table of Contents'!a1"  "Return to TOC";
title2 "Survey: Baseline Results";
PROC PRINT DATA = out.survey_baseline noobs ; 
RUN ; 

ods proc label = "5) RESULTS: METRICS";   

title link="#'The Table of Contents'!a1"  "Return to TOC";
title2 "METRICS Report: All task_ids (final column)"; 
PROC PRINT DATA = out.metrics noobs; 
RUN ; 

ods proc label = "6) RESULTS: SBIRT"; 

title link="#'The Table of Contents'!a1"  "Return to TOC";
title2 "SBIRT Report: All task_ids (final column)"; 
PROC PRINT DATA = out.sbirt noobs ; 
RUN ; 

ods proc label = "7) RESULTS: Fieldnotes"; 

title link="#'The Table of Contents'!a1"  "Return to TOC";
title2 "Intervention Tracker Report"; 
PROC PRINT DATA = out.fieldnote noobs ; 
RUN ; 

ods excel close; 
