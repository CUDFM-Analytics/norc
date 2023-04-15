/*
PROJECT         FAST        
PURPOSE:        NORC upload
PROGRAMMER:     K Wiggins
LAST RAN:       02/16/23
PROCESS:        Export from redcap report          
--------------------------------------------------------------------------------------------
NOTES FEB re: split ID's, response from Danika regarding questions:: 

0    •  Guardian Angels Health Center (no splitID) : not FAST, only ISP. Split ID is 2083

1    •  Center Pointe Family Medicine— 
        has two record IDs because they enrolled in ISP in 2020 and then enrolled in FAST in 2021. 
        It’s the same practice and practice ID in SPLIT (3319), but if you’re looking at the payer data 
        that doesn’t match up across the records, then I would only look at Record 178 
        (row 115 in the spreadsheet you sent me) since that is the info the practice provided when enrolling in FAST.

TO SELECT : select the row where fast_pto = 2661 & practice_id = 3319/ code ROW 350

0    •  High Plains Adult Health Center— not enrolled in FAST, only ISP; they have two records because they completed an application for ISP twice. It’s the same practice with the same practice ID in SPLIT (2087) but one of the names listed is their “official practice name” and one is their “preferred practice name.”*/

* ==== IMPORT ===============================================================================;
proc import 
        file = "&application."
        out = app0
        dbms = csv replace;
run; *feb (jan data) 177, 24; 

PROC CONTENTS DATA = app0;
RUN; 

* ==== CHECK FOR DUPLICATES ===================================================================;
    PROC SQL;
    CREATE TABLE dup_id_split AS 
    SELECT prac_entity_split_id
         , count ( prac_entity_split_id ) as n_splitid
    FROM   app0
    GROUP BY prac_entity_split_id;
    QUIT; 

    PROC PRINT DATA = dup_id_split NOOBS;
    WHERE n_splitid > 1;
    RUN; 

    * 03/21 none 
      02/16 > Two records had > 1 split id: 2087, 3319 > emailed Danika with copy of .csv 
      02/16 > new practice without split id : clinic name 'Guardian Angels Health Center` ;
PROC SORT DATA = app0 ; by prac_entity_split_id ; RUN ; 
PROC PRINT DATA = app0 ; 
VAR prac_entity_split_id ; 
RUN ; 

* ==== SELECT COMPLETE RECORDS, RENAME ========================================================;

proc sql; 
create table app1 as
select PRAC_ENTITY_SPLIT_ID AS PRACTICE_ID
     , PAYERMIX_MEDICARE as PAYER_PERCENTAGE_MEDICARE
     , PAYERMIX_MEDICAID as PAYER_PERCENTAGE_MEDICAID
     , PAYERMIX_DUAL as PAYER_PERCENTAGE_DUAL
     , PAYERMIX_PRIVATE as PAYER_PERCENTAGE_PRIVATE
     , PAYERMIX_NOINS_SELFPAY as PAYER_PERCENTAGE_NO_INSURANCE
     , PAYERMIX_OTHER as PAYER_PERCENTAGE_OTHER
     , type___1 as PRACTICE_OWNERSHIP_SOLO_GROUP
     , type___2 as PRACTICE_OWNERSHIP_HOSPITAL
     , type___3 as PRACTICE_OWNERSHIP_HMO
     , type___4 as PRACTICE_OWNERSHIP_FQHC
     , type___6 as PRACTICE_OWNERSHIP_NONFED_GVMT
     , type___7 as PRACTICE_OWNERSHIP_ACADEMIC
     , type___8 as PRACTICE_OWNERSHIP_FEDERAL
     , type___9 as PRACTICE_OWNERSHIP_RURAL
     , type___10 as PRACTICE_OWNERSHIP_IHS
     , type____777 as PRACTICE_OWNERSHIP_OTHER
     , FAST_APPLICATION_COMPLETE
     , PCMH
from app0 
WHERE  prac_entity_split_id IN (SELECT prac_entity_split_id FROM out.inclusion);
quit; *52 ; 

    proc sort data = app1 ; by practice_id ; run; 
    proc print data = app1 ; run;


data out.app;
set  app1 (drop=fast_application_complete);
run; *04/03 [50, 18] -- ;
