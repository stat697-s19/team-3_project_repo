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
Question: Is there evidence to indicate countries with a greater % of 
"Inequality in Life Expectancy" also experience greater poverty as measured by 
the "Multidimensional Poverty Index"?

Rationale: This test would indicate an association between life expectancy and 
poverty and if poverty can be an indicator of life expectancy. 

Note: This compares the column "Inequality of Life Expectancy" from 2018 
Statistical Annex Table 3 to the column "Multidimensional Poverty Index" from 
2018 Statistical Annex Table 6.

Limitations: Values denoted as ".." for the column "Inequality of Life 
Expectancy" should be excluded from analysis since it represents missing values.
;


proc sql;
	create table Life_Expectancy_Inequality_and_Poverty as
		select
			coalesce(A.Country,B.Country) as Country
			,Multidimensional_Poverty_Index
			,Inequality_in_life_expectancy
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
	data=Life_Expectancy_Inequality_and_Poverty;
	var Multidimensional_Poverty_Index Inequality_in_life_expectancy;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there a strong association between "Life Expectancy at Birth" and
the "Multidimensional Poverty Index" by gender?

Rationale: This would show if there is an association between poverty levels 
within a country and life expectancy between genders.

Note: This compares the column "Life expectancy at birth" from 2018 Statistical 
Annex Table 4 to the column "Multudimensional Poverty Index" from 2018 
Statistical Annex Table 6.

Limitations: missing values need to be addressed for glm and general data analysis
;


proc sql;
   	select
	 min(Life_expectancy_at_birth_female) as min
	,max(Life_expectancy_at_birth_female) as max
	,mean(Life_expectancy_at_birth_female) as mean
	,median(Life_expectancy_at_birth_female) as median
    from
	Annex_Table_3_and_4_v2
   	;
quit;

proc sql;
   	select
	 min(Life_expectancy_at_birth_male) as min
	,max(Life_expectancy_at_birth_male) as max
	,mean(Life_expectancy_at_birth_male) as mean
	,median(Life_expectancy_at_birth_male) as median
    from
	Annex_Table_3_and_4_v2
   	;
quit;
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Can % of "Population living below the income poverty line" for 
2006-2017 be used to predict the country's "Coefficient of human inequality"?

Rationale: This can help to see how poverty levels are associated with a 
country's inequality. 

Note: This compares the column "Population_living_below_national_poverty_line" 
from 2018 Statistical Annex Table 6 to the column "Coefficient of human 
inequality" from 2018 Statistical Annex Table 3.

Limitations: missing values need to be addressed for glm and general data analysis
;

proc sql;
	create table Poverty_and_Inequality as
		select
			coalesce(A.Country,B.Country) as Country
			,Coefficient_of_human_inequality
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
	data=Poverty_and_Inequality;
	var Coefficient_of_human_inequality Population_living_below_national;
run;
