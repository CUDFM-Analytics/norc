proc import 
    file = "&template"
    out  = norc.templates
    dbms = xlsx replace;
run;

proc import 
    datafile = survtemp
    out      = norc.survey_field_order
    dbms     = xlsx replace;
	getnames = no;
run;
