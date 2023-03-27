/* --------------------------------------------------------------------
 
   Generated on Tuesday, March 21, 2023 at 11:45:17 AM

   Source file: V:\Data_Management_Team\raw
   data\FASTSBIRT_raw_20230310_kw.xlsx
   Server:      Local File System
   
   Output data: WORK.FASTSBIRT_RAW_20230310_KW_0000
   Server:      Local
   -------------------------------------------------------------------- */

DATA WORK.sbirt0;
    LENGTH
        AUD_pts_screen   $ 1
        screentools_1    $ 1
        screentools_2    $ 1
        screentools_3    $ 1
        screentools__66  $ 1
        screentools__66_TEXT $ 64
        patient_type_1   $ 1
        patient_type_2   $ 1
        patient_type_3   $ 1
        patient_type_4   $ 1
        patient_type_5   $ 1
        patient_type_6   $ 1
        patient_type__66 $ 1
        patient_type_2_TEXT $ 50
        patient_type_3_TEXT $ 71
        patient_type__66_TEXT $ 136
        Frequency        $ 1
        workflow_person_1 $ 1
        workflow_person_2 $ 1
        workflow_person_3 $ 1
        workflow_person_4 $ 1
        workflow_person_5 $ 1
        workflow_person_6 $ 1
        workflow_person_7 $ 1
        workflow_person_8 $ 1
        workflow_person__66 $ 1
        workflow_person__66_TEXT $ 12
        tools_1          $ 1
        tools_2          $ 1
        tools_3          $ 1
        tools_4          $ 1
        tools_5          $ 1
        tools__66        $ 1
        tools__66_TEXT   $ 48
        review_rslts     $ 1
        interpret_1      $ 1
        interpret_2      $ 1
        interpret_3      $ 1
        interpret_4      $ 1
        interpret_5      $ 1
        interpret__66    $ 1
        interpret__66_TEXT $ 71
        positive_AUD     $ 1
        further_assess_1 $ 1
        further_assess_2 $ 1
        further_assess_3 $ 1
        further_assess__66 $ 1
        further_assess__66_TEXT $ 138
        feedback         $ 1
        care_AUD         $ 1
        support_1        $ 1
        support_2        $ 1
        support_3        $ 1
        support_4        $ 1
        support_5        $ 1
        support_6        $ 1
        support_7        $ 1
        support_8        $ 1
        support__66      $ 1
        support__66_TEXT $ 166
        practice_site    $ 51
        sim_id           $ 4
        cohort           $ 24
        practice_type    $ 85
        practice_organization $ 32
        practice_facilitator_pto $ 49
        clinical_hit_advisor_pto $ 1
        split_user_email_address $ 32
        entity_name      $ 1
        assigned_entity_id $ 32
        task_id          $ 3
        survey_id        $ 2
        entity_task_id   $ 5
        task_assessment_period $ 7
        KEEP_OR_DELETE   $ 6 ;
    DROP
        StartDate
        EndDate
        Status
        IPAddress
        Progress
        Duration__in_seconds_
        Finished
        ResponseId
        RecipientLastName
        RecipientFirstName
        RecipientEmail
        ExternalReference
        LocationLatitude
        LocationLongitude
        DistributionChannel
        UserLanguage
        RE1_First_Click
        RE1_Last_Click
        RE1_Page_Submit
        RE1_Click_Count
        RE5_Browser
        RE5_Version
        RE5_Operating_System
        RE5_Resolution
        Q22_First_Click
        Q22_Last_Click
        Q22_Page_Submit
        Q22_Click_Count
        RE3_First_Click
        RE3_Last_Click
        RE3_Page_Submit
        RE3_Click_Count
        pdf_export ;
    LABEL
        screentools__66  = "screentools_-66"
        screentools__66_TEXT = "screentools_-66_TEXT"
        patient_type__66 = "patient_type_-66"
        patient_type__66_TEXT = "patient_type_-66_TEXT"
        workflow_person__66 = "workflow_person_-66"
        workflow_person__66_TEXT = "workflow_person_-66_TEXT"
        tools__66        = "tools_-66"
        tools__66_TEXT   = "tools_-66_TEXT"
        interpret__66    = "interpret_-66"
        interpret__66_TEXT = "interpret_-66_TEXT"
        further_assess__66 = "further_assess_-66"
        further_assess__66_TEXT = "further_assess_-66_TEXT"
        support__66      = "support_-66"
        support__66_TEXT = "support_-66_TEXT"
        KEEP_OR_DELETE   = "KEEP OR DELETE" ;
    FORMAT
        AUD_pts_screen   $CHAR1.
        screentools_1    $CHAR1.
        screentools_2    $CHAR1.
        screentools_3    $CHAR1.
        screentools__66  $CHAR1.
        screentools__66_TEXT $CHAR64.
        patient_type_1   $CHAR1.
        patient_type_2   $CHAR1.
        patient_type_3   $CHAR1.
        patient_type_4   $CHAR1.
        patient_type_5   $CHAR1.
        patient_type_6   $CHAR1.
        patient_type__66 $CHAR1.
        patient_type_2_TEXT $CHAR50.
        patient_type_3_TEXT $CHAR71.
        patient_type__66_TEXT $CHAR136.
        Frequency        $CHAR1.
        workflow_person_1 $CHAR1.
        workflow_person_2 $CHAR1.
        workflow_person_3 $CHAR1.
        workflow_person_4 $CHAR1.
        workflow_person_5 $CHAR1.
        workflow_person_6 $CHAR1.
        workflow_person_7 $CHAR1.
        workflow_person_8 $CHAR1.
        workflow_person__66 $CHAR1.
        workflow_person__66_TEXT $CHAR12.
        tools_1          $CHAR1.
        tools_2          $CHAR1.
        tools_3          $CHAR1.
        tools_4          $CHAR1.
        tools_5          $CHAR1.
        tools__66        $CHAR1.
        tools__66_TEXT   $CHAR48.
        review_rslts     $CHAR1.
        interpret_1      $CHAR1.
        interpret_2      $CHAR1.
        interpret_3      $CHAR1.
        interpret_4      $CHAR1.
        interpret_5      $CHAR1.
        interpret__66    $CHAR1.
        interpret__66_TEXT $CHAR71.
        positive_AUD     $CHAR1.
        further_assess_1 $CHAR1.
        further_assess_2 $CHAR1.
        further_assess_3 $CHAR1.
        further_assess__66 $CHAR1.
        further_assess__66_TEXT $CHAR138.
        feedback         $CHAR1.
        care_AUD         $CHAR1.
        support_1        $CHAR1.
        support_2        $CHAR1.
        support_3        $CHAR1.
        support_4        $CHAR1.
        support_5        $CHAR1.
        support_6        $CHAR1.
        support_7        $CHAR1.
        support_8        $CHAR1.
        support__66      $CHAR1.
        support__66_TEXT $CHAR166.
        practice_site    $CHAR51.
        sim_id           $CHAR4.
        cohort           $CHAR24.
        practice_type    $CHAR85.
        practice_organization $CHAR32.
        practice_facilitator_pto $CHAR49.
        clinical_hit_advisor_pto $CHAR1.
        split_user_email_address $CHAR32.
        entity_name      $CHAR1.
        assigned_entity_id $CHAR32.
        task_id          $CHAR3.
        survey_id        $CHAR2.
        entity_task_id   $CHAR5.
        task_assessment_period $CHAR7.
        KEEP_OR_DELETE   $CHAR6. ;
    INFORMAT
        AUD_pts_screen   $CHAR1.
        screentools_1    $CHAR1.
        screentools_2    $CHAR1.
        screentools_3    $CHAR1.
        screentools__66  $CHAR1.
        screentools__66_TEXT $CHAR64.
        patient_type_1   $CHAR1.
        patient_type_2   $CHAR1.
        patient_type_3   $CHAR1.
        patient_type_4   $CHAR1.
        patient_type_5   $CHAR1.
        patient_type_6   $CHAR1.
        patient_type__66 $CHAR1.
        patient_type_2_TEXT $CHAR50.
        patient_type_3_TEXT $CHAR71.
        patient_type__66_TEXT $CHAR136.
        Frequency        $CHAR1.
        workflow_person_1 $CHAR1.
        workflow_person_2 $CHAR1.
        workflow_person_3 $CHAR1.
        workflow_person_4 $CHAR1.
        workflow_person_5 $CHAR1.
        workflow_person_6 $CHAR1.
        workflow_person_7 $CHAR1.
        workflow_person_8 $CHAR1.
        workflow_person__66 $CHAR1.
        workflow_person__66_TEXT $CHAR12.
        tools_1          $CHAR1.
        tools_2          $CHAR1.
        tools_3          $CHAR1.
        tools_4          $CHAR1.
        tools_5          $CHAR1.
        tools__66        $CHAR1.
        tools__66_TEXT   $CHAR48.
        review_rslts     $CHAR1.
        interpret_1      $CHAR1.
        interpret_2      $CHAR1.
        interpret_3      $CHAR1.
        interpret_4      $CHAR1.
        interpret_5      $CHAR1.
        interpret__66    $CHAR1.
        interpret__66_TEXT $CHAR71.
        positive_AUD     $CHAR1.
        further_assess_1 $CHAR1.
        further_assess_2 $CHAR1.
        further_assess_3 $CHAR1.
        further_assess__66 $CHAR1.
        further_assess__66_TEXT $CHAR138.
        feedback         $CHAR1.
        care_AUD         $CHAR1.
        support_1        $CHAR1.
        support_2        $CHAR1.
        support_3        $CHAR1.
        support_4        $CHAR1.
        support_5        $CHAR1.
        support_6        $CHAR1.
        support_7        $CHAR1.
        support_8        $CHAR1.
        support__66      $CHAR1.
        support__66_TEXT $CHAR166.
        practice_site    $CHAR51.
        sim_id           $CHAR4.
        cohort           $CHAR24.
        practice_type    $CHAR85.
        practice_organization $CHAR32.
        practice_facilitator_pto $CHAR49.
        clinical_hit_advisor_pto $CHAR1.
        split_user_email_address $CHAR32.
        entity_name      $CHAR1.
        assigned_entity_id $CHAR32.
        task_id          $CHAR3.
        survey_id        $CHAR2.
        entity_task_id   $CHAR5.
        task_assessment_period $CHAR7.
        KEEP_OR_DELETE   $CHAR6. ;
    INFILE 'C:\Users\wigginki\AppData\Roaming\SAS\EnterpriseGuide\EGTEMP\SEG-17576-909d6cf2\contents\FASTSBIRT_raw_20230310_kw-b41bb4997b1e4208a9f375b330c2d6c9.txt'
        LRECL=913
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        StartDate        : $1.
        EndDate          : $1.
        Status           : $1.
        IPAddress        : $1.
        Progress         : $1.
        Duration__in_seconds_ : $1.
        Finished         : $1.
        RecordedDate     : $1.
        ResponseId       : $1.
        RecipientLastName : $1.
        RecipientFirstName : $1.
        RecipientEmail   : $1.
        ExternalReference : $1.
        LocationLatitude : $1.
        LocationLongitude : $1.
        DistributionChannel : $1.
        UserLanguage     : $1.
        RE1_First_Click  : $1.
        RE1_Last_Click   : $1.
        RE1_Page_Submit  : $1.
        RE1_Click_Count  : $1.
        RE5_Browser      : $1.
        RE5_Version      : $1.
        RE5_Operating_System : $1.
        RE5_Resolution   : $1.
        AUD_pts_screen   : $CHAR1.
        screentools_1    : $CHAR1.
        screentools_2    : $CHAR1.
        screentools_3    : $CHAR1.
        screentools__66  : $CHAR1.
        screentools__66_TEXT : $CHAR64.
        patient_type_1   : $CHAR1.
        patient_type_2   : $CHAR1.
        patient_type_3   : $CHAR1.
        patient_type_4   : $CHAR1.
        patient_type_5   : $CHAR1.
        patient_type_6   : $CHAR1.
        patient_type__66 : $CHAR1.
        patient_type_2_TEXT : $CHAR50.
        patient_type_3_TEXT : $CHAR71.
        patient_type__66_TEXT : $CHAR136.
        Frequency        : $CHAR1.
        workflow_person_1 : $CHAR1.
        workflow_person_2 : $CHAR1.
        workflow_person_3 : $CHAR1.
        workflow_person_4 : $CHAR1.
        workflow_person_5 : $CHAR1.
        workflow_person_6 : $CHAR1.
        workflow_person_7 : $CHAR1.
        workflow_person_8 : $CHAR1.
        workflow_person__66 : $CHAR1.
        workflow_person__66_TEXT : $CHAR12.
        tools_1          : $CHAR1.
        tools_2          : $CHAR1.
        tools_3          : $CHAR1.
        tools_4          : $CHAR1.
        tools_5          : $CHAR1.
        tools__66        : $CHAR1.
        tools__66_TEXT   : $CHAR48.
        review_rslts     : $CHAR1.
        interpret_1      : $CHAR1.
        interpret_2      : $CHAR1.
        interpret_3      : $CHAR1.
        interpret_4      : $CHAR1.
        interpret_5      : $CHAR1.
        interpret__66    : $CHAR1.
        interpret__66_TEXT : $CHAR71.
        positive_AUD     : $CHAR1.
        further_assess_1 : $CHAR1.
        further_assess_2 : $CHAR1.
        further_assess_3 : $CHAR1.
        further_assess__66 : $CHAR1.
        further_assess__66_TEXT : $CHAR138.
        feedback         : $CHAR1.
        care_AUD         : $CHAR1.
        support_1        : $CHAR1.
        support_2        : $CHAR1.
        support_3        : $CHAR1.
        support_4        : $CHAR1.
        support_5        : $CHAR1.
        support_6        : $CHAR1.
        support_7        : $CHAR1.
        support_8        : $CHAR1.
        support__66      : $CHAR1.
        support__66_TEXT : $CHAR166.
        Q22_First_Click  : $1.
        Q22_Last_Click   : $1.
        Q22_Page_Submit  : $1.
        Q22_Click_Count  : $1.
        RE3_First_Click  : $1.
        RE3_Last_Click   : $1.
        RE3_Page_Submit  : $1.
        RE3_Click_Count  : $1.
        practice_site    : $CHAR51.
        sim_id           : $CHAR4.
        cohort           : $CHAR24.
        practice_type    : $CHAR85.
        practice_organization : $CHAR32.
        practice_facilitator_pto : $CHAR49.
        clinical_hit_advisor_pto : $CHAR1.
        split_user_email_address : $CHAR32.
        entity_name      : $CHAR1.
        assigned_entity_id : $CHAR32.
        task_id          : $CHAR3.
        survey_id        : $CHAR2.
        entity_task_id   : $CHAR5.
        task_assessment_period : $CHAR7.
        pdf_export       : $1.
        KEEP_OR_DELETE   : $CHAR6. ;
RUN;
