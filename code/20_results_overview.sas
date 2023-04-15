*
PROGRAM:    Make report of output 
PURPOSE:    NORC upload
PROGRAMMER: K Wiggins
DATE:       08/28/2022
PROCESS:    Sabrina Lor exports REDCap, Qualtrics to S:drive>DATA_team as <file>_raw_
NOTES:    
VERSION:    04/04/2023;

/*%include "&code/13a_fn_formats.sas";*/
*-----------------------------------------------------------------------------------------------------;
**** CREATE TABLES *********************************************; 
PROC SQL;
CREATE TABLE columns AS
SELECT *
FROM sashelp.vcolumn 
WHERE LIBNAME = upcase("OUT") AND memname IN ("SURVEY_BASELINE"
                                              "METRICS_BASELINE"
                                              "METRICS_POST"
                                              "SBIRT_BASELINE"
                                              "SBIRT_POST"
                                              "FIELDNOTE");
QUIT; *200, 18;

DATA out.id_prac_surveys (KEEP = file practice_id);
SET  out.metrics_baseline
     out.metrics_post
     out.sbirt_baseline
     out.sbirt_post
     out.fieldnote
     out.survey_baseline
     indsname=indsname;
file = indsname;
RUN;

DATA out.id_aug_surveys (keep = practice_id file);
SET  aug.metrics_baseline
     aug.metrics_post
     aug.sbirt_baseline
     aug.sbirt_post 
     aug.survey_baseline
     indsname=indsname;
file = indsname;
RUN;

DATA aug.practiceids_uploaded_aug; 
SET  aug.practiceids_uploaded_aug;
id_prac_num = input(practice_id, best12.); 
file = tranwrd(file, "survey","survey_baseline");
RUN ; 

proc freq data = aug.practiceids_uploaded_aug; TABLES file ; run ; 
proc freq data = out.id_prac_surveys;          TABLES file ; run ; 


PROC SQL; 
CREATE TABLE compare_aug0a AS 
SELECT practice_id
     , substr(file, 5) as survey
FROM out.id_prac_surveys;
QUIT; 

PROC SQL; 
CREATE TABLE compare_aug0b AS 
SELECT practice_id
     , substr(file, 5) as survey
FROM out.id_aug_surveys;
QUIT; 

* Compare to August; 
PROC SQL; 
CREATE TABLE compare_aug1 AS 
SELECT coalesce (a.practice_id, b.practice_id) as practice_id
     , a.survey as apr_23
     , b.survey as aug_22
FROM compare_aug0a AS a
FULL 
JOIN compare_aug0b AS b
ON   a.practice_id = b.practice_id
AND  a.survey = b.survey
WHERE apr_23 not in ("FIELDNOTE")
;
QUIT; 

DATA out.compare_aug_apr (keep = practice_id survey apr23 aug22);
SET  compare_aug1; 
SURVEY = coalescec(apr_23, aug_22); 
aug22 = aug_22 ne ' ';
apr23 = apr_23 ne ' '; 
RUN ; 



PROC SORT DATA = compare_aug1 NODUPKEY OUT=out.compare_aug_pracs; BY _ALL_ ; RUN ; 



**** EXPORT *****************************************************; 

ODS EXCEL FILE = "&out./uploads_summary.xlsx";

PROC FREQ DATA = out.id_prac_surveys ;
TABLES file; 
RUN;

PROC PRINT data = out.compare_aug_apr noobs ; RUN ; 

* Print column names;  
PROC PRINT DATA = columns NOOBS;
VAR memname name type length format informat label;
RUN;

PROC SORT DATA = out.id_prac_surveys ; BY practice_id ; RUN; 
PROC PRINT DATA = out.id_prac_surveys NOOBS ; 
RUN ; 

ods excel close; 

 

