**********************************************************************************************
 PROJECT       : NORC
 PROGRAMMER    : KTW
 DATE RAN      : 2023-02-15
 PURPOSE       : Get templates and survey_fields
***********************************************************************************************;

proc import 
    file = "&template"
    out  = out.templates
    dbms = xlsx replace;
run;
proc import 
    datafile = survtemp
    out      = out.survey_field_order
    dbms     = xlsx replace;
    getnames = no;
run;

