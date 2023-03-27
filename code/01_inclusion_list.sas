/*
PROJECT      FAST
PURPOSE:     Get Inclusion List: Practices with KickOff Date
PROGRAMMER:  K Wiggins
LAST RAN     02/16/2023
PROCESS:     Danika exports REDCap, Qualtrics to S:drive>data_team as <file>_raw_;
NOTES:       - Use split_id_verify 
             - Use dupdelete remove 1's : No longer in file, but was in Aug... 
             Checks:
                 - no keep / etc columns - all look complete - so kept all.
                 - 2022/08/20: Sent duplicate practice_id's to Sabrina Lor - practice_id 35, 141 this time 
             Expect: 
                 Final result for upload should have 74 columns and be in order acc to &template_fields;
        
-----------------------------------------------------------------------------------------------------*/

* ==== GLOBAL PATHS/ ALIASES  ===============================================================;
%INCLUDE "&import./meta.sas"; 

PROC SORT DATA= meta	; BY prac_entity_split_id ; RUN ; 

DATA out.INCLUSION ; 
SET  WORK.meta (KEEP = prac_entity_split_id );
FORMAT txt_prac_entity_split_id $ 4.; 
txt_prac_entity_split_id = put(prac_entity_split_id, $4.); 
RUN ; 

PROC TABULATE
DATA=OUT.INCLUSION;
VAR  prac_entity_split_id ;
	TABLE prac_entity_split_id * (N) 		;
RUN;