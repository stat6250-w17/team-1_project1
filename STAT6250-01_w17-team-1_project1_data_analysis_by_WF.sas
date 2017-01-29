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



*
Research Question:What are the makes and models of aircraft that have the high 
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
proc print noobs data=make_model_highrate_temp(obs=20);
	var Make Model Count PERCENT;
run;
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
run;
*
Research Question: Do multi-engine aircrafts have less fatalities than single 
engine aircrafts when in accident?

Rationale: want to know whether multi-engine aircrafts are somewhat safer than 
single engine aircrafts in general when involved in accident or incident.

Methodology: Sum all total_fatal_injuries and the total observations count for all aircraft with number_of_engines equal to 1, and
			Sum all total_fatal_injuries and the total observations count for all aircraft with number_of_engines more than 1,
			calculate the precentage of fatal injuries between those two types of aircraft
proc freq noprint data=AviationAccidentDatabase order=freq;
proc freq data=AviationAccidentDatabase order=freq;
     tables Number_Of_Engines /out=Engine_rate_temp;
     Where Number_Of_Engines > 0 AND Injury_Severity <>'Non-Fatal';
     
run;

