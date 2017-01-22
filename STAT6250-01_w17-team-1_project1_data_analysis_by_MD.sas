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


*
Research Question: Which plane models have the least number of fatalities 
when in an Accident.
Rationale: This would help identify the safest type of plane to ride in for 
survivability purposes.
Methodology: Get Total_Fatal_Injuries per model and Model and get models
have have the lowest Total_Fatal_Injuries
;
proc summary data=AviationAccidentDatabase;
    Class Model;
    var Total_Fatal_Injuries;
run;

*
Research Question: In what phase of the flight do accidents typically happen?
Rationale: This would help bring attention to the most critical points in a
flight to focus on.
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Enrollment_K12 and Percent_Eligible_FRPM_K12
based upon their spread, and use proc freq to cross-tabulate bins
Notes: A possible follow-up to this approach could use an inferential
statistical technique like beta regression
;
proc summary data=AviationAccidentDatabase;
    var Broad_Phase_of_Flight
    ;
run;

*
Research Question: What are the top 5 worst airports in regards to accidents?
Rationale:  This would bring awareness to airports that can be dangerous in 
regards to accidents.
Methodolody: Computer the top 5 airports by Airport_Name that have accidents
;
proc summary data=AviationAccidentDatabase;
    var Airport_Name;
run;