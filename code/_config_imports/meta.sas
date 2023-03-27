
* 001 : Import META with kickoff date = final practice list (inclusion rule = pracs with ko date); 
DATA WORK.meta;
    LENGTH
        prac_npi               8
        prac_entity_split_id   8
        eligible               8
        prctagrmnt_dtd         8
        kickoff_mtg_dtd        8
        intervention_arm       8
        randomization_dtd      8;
    KEEP
        prac_npi
        prac_entity_split_id
        eligible
        prctagrmnt_dtd
        kickoff_mtg_dtd
        intervention_arm
        randomization_dtd;
    FORMAT
        prac_npi         BEST10.
        prac_entity_split_id BEST4.
        eligible         BEST1.
        prctagrmnt_dtd   YYMMDD10.
        kickoff_mtg_dtd  YYMMDD10.
        intervention_arm BEST1.
        randomization_dtd YYMMDD10.;
    INFORMAT
        prac_npi         BEST10.
        prac_entity_split_id BEST4.
        eligible         BEST1.
        prctagrmnt_dtd   YYMMDD10.
        kickoff_mtg_dtd  YYMMDD10.
        intervention_arm BEST1.
        randomization_dtd YYMMDD10.;
    INFILE 'V:\Data_Management_Team\raw data\FASTPracticeMeta_raw_20230310.csv'
        LRECL=32767
        FIRSTOBS=2
        ENCODING="WLATIN1"
        DLM='2c'x
        MISSOVER
        DSD ;
    INPUT
        record_id        : $1.
        clinicname       : $1.
        clinicname_preferred : $1.
        prac_npi         : ?? BEST10.
        practiceorg      : $1.
        statecounty_fips : $1.
        ruca             : $1.
        prac_entity_split_id : ?? BEST4.
        org_entity_split_id : $1.
        ptocoach_org     : $1.
        eligible         : ?? BEST1.
        prctagrmnt_dtd   : ?? YYMMDD10.
        kickoff_mtg_dtd  : ?? YYMMDD10.
        intervention_arm : ?? BEST1.
        randomization_dtd : ?? YYMMDD10.
        randomization_notes : $CHAR321. ;
RUN;