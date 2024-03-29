*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.
Dataset Name: NTSB Aviation Accident Database
Experimental Units: Aviation Accident Event
Number of Observations: 79,239
Number of Features: 31
Data Source: The file http://app.ntsb.gov/aviationquery/Download.ashx?type=csv
was the original source, files was converted to excel as the delimiters were |
and then converted back into a csv as there was some spacing that was taken care of
with name AviationAccidentDatabase.csv
Data Dictionary: 
https://www.ntsb.gov/_layouts/ntsb.aviation/AviationDownloadDataDictionary.aspx
Unique ID: The column "EventId" is a primary key
;

* setup environmental parameters;
%let inputDatasetURL =
http://filebin.ca/39iVxmQmkSeY/AviationAccidentDatabase.csv
;

proc format;
	value $Fatality_bins
		"NON-FATAL"
		="NON-FATAL"
		other
		="FATAL"
	;

* load NTSB Aviation Accident Database;
filename Avi_Temp TEMP;
proc http
    method="get" 
    url="&inputDatasetURL." 
    out=Avi_Temp
    ;
run;
proc import
    FILE=Avi_Temp
    OUT=Avi_Data
    DBMS=CSV
    ;
run;

filename Avi_Temp clear;

proc sort 
	    nodupkey 
	    data=Avi_Data
	    out=_null_
  	;
	by 
		Event_Id
	;
run;

data Avi_Data1;                                                                                                                                 
  set Avi_Data;                                                                                                                                
/* this array groups all the character variables together into one array*/                                                              
  array vars(*) _character_;                                                                                                            
  do i=1 to dim(vars);                                                                                                                  
/*use the UPCASE function to uppercase each value*/                                                                                     
    vars(i)=upcase(vars(i));                                                                                                            
  end;                                                                                                                                  
  drop i;                                                                                                                               
run; 

* Build analytic dataset AviationAccidentDatabase based on Avi_Data file filtering
out items which would not be needed for analysis;
data AviationAccidentDatabase;
    retain
        Air_Carrier
        Aircraft_Category
        Aircraft_Damage
        Airport_Code
		Airport_Name
		Amateur_Built
		Broad_Phase_of_Flight
		Country
		Engine_Type
		Event_Date
		Injury_Severity
		Latitude
		Location
		Longitude
		Make
		Model
		Number_of_Engines
		Purpose_of_Flight
		Total_Fatal_Injuries
		Total_Minor_Injuries
		Total_Serious_Injuries
		Total_Uninjured
		Weather_Condition
    ;
    keep
        Air_Carrier
        Aircraft_Category
        Aircraft_Damage
        Airport_Code
		Airport_Name
		Amateur_Built
		Broad_Phase_of_Flight
		Country
		Engine_Type
		Event_Date
		Injury_Severity
		Latitude
		Location
		Longitude
		Make
		Model
		Number_of_Engines
		Purpose_of_Flight
		Total_Fatal_Injuries
		Total_Minor_Injuries
		Total_Serious_Injuries
		Total_Uninjured
		Weather_Condition
    ;
    set Avi_Data1;
run;