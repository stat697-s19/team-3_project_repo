*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
[Dataset 1 Name] 2018 Statistical Annex Table 6

[Dataset Description] Multidimensional Poverty Index: developing countries

[Experimental Unit Description] Countries from around the world

[Number of Observations] 1,365                    

[Number of Features] 13

[Data Source] http://hdr.undp.org/sites/default/files/composite_tables/2018_Statistical_Annex_Table_6.xlsx

[Data Dictionary] http://hdr.undp.org/en//2018-MPI

[Unique ID Schema] The column "Country" is the unique primary key.
;
%let inputDataset3DSN = Statistical_2018_Annex_Table_6;
%let inputDataset3URL =
https://github.com/stat697/team-3_project_repo/blob/master/data/2018_Statistical_Annex_Table_6.xlsx?raw=true
;
%let inputDataset3Type = XLSX;


*
[Dataset 2 Name] 2018 Statistical Annex Table 4

[Dataset Description] Gender Development Index

[Experimental Unit Description] Countries from around the world

[Number of Observations] 2,268                    

[Number of Features] 12

[Data Source] http://hdr.undp.org/sites/default/files/composite_tables/2018_Statistical_Annex_Table_4.xlsx

[Data Dictionary] http://hdr.undp.org/en/content/gender-development-index-gdi

[Unique ID Schema] The columns "HDI rank" and "Country" form a composite key, 
which together are equivalent to the composite key in dataset 2018 Statistical 
Annex Table 3.
;
%let inputDataset2DSN = Statistical_2018_Annex_Table_4;
%let inputDataset2URL =
https://github.com/stat697/team-3_project_repo/blob/master/data/2018_Statistical_Annex_Table_4.xlsx?raw=true
;
%let inputDataset2Type = XLSX;


*
[Dataset 3 Name] 2018 Statistical Annex Table 3

[Dataset Description] Inequality-adjusted Human Development Index

[Experimental Unit Description] Countries from around the world

[Number of Observations] 2,646                    

[Number of Features] 14

[Data Source] http://hdr.undp.org/sites/default/files/composite_tables/2018_Statistical_Annex_Table_3.xlsx

[Data Dictionary] http://hdr.undp.org/content/inequality-adjusted-human-development-index-ihdi

[Unique ID Schema] The columns "HDI rank" and "Country" form a composite key, 
which together are equivalent to the composite key in dataset 2018 Statistical 
Annex Table 4.
;
%let inputDataset1DSN = Statistical_2018_Annex_Table_3;
%let inputDataset1URL =
https://github.com/stat697/team-3_project_repo/blob/master/data/2018_Statistical_Annex_Table_3.xlsx?raw=true
;
%let inputDataset1Type = XLSX;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 3;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets


*There is no duplicate/missing primary ID value in the table Statistical_2018_Annex_Table_3. Therefore, 
there is no need to implement a mitigation strategy for this dataset;
    
proc sql;
    create table Annex_Table_3_dups as
        select
            Country
            ,count(*) as row_count_for_unique_id_value
        from
            Statistical_2018_Annex_Table_3
        group by
            Country            
        having
            row_count_for_unique_id_value > 1
    ;
quit;

*There is no duplicate/missing primary ID value in the table Statistical_2018_Annex_Table_4. Therefore, 
there is no need to implement a mitigation strategy for this dataset;

proc sql;
    create table Annex_Table_4_dups as
        select
            Country
            ,count(*) as row_count_for_unique_id_value
        from
            Statistical_2018_Annex_Table_4
        group by
            Country               
        having
            row_count_for_unique_id_value > 1
    ;
quit;

* There are 15 blank rows on the bottom of the Statistical_2018_Annex_Table_6 dataset, 
mitigation strategy is developed and implemented per the code below;

proc sql;
    create table Annex_Table_6_dups as
        select
            Country
            ,count(*) as row_count_for_unique_id_value
        from
            Statistical_2018_Annex_Table_6
        group by
	    Country            
        having
            row_count_for_unique_id_value > 1
    ;


create table Annex_Table_6_dups_fix as
        select
            *
        from
            Statistical_2018_Annex_Table_6
        where
            /* remove rows with missing unique id value components */
            not(missing(Country))      
    ;
quit;


* build analytic dataset from raw datasets imported above, including only the
columns and minimal data-cleaning/transformation needed to address each
research questions/objectives in data-analysis files;

proc sql;
    create table country_analytic_file_raw as
        select 
             coalesce(A.Country, B.Country, C.Country)
             AS Country
            ,A.adjusted_life_index
            ,A.Inequality_in_education
            ,A.HDI
            ,A.Inequality_in_life_expectancy
            ,B.Mean_years_of_schooling_female
            ,B.Mean_years_of_schooling_male
            ,B.Year_School_Female
            ,B.HDI_female
            ,B.HDI_male
            ,B.Estimated_gross_national_income_
            ,B.Life_expectancy_at_birth_female
            ,B.Life_expectancy_at_birth_male
            ,C.Population_in_severe_multidimens
            ,C.Percent_education_contribution_o
            ,C.Multidimensional_Poverty_Index
            ,C.Population_living_below_national
        from
            (
                select
                     cats(Country)
                     AS Country
                    ,adjusted_life_index
                     AS adjusted_life_index
                    ,Inequality_in_education
                     AS Inequality_in_education
                    ,HDI
                     AS HDI
                    ,Inequality_in_life_expectancy
                     AS Inequality_in_life_expectancy
                from 
                    Statistical_2018_Annex_Table_3
            ) as A
            full join
            (
                select
                     cats(Country)
                     AS Country
                    ,Mean_years_of_schooling_female
                     AS Mean_years_of_schooling_female
                    ,Mean_years_of_schooling_male
                     AS Mean_years_of_schooling_male
                    ,Year_School_Female
                     AS Year_School_Female
                    ,HDI_female
                     AS HDI_female
                    ,HDI_male
                     AS HDI_male
                    ,Estimated_gross_national_income_
                     AS Estimated_gross_national_income_
                    ,Life_expectancy_at_birth_female
                     AS Life_expectancy_at_birth_female
                    ,Life_expectancy_at_birth_male
                     AS Life_expectancy_at_birth_male
                from
                    Statistical_2018_Annex_Table_4
            ) as B
            on A.Country = B.Country
            full join
            (
                select
                     cats(Country)
                     AS Country
                    ,Population_in_severe_multidimens
                     AS Population_in_severe_multidimens
                    ,Percent_education_contribution_o
                     AS Percent_education_contribution_o
                    ,Multidimensional_Poverty_Index
                     AS Multidimensional_Poverty_Index
                    ,Population_living_below_national
                     AS Population_living_below_national
                from
                    Annex_Table_6_dups_fix
            ) as C
            on A.Country = C.Country
    order by
        Country
    ;
quit;

* check country_analytic_file_raw for rows whose unique id values are repeated or
missing and after executing this data step, results show no repeated or missing 
primary id values;

data country_raw_bad_ids;
    set country_analytic_file_raw;
    by Country;

    if
        first.Country*last.Country = 0
        or
        missing(Country)
    then
        do;
            output;
        end;
run;
