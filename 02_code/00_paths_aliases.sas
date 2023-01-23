
* FOLDERS --------------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
%let raw  = &root/raw data; *Sabrina's uploads;
%let norc = &root/norc/03_data;
%let form = &root/norc/01_background; *template file;
%let code = &root/norc/02_code;
%let logs = &root/norc/02_logs;
%let upld = &root/norc/05_uploaded_august2022;


* FILES ----------------------------------------------;
%let template = &form/norc_templates_comments_20220824.xlsx;
        *exported doc with templates and comments from NORC db;
%let survtemplate = &form./survey_template_order.xlsx;
filename survtemp "&survtemplate";
* DATA -----------------------------------------------;

* Qualtrics sets (row 1 = colnames, row2 = labels, row 3 = data); 
%let metrics     = &data/FASTMetrics_raw_08222022.xlsx;
%let metrics_sub = &data/FASTMetricsSubmission_raw_08222022.xlsx;
%let sbirt       = &data/FASTSBIRT_raw_08222022.xlsx;
%let fieldnote   = &data/FASTFieldnote_raw_08222022.xlsx;

* non-Qualtrics sets (only need row 1, data starts on row 2;
%let meta        = &data/FASTPracticeMeta_raw_08222022.csv;
%let monitor     = &data/FASTPracticeMonitor_raw_08222022.xlsx;
%let survey      = &data/FASTPracticeSurvey_raw_08222022.csv;
%let application = &data/FASTApplication_raw_08222022.csv;
* Macros ---------------------------------------------;
%let template_fields = norc.templates;

* Get date ;
data _null_;
  call symputx('datestamp', put(date(),yymmddn8.));
run;
%put &datestamp;
/*%let filePath="/sasFolder/MyFileName(&datestamp).xlsx";*/

* LIBNAME --------------------------------------------;
libname norc "&norc";
* Options --------------------------------------------;
OPTIONS mprint 
        mlogic 
        symbolgen
        nonumber
        validvarname = V7;

proc format lib = norc;
   value missing .='999';
run;

%include "C:/Users/wigginki/OneDrive - The University of Colorado Denver/sas/sas_formats/procFreq_pct.sas";
