/*
PURPOSE:         NORC metrics upload file
PROGRAMMER:      K Wiggins
DATE:            08/24/2022
PROCESS:         Danika Buss exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:           Process Measures => NORC 'METRICS' files) 
                  NOT SURE: Andrew hand-coded many and sent a document after the upload was due
                 used to be: - where task_id in (194 (baseline) & 215 (post)) & finished = 1;
                 Final result for upload should have 13 columns and be in order acc to &template_fields;
-----------------------------------------------------------------------------------------------------
LAST RAN: 04-04
*/

/*proc format;*/
/*value $metrics*/
/*    194 = "Baseline"*/
/*    215 = "Post";*/
/*RUN; */

* ==== GLOBAL PATHS/ ALIASES  ===============================================================;
/*%INCLUDE "V:/Data_Management_Team/norc/code/00_globals_20230200.sas"; */

* Macro for checking ID's against the inclusion list: ; 
%INCLUDE "&NORC./code/macros/check_ids.sas"; 

* ==== IMPORT ===============================================================================;
proc import 
        file = "&metrics."
        out = metrics0
        dbms = xlsx replace;
        datarow = 3;
run; *186, 105;

proc freq data = metrics0;
tables finished task_id keep_or_delete time_text;
run;

data  metrics1 ( keep = practice_id
                        task_id
                        m_pts
                        m_screend
                        m_AUD
                        m_BI
                        m_aud
                        m_mat
                        m_referrd ) ;
set   metrics0 ;

practice_id = input(sim_id, 8.);

WHERE keep_or_delete = "KEEP"
AND   task_id in ("194","215") ;

run; * april with task ids where: 91, 8 // april 186, 8 : previously when did task_id, 86, 8;

* Check against inclusion file: ;
%check_ids(out=id_metrics, b=metrics1); 

        PROC SQL; 
        SELECT count (distinct practice_id) 
        FROM   metrics1; 
        RUN; *48; 


proc sort data = metrics1 ; by practice_id ; run ; 

data metrics2;
set  metrics1;
rename
    practice_id = PRACTICE_ID
    m_pts       = M1_NUMBER
    m_screend   = M2_NUMBER
    m_aud       = M3_NUMBER
    m_bi        = M4_NUMBER
    m_mat       = M5_NUMBER
    m_referrd   = M6_NUMBER;
GRANTEE = 'CO';
run; *april 183,9 //  82,9;

proc freq data = metrics2;
tables practice_id*task_id /nopercent norow nocol;
run;

data metrics3;
set  metrics2;

WHERE M1_NUMBER ne 0;

M2_PERCENT = round(((M2_NUMBER/M1_NUMBER)*100),0.01);
M3_PERCENT = round(((M3_NUMBER/M1_NUMBER)*100),0.01);
M4_PERCENT = round(((M4_NUMBER/M1_NUMBER)*100),0.01);
M5_PERCENT = round(((M5_NUMBER/M1_NUMBER)*100),0.01);
M6_PERCENT = round(((M6_NUMBER/M1_NUMBER)*100),0.01);
run; * 178, 14 ; 

* Get order of variables for upload; 
proc print data = &template_fields;
where Template contains 'Process';
run;

* Set order ;
data   metrics3;
retain GRANTEE
        PRACTICE_ID
        M1_NUMBER
        M2_NUMBER
        M2_PERCENT
        M3_NUMBER
        M3_PERCENT
        M4_NUMBER
        M4_PERCENT
        M5_NUMBER
        M5_PERCENT
        M6_NUMBER
        M6_PERCENT;
set    metrics3;
run; *;

* check against ; 
PROC SQL ; 
CREATE TABLE out.metrics AS 
SELECT *
FROM metrics3 
WHERE practice_id IN (SELECT prac_entity_split_id FROM out.inclusion) 
AND   task_id IN (193, 215); 
QUIT ;  * 177, 14 ;  

* Keep with all task_id's for now - IDK what to do.; 
* Stopped here waited for decision from team regarding task_ids ; 

* Split file by task_id and drop column, save to library 'norc';
data out.metrics_baseline (drop=task_id) out.metrics_post (drop=task_id);
set out.metrics;
if task_id = 194 then output out.metrics_baseline; 
if task_id = 215 then output out.metrics_post;    
run; *45/13, 42/13;


* ==== EXPORT UPLOADS  ===================================================;
proc export data = out.metrics_baseline
    outfile = "&out/metrics_baseline"
    dbms=xlsx replace;
run; *45 April // march = 36 / feb = 45; 

proc export data = out.metrics_post
    outfile = "&out/metrics_post"
    dbms=xlsx replace;
run; *42 April //  34 March (from 37 feb with incorrect file?) ;



* delete BAK files created by PROC EXPORT;
filename bak  "&out/metrics_post.xlsx.bak";
filename bak2 "&out/metrics_baseline.xlsx.bak"; 

data _null_;
 rc = fdelete("bak");
 rc = fdelete("bak2");
run;

filename bak clear; 
filename bak2 clear;

