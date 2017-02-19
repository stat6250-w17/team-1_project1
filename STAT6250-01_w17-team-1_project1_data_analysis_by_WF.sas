*******************************************************************************;
**************** 80-character banner for column width reference ***************;
*******************************************************************************;
*
This file uses the following analytic dataset to identify various factors that
are associated with aviation accidents in the United States from 1962 to 2017.

Dataset Name: AviationAccidentDatabase created in an external file
STAT6250-01_w17-team-1_project1_data_preparation.sas, which is assumed to be 
in the same directory as this file

See included file for dataset properties
;


* environmental setup;
%let dataPrepFileName = STAT6250-01_w17-team-1_project1_data_preparation.sas;
%let sasUEFilePrefix = team-1_project1;

* load external file that generates analytic dataset AviationAccidentDatabase
using a system path dependent on the host operating system, after setting the
relative file import path to the current directory, if using Windows;
%macro setup;
%if
    &SYSSCP. = WIN
%then
    %do;
        X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";           
        %include ".\&dataPrepFileName.";
    %end;
%else
    %do;
        %include "~/&sasUEFilePrefix./&dataPrepFileName.";
    %end;
%mend;
%setup
;

title1
"Research Question: What are the makes and models of aircraft that have the high accident or incident rate?"
;
title2
"Rationale: want to know what make and model has bad safety record in general."
;
*IL: don't wrap string literals;
*IL: consider adding explanation to contextualize results and give a "why?";
footnote1
"Based on the above output, Cessna 150/172 and Piper 18/28 are occupying the top 10 spots, which have higher accident rate and are accumulating 11.9% of the total."
;

*IL: wrap code and comment blocks at 80 characters;
*IL: be careful with formatting in comment blocks;
*
Research Question: What are the makes and models of aircraft that have the high 
accident or incident rate? 

Rationale: want to know what make and model has bad safety record in general.

Methodology: Use PROC FREQ to count the frequency of all aircraft by make and model.
             Next order the output in results by frequency from top to bottom. 
;
proc freq noprint data=AviationAccidentDatabase order=freq;
     tables Make * Model /out=make_model_highrate_temp;
     
run;
proc sort data=make_model_highrate_temp;
    by descending Count;
run;
proc print noobs data=make_model_highrate_temp(obs=10);
    var Make Model Count PERCENT;
    sum PERCENT;
run;
title;
footnote;

title1
"Research Question: What are the locations where have more accident or incident?"
;
title2
"Rationale: want to know where the accident or incident happened more frquently."
;
footnote1
"The above output shows the top 20 locations where have more accidet or incident,
 and they are accumulating 4.9% of the total."
;

*
Research Question: What are the locations that have more accident or incident?

Rationale: want to know where the accident or incident happened more frequently.

Methodology: Use PROC FREQ to count the frequency of all location.
             Next order the output in results by frequency from top to bottom.
;
proc freq noprint data=AviationAccidentDatabase order=freq;
     tables Location * Country /out=location_highrate_temp;
     
run;
proc sort data=location_highrate_temp;
    by descending Count;
run;
proc print noobs data=location_highrate_temp(obs=20);
    var Location Country Count PERCENT;
    sum PERCENT;
run;
title;
footnote;




*
Research Question: Do multi-engine aircrafts have less fatalities than single 
engine aircrafts when in accident?

Rationale: want to know whether multi-engine aircrafts are somewhat safer than 
single engine aircrafts in general when involved in accident or incident.

Methodology: Sum all total_fatal_injuries and the total observations count for all aircraft with number_of_engines equal to 1, and
            Sum all total_fatal_injuries and the total observations count for all aircraft with number_of_engines more than 1,
            calculate the precentage of fatal injuries between those two types of aircraft
proc freq noprint data=AviationAccidentDatbase order=freq;

*IL: consider removing commented out code from a final code file;
*IL: consider combining the proc freq steps to create cross-tab;
*IL: be consistent with capitalization;
*IL: don't embed titles/footnotes in proc step since they're global, no matter
     where they are;
*IL: don't create output datasets unless you're planning to use;
proc freq data=AviationAccidentDatabase order=freq;
     tables Number_Of_Engines /out=Engine_rate_temp;
     Where Number_Of_Engines between 1 and 4;
     title1
"Research Question: Do multi-engine aircraft have less fatalities than single engine aircraft
 when in accident?"
;
    title2
"Rationale: want to know whether multi-engine aircrafts are somewhat safer than 
single engine aircrafts in general when involved in accident or incident"
;
     footnote
"The above output shows that the single engine aircrafts contributed 85.2% of total accidents."
;
run;
title;
footnote;

proc freq data=AviationAccidentDatabase order=freq;
     tables Number_Of_Engines /out=Engine_rate_temp1;
     Where Number_Of_Engines between 1 and 4 AND Injury_Severity like'FATAL(%';
     footnote1 "However, the above output shows that the single aircrafts only contributed 81.5% of the total fatal accidents, 
     which did not cause more fatalities.";
     footnote2 "Conclusion: the multi-engine aircrafts are not any safer when involved in accident.";
run;
title;
footnote
