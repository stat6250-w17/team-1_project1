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
Research Question:What proportion of accidents from amateur built aircraft
resulted in a fatality and how does it compare to non amateur built aircraft?

Rationale: This will help identify if amateur built aircraft need additional
safe guards or regulations in order to operate in order to reduce fatalities 
in an amateur built aircraft. 

Methodology: First perform a PROC FREQ on TABLE = Injury_Severity where 
Amateur_Built = "Yes". Then run PROC FREQ on the same table where 
Amateur_Built = "No". Arrange both frequencies by descending order and compare 
the percentage of fatalities between aircraft that were amateur built versus 
those that were not in order to identify if there is a higher proportion of 
fatalities in amateur built aircraft accidents.

Note: A possible follow up would be to categorize the results into two
categories only (fatal and non-fatal). This method would make reading the
results easier.
;
proc freq data=AviationAccidentDatabase order=freq;
    tables Injury_Severity;
    where Amateur_Built = "Yes";
run;

proc freq data=AviationAccidentDatabase order=freq;
    tables Injury_Severity;
    where Amateur_Built = "No";
run;
*
Research Question: What is the porportion of fatal and non-fatal injury 
severity depending on aircraft damage?

Rationale: To better understand the likelihood of survival or injury based on 
the amount of damage that is inflicted on the aircraft.

Methodology: Create a two-way table by joining Injury_Severity and 
Aircraft_Damage. Arrange the results by frequency in descending order.

Notes: A possible follow up would be to alter the format of Injury_Severity
and Amateur_Built to numeric and conduct a PROC CORR analysis. This approach
would give us a numeric correlation value to quantitatively assess how these
two variables are related. 
;
proc freq data=AviationAccidentDatabase order=freq;
    tables Injury_Severity*Aircraft_Damage / norow nocol;
run;

*
Research Question: What is the frequency distribution of purpose of flight 
that resulted in an accident/incident?

Rationale: To identify which reasons for flight is resulting in the most 
accidents in order to further investigate possible causes.

Methodology: Use PROC FREQ to count the frequency of each purpose of flight.
Next order the output in results by frequency to easily identify the 
frequency of accidents by puropose of flight.
;
proc freq data=AviationAccidentDatabase order=freq;
    tables Purpose_of_Flight;
run;