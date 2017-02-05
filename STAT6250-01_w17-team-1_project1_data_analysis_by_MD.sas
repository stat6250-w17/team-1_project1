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
%setup;


*
Methodology: Divide Total_Fatal_Injuries by a sum of
Total_Fatal_Injuries, Total_Minor_Injuries, Total_Serious_Injuries,
Total_Uninjured, and get the fatality percentage for each plane Model.
;

title1 "Research Question: Which plane models have the least number of 
fatalities when in an Accident.";

title2 "Rationale: This would help identify the safest type of plane to ride 
in for survivability purposes.";

footnote1 "It turns out there are a lot of planes Models which did not 
have any falal injuries noted when other types were injuries were noted. 
At least 5866 planes. ";

footnote2 "Notes: A possible follow-up to this approach could use an 
inferential statistical technique like beta regression";

proc sort data=AviationAccidentDatabase out=work.AviationInfo;
    by Model;
run;

proc sql;
    create table Aviation_Processing as
    select Model,
    COALESCE(sum(Total_Fatal_Injuries),0) as tfi,
    COALESCE(sum(Total_Minor_Injuries),0) as tmi,
    COALESCE(sum(Total_Serious_Injuries),0) as tsi,
    COALESCE(sum(Total_Uninjured),0) as tui
    from work.AviationInfo
    where Model is not missing
    group by Model;
run;

proc sql;
    create table Aviation_Processing_2 as (
    select Model,
    tfi/(tmi + tsi + tui + tfi)*100 as fatality_percentage
    from work.Aviation_Processing
    where (tmi + tsi + tui + tfi) > 0
    )
    order by fatality_percentage asc;
run;

proc print data=work.Aviation_Processing_2;
run;


title;
footnote;

*
Methodology: PROC FREQ Broad_Phase_of_Flight to find out the percentage
of incidents per phase of flight.
;

title1 "Research Question: In what phase of the flight do accidents typically 
happen?";

title2 "Rationale: This would help bring attention to the most critical points 
in a flight to focus on.";

footnote1 "Based on the data above, 26.23% of accidents happened during 
landing.";

footnote2 "Notes: A possible follow-up to this approach could use an 
inferential statistical technique like beta regression";

proc freq data=AviationAccidentDatabase order=freq;
    tables Broad_Phase_of_Flight;
run;
title;
footnote;

*
Methodolody: Compute the top 5 airports by Airport_Name that have accidents.
;

title1 "Research Question: What are the top 5 worst airports in regards to 
accidents?";

title2 "Rationale:  This would bring awareness to airports that can be dangerous 
in regards to accidents.";

footnote1 "Based on the data above, the top 5 airports for accidents are 
MERRILL FIELD, CENTENNIAL, VAN NUYS, FALCON FIELD, NORTH LAS VEGAS";

proc freq data=AviationAccidentDatabase order=freq;
    tables Airport_Name
    / noprint
    out = All_Airports;
proc PRINT data = All_Airports(obs = 5)
    NOOBS;
    where Airport_Name ne 'PRIVATE'
    AND Airport_Name ne 'PRIVATE AIRSTRIP'
    AND Airport_Name ne 'PRIVATE STRIP'
    AND Airport_Name ne 'N/A'
    AND Airport_Name ne ' '
    AND Airport_Name ne 'MUNICIPAL'
    AND Airport_Name ne 'UNKNOWN'
    AND Airport_Name ne 'NONE';
run;
title;
footnote;