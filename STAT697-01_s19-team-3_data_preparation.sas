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
***
