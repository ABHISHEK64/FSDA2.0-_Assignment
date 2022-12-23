# Snowflakes//https://sgyspws-he80912.snowflakecomputing.com/console#/internal/worksheet

create database uk_report;
use database uk_report;

CREATE OR Replace TABLE Accidents_2015 (
	Accident_Index VARCHAR(13) NOT NULL, 
	Location_Easting_OSGR DECIMAL(38, 0), 
	Location_Northing_OSGR DECIMAL(38, 0), 
	Longitude DECIMAL(38, 6), 
	Latitude DECIMAL(38, 6), 
	Police_Force DECIMAL(38, 0) NOT NULL, 
	Accident_Severity DECIMAL(38, 0) NOT NULL, 
	Number_of_Vehicles DECIMAL(38, 0) NOT NULL, 
	Number_of_Casualties DECIMAL(38, 0) NOT NULL, 
	Date VARCHAR(10), 
	Day_of_Week DECIMAL(38, 0) NOT NULL, 
	Time Varchar(10), 
	Local_Authority_District DECIMAL(38, 0) NOT NULL, 
	Local_Authority_Highway VARCHAR(9) NOT NULL, 
	F1st_Road_Class DECIMAL(38, 0) NOT NULL, 
	F1st_Road_Number DECIMAL(38, 0) NOT NULL, 
	Road_Type DECIMAL(38, 0) NOT NULL, 
	Speed_limit DECIMAL(38, 0) NOT NULL, 
	Junction_Detail DECIMAL(38, 0) NOT NULL, 
	Junction_Control DECIMAL(38, 0) NOT NULL, 
	S2nd_Road_Class DECIMAL(38, 0) NOT NULL, 
	S2nd_Road_Number DECIMAL(38, 0) NOT NULL, 
	Pedestrian_Crossing_Human_Control DECIMAL(38, 0) NOT NULL, 
	Pedestrian_Crossing_Physical_Facilities DECIMAL(38, 0) NOT NULL, 
	Light_Conditions DECIMAL(38, 0) NOT NULL, 
	Weather_Conditions DECIMAL(38, 0) NOT NULL, 
	Road_Surface_Conditions DECIMAL(38, 0) NOT NULL, 
	Special_Conditions_at_Site DECIMAL(38, 0) NOT NULL, 
	Carriageway_Hazards DECIMAL(38, 0) NOT NULL, 
	Urban_or_Rural_Area DECIMAL(38, 0) NOT NULL, 
	Did_Police_Officer_Attend_Scene_of_Accident DECIMAL(38, 0) NOT NULL, 
	LSOA_of_Accident_Location VARCHAR(9)
);
CREATE TABLE `Vehicles_2015` (
	Accident_Index VARCHAR(13) NOT NULL, 
	Vehicle_Reference DECIMAL(38, 0) NOT NULL, 
	Vehicle_Type DECIMAL(38, 0) NOT NULL, 
	Towing_and_Articulation DECIMAL(38, 0) NOT NULL, 
	Vehicle_Manoeuvre DECIMAL(38, 0) NOT NULL, 
	Vehicle_Location_Restricted_Lane DECIMAL(38, 0) NOT NULL, 
	Junction_Location DECIMAL(38, 0) NOT NULL, 
	Skidding_and_Overturning DECIMAL(38, 0) NOT NULL, 
	Hit_Object_in_Carriageway DECIMAL(38, 0) NOT NULL, 
	Vehicle_Leaving_Carriageway DECIMAL(38, 0) NOT NULL, 
	Hit_Object_off_Carriageway DECIMAL(38, 0) NOT NULL, 
	F1st_Point_of_Impact DECIMAL(38, 0) NOT NULL, 
	Was_Vehicle_Left_Hand_Drive DECIMAL(38, 0) NOT NULL, 
	Journey_Purpose_of_Driver DECIMAL(38, 0) NOT NULL, 
	Sex_of_Driver DECIMAL(38, 0) NOT NULL, 
	Age_of_Driver DECIMAL(38, 0) NOT NULL, 
	Age_Band_of_Driver DECIMAL(38, 0) NOT NULL, 
	Engine_Capacity_CC DECIMAL(38, 0) NOT NULL, 
	Propulsion_Code DECIMAL(38, 0) NOT NULL, 
	Age_of_Vehicle DECIMAL(38, 0) NOT NULL, 
	Driver_IMD_Decile DECIMAL(38, 0) NOT NULL, 
	Driver_Home_Area_Type DECIMAL(38, 0) NOT NULL, 
	Vehicle_IMD_Decile DECIMAL(38, 0) NOT NULL
);
CREATE TABLE vehicle_types (
	Vechcode DECIMAL(38, 0) NOT NULL, 
	label VARCHAR(37) NOT NULL
);
select * from vehicle_types;
//Avg Severity By Motor Cycle
select Avg(Accident_Severity) as Avg_Severity,label from(
select A1.Accident_Severity,V1.Vehicle_Type,Vt.label from Accidents_2015 as A1  join `Vehicles_2015` as V1 on V1.Accident_Index=A1.Accident_Index
 join vehicle_types as Vt on Vt.Vechcode=V1.Vehicle_Type)as b where lower(label) like 'motor%' or lower(label) like '%motor' group by label ;
//Avg Severity  and Total Accident and vechile type
select sum(V1.Skidding_and_Overturning+V1.Hit_Object_in_Carriageway+V1.Vehicle_Leaving_Carriageway+V1.Hit_Object_off_Carriageway+V1.F1st_Point_of_Impact) as total_Accident,Avg(A1.Accident_Severity) as Avg_Severity,Vt.label from
Accidents_2015 as A1  join `Vehicles_2015` as V1 on V1.Accident_Index=A1.Accident_Index  join vehicle_types as Vt on Vt.Vechcode=V1.Vehicle_Type
group by Vt.label;
// Avg Severity and Total Accident by Motor Cycle
select sum(V1.Skidding_and_Overturning+V1.Hit_Object_in_Carriageway+V1.Vehicle_Leaving_Carriageway+V1.Hit_Object_off_Carriageway+V1.F1st_Point_of_Impact) as total_Accident,Avg(A1.Accident_Severity) as Avg_Severity,Vt.label as label from
Accidents_2015 as A1 inner join `Vehicles_2015` as V1 on V1.Accident_Index=A1.Accident_Index inner join vehicle_types as Vt on Vt.Vechcode=V1.Vehicle_Type
 where lower(label) like 'motor%' or lower(label) like '%motor' group by label;
// Median Severity
select a1.label,percentile_cont(0) within group(order by a1.Total_Severity) over() as Median_Severity from(
select Sum(Accident_Severity)  as Total_Severity,label from(
select A1.Accident_Severity,Vt.label from Accidents_2015 as A1 inner join `Vehicles_2015` as V1 on V1.Accident_Index=A1.Accident_Index
inner join vehicle_types as Vt on Vt.Vechcode=V1.Vehicle_Type)as b where lower(label) like 'motor%' or lower(label) like '%motor' group by label 
)a1;