
* ==== ROOT DIRECTORY  ============================================;
%let ROOT = S:/FM/FM/Data_Management_Team;

* ==== Project Folders / libnames =================================;
%let NORC = &ROOT/norc;
%let docs = &NORC/docs;   * for template file;
%let code = &NORC/code;
%let import = &code/_config_imports; 

%let out  = &NORC/2023_03; * March sas exports, 2023 ; 
libname out "&out";

%LET aug= &norc./2022_08/data;
LIBNAME aug "&aug"; 

* ==== Raw data from Danika, exported from REDCap =================;
%let raw  = &ROOT/raw data; 
* Made my own raw folder for fixing issues for final upload; 


* Qualtrics sets (row 1 = colnames, row2 = labels, row 3 = data); 
* Updated 03/21;
%let metrics     = &raw/FASTMetrics_raw_20230310.xlsx;
%let metrics_sub = &raw/FASTMetricsSubmission_raw_20230310.xlsx;
%let sbirt       = &raw/FASTSBIRT_raw_20230216.xlsx;  * Danika redid with values rather than labels yay; 
%let fieldnote   = &raw/FASTFieldnote_raw_20230310.xlsx;

* non-Qualtrics sets (only need row 1, data starts on row 2;
%let meta        = &raw/FASTPracticeMeta_raw_20230310.csv;
%let monitor     = &raw/FASTPracticeMonitor_raw_20230310.xlsx;
%let survey      = &raw/FASTPracticeSurvey_raw_20230310.csv;
%let application = &raw/FASTApplication_raw_20230321.csv;

* ==== FILE aliases ===============================================;
%let template     = &docs/norc_templates_comments_20220824.xlsx;

*exported doc with templates and comments from NORC db;
%let survtemplate = &docs./survey_template_order.xlsx;
filename survtemp "&survtemplate";

* ==== FUNCTIONS / MACRO VARIABLES  ===============================;
%let template_fields = out.templates;
%let template_order  = out.survey_field_order;

* INCLUDE import template file (project, general) ; 
/*%INCLUDE "&import./templates.sas"; */

proc format lib = out;
   value missing .='999';
run;

* ---- GET DATE ---------------------------------------------------;
* adds datestamp to files; 
data _null_;
  call symputx('datestamp', put(date(),yymmddn8.));
run;
%put &datestamp;
/*%let filePath="/sasFolder/MyFileName(&datestamp).xlsx";*/

* ==== SET OPTIONS ================================================;
OPTIONS mprint 
        mlogic 
        symbolgen
        nonumber
        validvarname = V7;

* ==== FORMATS ====================================================;

proc format;
   value nmissfmt . ='999';
   value $ missfmt ' ' = "999";
run;

%macro summary(ds=, out=);  
proc univariate data = &ds outtable = &out ( KEEP = _var_ _nobs_ _nmiss_  _mean_ _std_ _min_ _max_) NORMAL noprint; 
run; 

proc print data = &out;
run; 
%mend;



%macro mf_getvarlist(libds
      ,dlm=%str( )
)/*/STORE SOURCE*/;
  /* declare local vars */
  %local outvar dsid nvars x rc dlm;
  /* open dataset in macro */
  %let dsid=%sysfunc(open(&libds));

  %if &dsid %then %do;
    %let nvars=%sysfunc(attrn(&dsid,NVARS));
    %if &nvars>0 %then %do;
      /* add first dataset variable to global macro variable */
      %let outvar=%sysfunc(varname(&dsid,1));
      /* add remaining variables with supplied delimeter */
      %do x=2 %to &nvars;
        %let outvar=&outvar.&dlm%sysfunc(varname(&dsid,&x));
      %end;
    %End;
    %let rc=%sysfunc(close(&dsid));
  %end;
  %else %do;
    %put unable to open &libds (rc=&dsid);
    %let rc=%sysfunc(close(&dsid));
  %end;
  &outvar
%mend;
