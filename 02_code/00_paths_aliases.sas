
* FOLDERS --------------------------------------------;
%let root = S:/FM/FM/Data_Management_Team;
%let raw  = &root/raw data; *Sabrina's uploads;
%let in   = &root/norc/03_data_raw;
%let form = &root/norc/01_background; *template file;
%let code = &root/norc/02_code;
%let logs = &root/norc/02_logs;
%let upld = &root/norc/05_uploaded_august2022;
%let out  = &root/norc/04_data;

* FILES ----------------------------------------------;
%let template = &form/norc_templates_comments_20220824.xlsx;
        *exported doc with templates and comments from NORC db;
%let survtemplate = &form./survey_template_order.xlsx;
filename survtemp "&survtemplate";
* DATA -----------------------------------------------;

* Qualtrics sets (row 1 = colnames, row2 = labels, row 3 = data); 
* ctrl+h to replace date using from _08222022 to _20230120 (how Danika saved it);
%let metrics     = &raw/FASTMetrics_raw_20230120.xlsx;
%let metrics_sub = &raw/FASTMetricsSubmission_raw_20230120.xlsx;
%let sbirt       = &raw/FASTSBIRT_raw_20230120.xlsx;
%let fieldnote   = &raw/FASTFieldnote_raw_20230120.xlsx;

* non-Qualtrics sets (only need row 1, data starts on row 2;
%let meta        = &raw/FASTPracticeMeta_raw_20230120.csv;
%let monitor     = &raw/FASTPracticeMonitor_raw_20230120.xlsx;
%let survey      = &raw/FASTPracticeSurvey_raw_20230120.csv;
%let application = &raw/FASTApplication_raw_20230123.csv;
* Macros ---------------------------------------------;
%let template_fields = out.templates;
%let template_order  = out.survey_field_order;

* Get date ;
data _null_;
  call symputx('datestamp', put(date(),yymmddn8.));
run;
%put &datestamp;
/*%let filePath="/sasFolder/MyFileName(&datestamp).xlsx";*/

* LIBNAME --------------------------------------------;
libname out "&out";
* Options --------------------------------------------;
OPTIONS mprint 
        mlogic 
        symbolgen
        nonumber
        validvarname = V7;

proc format lib = out;
   value missing .='999';
run;

