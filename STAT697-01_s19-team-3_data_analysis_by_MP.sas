*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that will generate final analytic file;
%include '.\STAT697-01_s19-team-3_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there evidence that countries with a greater % of "Inequality of 
Education" also suffer from greater poverty as measured by the "Multidimensional
Poverty Index"?

Rationale: This would indicate if there is an assocation between eduaction 
inequality and poverty, and if the former can be an indicator of poverty in a 
country.

Note: This compares the column "Inequality of Education" from 2018 Statistical 
Annex Table 3 to the column "Multidimensional Poverty Index" from 2018 
Statistical Annex Table 6.

Limitations: Values denoted as ".." for the column "Inequality of Education" 
should be excluded from analysis since they represent missing values.
;

proc sql;
	create table Education_Inequality_and_Poverty as
		select
			coalesce(A.Country,B.Country) as Country
			,Multidimensional_Poverty_Index
			,Inequality_in_education
		from
			Annex_Table_3_and_4_v2 as A
			full join
			Statistical_2018_Annex_Table_6 as B
			on A.Country=B.Country
		order by
			Country
	;
quit;

proc corr 
	data=Education_Inequality_and_Poverty;
	var Multidimensional_Poverty_Index Inequality_in_education;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there a strong association between "Mean years of schooling" and 
the "Multidimensional Poverty Index" by gender?

Rationale: This would show is their is an association between average years of 
schooling and poverty levels per country, and would also indicate if their is a
significant difference in the strength of assocation by gender.

Note: This compares the columns "Female" and "Male" under "Mean years of schooling" 
from 2018 Statistical Annex Table 4 each to the column "Multudimensional Poverty 
Index" from 2018 Statistical Annex Table 6.

Limitations: Values denoted as ".." for the columns "Mean years of schooling" 
for both "Female" and "Male" should be excluded from analysis since they represent
missing values.
;


proc sql;
   	select
	 min(Mean_years_of_schooling_female) as min
	,max(Mean_years_of_schooling_female) as max
	,mean(Mean_years_of_schooling_female) as mean
	,median(Mean_years_of_schooling_female) as median
    from
	Annex_Table_3_and_4_v2
   	;
quit;

proc sql;
   	select
	 min(Mean_years_of_schooling_male) as min
	,max(Mean_years_of_schooling_male) as max
	,mean(Mean_years_of_schooling_male) as mean
	,median(Mean_years_of_schooling_male) as median
    from
	Annex_Table_3_and_4_v2
   	;
quit;





*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Can % of "Population living below the income poverty line" for 2006-2017 
be used to predict the country's "HDI"?

Rationale: This can help to see how poverty levels are associated with a country's 
Human Development Index value, which assesses a country's development.

Note: This compares the column "Population_living_below_national_poverty_line" 
from 2018 Statistical Annex Table 6 to the column "HDI" from 2018 Statistical 
Annex Table 3.

Limitations: Missing values for the column "Population living below 
national poverty line" should be excluded from analysis as there are 10 missing
values indicated.
;

proc sql;
	create table Poverty_and_HDI as
		select
			coalesce(A.Country,B.Country) as Country
			,HDI
			,Population_living_below_national
		from
			Annex_Table_3_and_4_v2 as A
			full join
			Statistical_2018_Annex_Table_6 as B
			on A.Country=B.Country
		order by
			Country
	;
quit;

proc corr 
	data=Poverty_and_HDI;
	var HDI Population_living_below_national;
run;
