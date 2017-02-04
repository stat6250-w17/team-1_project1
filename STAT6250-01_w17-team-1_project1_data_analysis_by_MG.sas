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
Methodology: Create a PROC FREQ on TABLE = Injury_Severity and Amateur_Built. 
Compare the column percentages of non-amateur to amateur aircraft that resulted 
in non-fatal accidents.
;
	
title1 "Research Question:What proportion of accidents from amateur built 
aircraft resulted in a fatality and how does it compare to non amateur 
built aircraft?";

title2 "Rationale: This will help identify if amateur built aircraft need 
additional safe guards or regulations in an attempt to reduce fatalities.";

footnote1 "Accidents in non-amateur built planes resulted in less fatalities 
(77%) versus amateur built planes (71%).";

footnote2 "Note: A possible follow up would be to perform a two sample t-test 
to determine if the difference is meaningful.";

proc freq data=AviationAccidentDatabase order=freq;
	tables Injury_Severity*Amateur_Built;
	format Injury_Severity $Fatality_bins.;
run;
title;
footnote;


*
Methodology: Create a two-way table by joining Injury_Severity and 
Aircraft_Damage. Arrange the results by frequency in descending order.
;

title1 "Research Question: What is the porportion of fatal and non-fatal 
injury severity depending on aircraft damage?";

title2 "Rationale: To better understand the likelihood of survival or injury 
based on the amount of damage that is inflicted on the aircraft.";

footnote1 "Based on the output above, 17,322 passengers were involved in an
aviation accident where the aircraft was destroyed.";

footnote2 "Of the 17,732 people involved in an accident where the aircraft 
was categorizd as destroyed, only 5,674 (33%) passengers survived the 
accident.";

footnote3 "Notes: A possible follow up would be to alter the format of 
Injury_Severity and Amateur_Built to numeric and conduct a PROC CORR 
analysis. This approach would give us a numeric correlation value to 
quantitatively assess how these two variables are related.";

proc freq data=AviationAccidentDatabase order=freq;
    tables Injury_Severity*Aircraft_Damage 
    / norow nocol;
    format Injury_Severity $Fatality_bins.;
run;
title;
footnote;


*
Methodology: Use PROC FREQ to count the frequency of each purpose of flight.
Next order the output in results by frequency to easily identify the 
frequency of accidents by puropose of flight.
;

title1 "Research Question: What is the frequency distribution of purpose of 
flight that resulted in an accident/incident?";

title2 "Rationale: To identify which reasons for flight is resulting in the 
most accidents in order to further investigate possible causes.";

footnote1 "Based on the data above, 59% of aviation accidents flight purpose 
was personal.";

proc freq data=AviationAccidentDatabase order=freq;
    tables Purpose_of_Flight;
run;
title;
footnote;