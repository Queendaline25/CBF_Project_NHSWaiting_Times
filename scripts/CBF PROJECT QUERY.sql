SHOW DATABASEs;
/* 2026-01-28 12:10:59 [5 ms] */ 
USE CBF_PROJECT; -- The name of the database
/* 2026-01-28 12:11:01 [34 ms] */ 
Show tables;
/* 2026-01-28 12:11:35 [5 ms] */ 
SHOW GLOBAL VARIABLES LIKE 'local_infile';
/* 2026-01-30 02:42:03 [26 ms] */ 
show databases;
/* 2026-01-30 02:42:23 [5 ms] */ 
Use CBF_Project;
/* 2026-01-30 02:42:41 [16 ms] */ 
Select * From nhs_trust LIMIT 100;
/* 2026-01-30 02:55:10 [43 ms] */ 
LOAD DATA LOCAL INFILE "C:/Users/44774/Desktop/CBF PROJECT/NHS-TRUSTS-POSTCODES.csv" -- loading NHS Trust name with their postcode
INTO TABLE NHS_TRUST
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(TRUST_Name,Post_code);
/* 2026-01-30 02:56:34 [9 ms] */ 
SELECT * FROM nhs_trust LIMIT 100;
/* 2026-01-30 03:41:53 [251 ms] */ 
CREATE TABLE imd_2019 (lsoa_code VARCHAR(20)PRIMARY KEY, -- creating index of multiple deprivation csv from gov.uk
lsoa_name VARCHAR(50),
District_Code VARCHAR(50),
imd_rank INT,
imd_decile INT);
/* 2026-01-30 03:45:16 [1013 ms] */ 
LOAD DATA LOCAL INFILE "C:/Users/44774/Desktop/CBF PROJECT/IMD2019_Index_of_Multiple_Deprivation.csv" --loadong IMD dataset in from gov.uk
INTO TABLE imd_2019
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
/* 2026-01-30 08:47:07 [16 ms] */ 
SELECT * FROM imd_2019 LIMIT 100;
/* 2026-01-30 08:47:24 [52 ms] */ 
CREATE TABLE ONSPD (PCDS VARCHAR(10),
LSOA11 VARCHAR(20),
MSOA11 VARCHAR(20));
/* 2026-01-30 08:59:38 [34633 ms] */ 
LOAD DATA LOCAL INFILE "C:/Users/44774/Desktop/CBF Resources/ONSPD_FEB_2025/Data/ONSPD_FEB_2025_UK.csv" -- loading ONSPD dataset in from gov.uk
INTO TABLE ONSPD
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1,@col2,pcds,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,
@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,
@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,lsoa11,msoa11);
/* 2026-01-30 17:07:00 [5 ms] */ 
SELECT * FROM onspd LIMIT 100;
/* 2026-01-30 17:07:28 [1857 ms] */ 
SELECT  -- joining and mapping postcodes from NHS_trust table to the ONSPD dataset inorder to retrieve their LSOA numbers
t.`TRUST_Name`,
t.post_code,
o.lsoa11 AS lsoa_code,
i.imd_rank,
i.imd_decile
FROM nhs_trust AS t
LEFT JOIN onspd AS O
    ON REPLACE(UPPER(t.`Post_code`), '','') = REPLACE(o.pcds, '','')
LEFT JOIN imd_2019 AS i
    ON o.lsoa11 = i.lsoa_code ;

CREATE TABLE Admitted_Sep_RTT_Waiting_list (  --Creating the RTT admitted patient table
    Region_code VARCHAR(10)  NOT NULL,
    Provider_code VARCHAR(10) NOT NULL,
    Provider_name VARCHAR(255) NOT NULL,
    Treatment_function_code VARCHAR(10)  NOT NULL,
    Treatment_function_name VARCHAR(255) NOT NULL,
   

    Wait_0_18 INT NOT NULL,
    Wait_19_52 INT NOT NULL,
    wait_52_plus INT NOT NULL,

    Median_wait DECIMAL(5,2),
    percentile_95 DECIMAL(5,2),
    completed_pathways INT,
     Time_Period DATE NOT NULL,

    PRIMARY KEY  (provider_Code,treatment_function_code,Time_Period )

);


LOAD DATA LOCAL INFILE"C:/Users/44774/Desktop/CBF PROJECT/RTT waiting list for september 2025.csv" -- loading the first batch of RTT dataset for admitted 
INTO TABLE Admitted_Sep_RTT_Waiting_list
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Region_code,provider_code, provider_name,treatment_function_code,Treatment_function_name,wait_0_18,wait_19_52,wait_52_plus,
median_wait,percentile_95,completed_pathways,@Time_period)
SET Time_period = STR_TO_DATE(@Time_period, '%Y-%m-%d');


SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = TRUE;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
select * from admitted_sep_rtt_waiting_list ;
DESCRIBE admitted_sep_rtt_waiting_list; 

 UPDATE admitted_sep_rtt_waiting_list -- using update to correct the date issue
 SET `Time_Period` = '2025-09-01'
 WHERE `Time_Period` = 0;

 CREATE TABLE Admitted_OCT_RTT_Waiting_list (  -- creating table for the second batch of data for RTT admitted
    Region_code VARCHAR(10)  NOT NULL,
    Provider_code VARCHAR(10) NOT NULL,
    Provider_name VARCHAR(255) NOT NULL,
    Treatment_function_code VARCHAR(10)  NOT NULL,
    Treatment_function_name VARCHAR(255) NOT NULL,
   

    Wait_0_18 INT NOT NULL,
    Wait_19_52 INT NOT NULL,
    wait_52_plus INT NOT NULL,

    Median_wait DECIMAL(5,2),
    percentile_95 DECIMAL(5,2),
    completed_pathways INT,
     Time_Period DATE NOT NULL,

    PRIMARY KEY  (provider_Code,treatment_function_code,Time_Period )

);

LOAD DATA LOCAL INFILE"C:/Users/44774/Desktop/CBF PROJECT/Completed October Admitted 2025.csv" --- loading the csv in
INTO TABLE Admitted_OCT_RTT_Waiting_list
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Region_code,provider_code, provider_name,treatment_function_code,Treatment_function_name,wait_0_18,wait_19_52,wait_52_plus,
median_wait,percentile_95,completed_pathways,@Time_period)
SET Time_period = STR_TO_DATE(@Time_period, '%Y-%m-%d');


SELECT * FROM admitted_oct_rtt_waiting_list;

UPDATE admitted_oct_rtt_waiting_list ---updating column to remove null values
 SET `Time_Period` = '2025-10-01'
 WHERE `Time_Period` = 0;


 CREATE TABLE Admitted_NOV_RTT_Waiting_list ( -- Creating the 3rd table for admitted patients RTT
    Region_code VARCHAR(10)  NOT NULL,
    Provider_code VARCHAR(10) NOT NULL,
    Provider_name VARCHAR(255) NOT NULL,
    Treatment_function_code VARCHAR(10)  NOT NULL,
    Treatment_function_name VARCHAR(255) NOT NULL,
   

    Wait_0_18 INT NOT NULL,
    Wait_19_52 INT NOT NULL,
    wait_52_plus INT NOT NULL,

    Median_wait DECIMAL(5,2),
    percentile_95 DECIMAL(5,2),
    completed_pathways INT,
     Time_Period DATE NOT NULL,

    PRIMARY KEY  (provider_Code,treatment_function_code,Time_Period )

);

LOAD DATA LOCAL INFILE"C:/Users/44774/Desktop/CBF PROJECT/Completed November 2025 Admitted data.csv" --loading CSV in
INTO TABLE Admitted_NOV_RTT_Waiting_list 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Region_code,provider_code, provider_name,treatment_function_code,Treatment_function_name,wait_0_18,wait_19_52,wait_52_plus,
median_wait,percentile_95,completed_pathways,@Time_period)
SET Time_period = STR_TO_DATE(@Time_period, '%Y-%m-%d');

SELECT * FROM admitted_nov_rtt_waiting_list;

UPDATE admitted_nov_rtt_waiting_list -- updating column
 SET `Time_Period` = '2025-11-01'
 WHERE `Time_Period` = '2025-10-01';

 CREATE TABLE NonAdmitted_SEP_RTT_Waiting_list (  -- Creating the first table of non admitted patients
    Region_code VARCHAR(10)  NOT NULL,
    Provider_code VARCHAR(10) NOT NULL,
    Provider_name VARCHAR(255) NOT NULL,
    Treatment_function_code VARCHAR(10)  NOT NULL,
    Treatment_function_name VARCHAR(255) NOT NULL,
   

    Wait_0_18 INT NOT NULL,
    Wait_19_52 INT NOT NULL,
    wait_52_plus INT NOT NULL,

    Median_wait DECIMAL(5,2),
    percentile_95 DECIMAL(5,2),
    completed_pathways INT,
     Time_Period DATE NOT NULL,

    PRIMARY KEY  (provider_Code,treatment_function_code,Time_Period )

);

LOAD DATA LOCAL INFILE"C:/Users/44774/Desktop/CBF PROJECT/Completed NonAdmitted provider Sep25 data.csv" --loading the 1st batch of non-admitted patient
INTO TABLE NonAdmitted_SEP_RTT_Waiting_list 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Region_code,provider_code, provider_name,treatment_function_code,Treatment_function_name,wait_0_18,wait_19_52,wait_52_plus,
median_wait,percentile_95,completed_pathways,@Time_period)
SET Time_period = STR_TO_DATE(@Time_period, '%Y-%m-%d');

SELECT * FROM nonadmitted_sep_rtt_waiting_list;

UPDATE nonadmitted_sep_rtt_waiting_list --updating column to remove null values
 SET `Time_Period` = '2025-09-01'
 WHERE `Time_Period` = 0;

CREATE TABLE NonAdmitted_OCT_RTT_Waiting_list ( --creating the second table for the second batch of data
    Region_code VARCHAR(10)  NOT NULL,
    Provider_code VARCHAR(10) NOT NULL,
    Provider_name VARCHAR(255) NOT NULL,
    Treatment_function_code VARCHAR(10)  NOT NULL,
    Treatment_function_name VARCHAR(255) NOT NULL,
   

    Wait_0_18 INT NOT NULL,
    Wait_19_52 INT NOT NULL,
    wait_52_plus INT NOT NULL,

    Median_wait DECIMAL(5,2),
    percentile_95 DECIMAL(5,2),
    completed_pathways INT,
     Time_Period DATE NOT NULL,

    PRIMARY KEY  (provider_Code,treatment_function_code,Time_Period )

);

LOAD DATA LOCAL INFILE"C:/Users/44774/Desktop/CBF PROJECT/Completed NonAdmitted-Provider-Oct25-Data.csv" --loading csv in
INTO TABLE NonAdmitted_OCT_RTT_Waiting_list 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Region_code,provider_code, provider_name,treatment_function_code,Treatment_function_name,wait_0_18,wait_19_52,wait_52_plus,
median_wait,percentile_95,completed_pathways,@Time_period)
SET Time_period = STR_TO_DATE(@Time_period, '%Y-%m-%d');

SELECT * FROM nonadmitted_oct_rtt_waiting_list;

UPDATE nonadmitted_oct_rtt_waiting_list
SET `Time_Period` = '2025-10-01'
WHERE `Time_Period` = 0;

CREATE TABLE NonAdmitted_NOV_RTT_Waiting_list ( --creating third table for non admitted RTT
    Region_code VARCHAR(10)  NOT NULL,
    Provider_code VARCHAR(10) NOT NULL,
    Provider_name VARCHAR(255) NOT NULL,
    Treatment_function_code VARCHAR(10)  NOT NULL,
    Treatment_function_name VARCHAR(255) NOT NULL,
   

    Wait_0_18 INT NOT NULL,
    Wait_19_52 INT NOT NULL,
    wait_52_plus INT NOT NULL,

    Median_wait DECIMAL(5,2),
    percentile_95 DECIMAL(5,2),
    completed_pathways INT,
     Time_Period DATE NOT NULL,

    PRIMARY KEY  (provider_Code,treatment_function_code,Time_Period )

);

LOAD DATA LOCAL INFILE"C:/Users/44774/Desktop/CBF PROJECT/Completed NonAdmitted-Provider-Nov25-Data.csv" --loading data in
INTO TABLE NonAdmitted_NOV_RTT_Waiting_list 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Region_code,provider_code, provider_name,treatment_function_code,Treatment_function_name,wait_0_18,wait_19_52,wait_52_plus,
median_wait,percentile_95,completed_pathways,@Time_period)
SET Time_period = STR_TO_DATE(@Time_period, '%Y-%m-%d');

SELECT * FROM nonadmitted_nov_rtt_waiting_list;

UPDATE nonadmitted_NOV_rtt_waiting_list
SET `Time_Period` = '2025-11-01'
WHERE `Time_Period` = 0;

CREATE TABLE Admitted_rtt_waiting_list_all LIKE admitted_sep_rtt_waiting_list; --creating a single table to join all similar table

INSERT INTO admitted_rtt_waiting_list_all ---inserting data into master table for admitted patients data
SELECT * FROM admitted_sep_rtt_waiting_list;

INSERT INTO admitted_rtt_waiting_list_all
SELECT * FROM admitted_oct_rtt_waiting_list;

INSERT INTO admitted_rtt_waiting_list_all
SELECT * FROM admitted_nov_rtt_waiting_list;

SELECT * FROM admitted_rtt_waiting_list_all;

CREATE TABLE NonAdmitted_rtt_waiting_list_all LIKE NonAdmitted_SEP_RTT_Waiting_list; --creating the master table for all non admitted patients data

INSERT INTO nonadmitted_rtt_waiting_list_all
SELECT * FROM nonadmitted_sep_rtt_waiting_list;

INSERT INTO nonadmitted_rtt_waiting_list_all
SELECT * FROM nonadmitted_oct_rtt_waiting_list;

INSERT INTO nonadmitted_rtt_waiting_list_all
SELECT * FROM nonadmitted_nov_rtt_waiting_list;

SELECT * FROM nonadmitted_rtt_waiting_list_all;

DELETE from admitted_rtt_waiting_list_all
where `Treatment_function_code` = 'C_999'; -- trying to remove a row where the waiting list per provider was totalled

DELETE from nonadmitted_rtt_waiting_list_all
where `Treatment_function_code` = 'C_999';

-- Analysing rtt waiting times by treatment function from admitted patients by treatment function
SELECT 
Treatment_function_name,Treatment_function_code,
SUM(Wait_0_18) AS Total_0_18_wait, SUM(wait_19_52) AS Total_19_52_wait,
SUM(wait_52_plus) AS Toatl_52_plus_wait, SUM(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM admitted_rtt_waiting_list_all
GROUP BY `Treatment_function_code`,`Treatment_function_name`
ORDER BY total_waiting DESC;

--Analysing rtt waiting times from non admitted rtt patients by treatment function

SELECT 
Treatment_function_name,Treatment_function_code,
SUM(Wait_0_18) AS Total_0_18_wait, SUM(wait_19_52) AS Total_19_52_wait,
SUM(wait_52_plus) AS Toatl_52_plus_wait, SUM(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM nonadmitted_rtt_waiting_list_all
GROUP BY `Treatment_function_code`,`Treatment_function_name`
ORDER BY total_waiting DESC;

--Analysing rtt waiting times from rtt admitted patients by provider(NHS Trust) within 18 weeks
SELECT 
Provider_code,Provider_name,
SUM(Wait_0_18) AS Total_0_18_wait, SUM(wait_19_52) AS Total_19_52_wait,
SUM(wait_52_plus) AS Toatl_52_plus_wait,
ROUND(SUM(wait_0_18) * 100.0 /SUM(wait_0_18 + wait_19_52 + wait_52_plus),2) AS pct_within_18_weeks
FROM admitted_rtt_waiting_list_all
GROUP BY `Provider_name`, provider_code
ORDER BY pct_within_18_weeks DESC;

--Analysing rtt waiting times from rtt admitted patients by provider(NHS Trust) within 52weeks plus

SELECT
Provider_code,Provider_name,
SUM(Wait_0_18) AS Total_0_18_wait, SUM(wait_19_52) AS Total_19_52_wait,
SUM(wait_52_plus) AS Toatl_52_plus_wait,
ROUND(SUM(wait_52_plus) * 100.0 /SUM(wait_0_18 + wait_19_52 + wait_52_plus),2) AS pct_after_52_weeks
FROM admitted_rtt_waiting_list_all
GROUP BY `Provider_name`, provider_code
ORDER BY pct_after_52_weeks DESC;

--Analysing rtt waiting times from rtt  nonAdmitted patients by provider(NHS Trust) within 18 weeks

SELECT 
Provider_code,Provider_name,
SUM(Wait_0_18) AS Total_0_18_wait, SUM(wait_19_52) AS Total_19_52_wait,
SUM(wait_52_plus) AS Toatl_52_plus_wait,
ROUND(SUM(wait_0_18) * 100.0 /SUM(wait_0_18 + wait_19_52 + wait_52_plus),2) AS pct_within_18_weeks
FROM nonadmitted_rtt_waiting_list_all
GROUP BY `Provider_name`, provider_code
ORDER BY pct_within_18_weeks DESC;

--Analysing rtt waiting times from rtt NonaAdmitted patients by provider(NHS Trust) within 52weeks plus

SELECT
Provider_code,Provider_name,
SUM(Wait_0_18) AS Total_0_18_wait, SUM(wait_19_52) AS Total_19_52_wait,
SUM(wait_52_plus) AS Toatl_52_plus_wait,
ROUND(SUM(wait_52_plus) * 100.0 /SUM(wait_0_18 + wait_19_52 + wait_52_plus),2) AS pct_after_52_weeks
FROM nonadmitted_rtt_waiting_list_all
GROUP BY `Provider_name`, provider_code
ORDER BY pct_after_52_weeks DESC;

--Comparing treatment function waiting times within each NHS Trust in rtt admitted patients

SELECT
Provider_code,`Provider_name`,treatment_function_name,treatment_function_code,
SUM(Wait_0_18) AS Total_0_18_wait, SUM(wait_19_52) AS Total_19_52_wait,
SUM(wait_52_plus) AS Toatl_52_plus_wait
FROM admitted_rtt_waiting_list_all
GROUP BY `Provider_code`,`Provider_name`,`Treatment_function_code`,`Treatment_function_name`
ORDER BY `Provider_name`,`Treatment_function_name` DESC;

--To get 5 treatment function from each provider as per the highest waiting in rtt admitted patients

WITH Ranked_TFC_By_Provider AS (
    SELECT
    provider_code,provider_name,Treatment_function_code,Treatment_function_name,
    (`Wait_0_18`+ `Wait_19_52` + wait_52_plus) AS total_Waiting,
    ROW_NUMBER() OVER (PARTITION BY `Provider_code` ORDER BY (`Wait_0_18`+ `Wait_19_52` + wait_52_plus) DESC) AS RN
    FROM admitted_rtt_waiting_list_all
    
)
SELECT
 provider_code,provider_name,Treatment_function_code,Treatment_function_name,
 total_Waiting,RN
 FROM `Ranked_TFC_By_Provider`
 WHERE RN <= 5
 ORDER BY `Provider_code`, total_Waiting DESC;

 -- Going further to rank top 10 providers and top 5 TFC's per provider for rtt admitted as per total waiting

 WITH Provider_Totals AS (
    SELECT
    provider_code,provider_name, Time_Period,  SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) AS total_Waiting,
    ROW_NUMBER() OVER (PARTITION BY Time_Period   ORDER BY SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) DESC) AS provider_Rank
    FROM admitted_rtt_waiting_list_all
    GROUP BY `Provider_code`, provider_name,`Time_Period`
 ),
 Top10_Providers AS (
    SELECT *
    FROM Provider_Totals
    WHERE provider_Rank <= 10
 ),

 TFC_Ranked AS (
    SELECT r.`Provider_code`,r.`Provider_name`,r.`Treatment_function_code`,r.`Treatment_function_name`, r.Time_Period,
    (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) AS Total_Waiting_TFC, 

    ROW_NUMBER() OVER ( PARTITION BY r.Provider_code,r.`Time_Period`
    ORDER BY (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) DESC) AS TFC_rank
    FROM admitted_rtt_waiting_list_all AS r
    JOIN Top10_Providers AS p
    ON r.Provider_code = p.Provider_code
    AND r.Time_Period = p.Time_Period
 )
 SELECT 
 `Provider_code`,`Provider_name`,`Treatment_function_code`,`Treatment_function_name`,`Time_Period`,
 Total_Waiting_TFC,TFC_Rank
 FROM `TFC_Ranked`
 WHERE TFC_Rank <= 5
 ORDER BY `Time_Period`,`Provider_code`,Total_Waiting_TFC DESC;

 
 -- ranking 10 providers and their5 TFC's  for the least waiting timeper provider for rtt Admitted  patients as per total waiting

 WITH Provider_Totals AS (
    SELECT
    provider_code,provider_name, Time_Period,  SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) AS total_Waiting,
    ROW_NUMBER() OVER (PARTITION BY Time_Period   ORDER BY SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) ASC) AS provider_Rank
    FROM admitted_rtt_waiting_list_all
    GROUP BY `Provider_code`, provider_name,`Time_Period`
 ),
 10Providers_Low_Waiting AS (
    SELECT *
    FROM Provider_Totals
    WHERE provider_Rank <= 10
 ),

 TFC_Ranked AS (
    SELECT r.`Provider_code`,r.`Provider_name`,r.`Treatment_function_code`,r.`Treatment_function_name`, r.Time_Period,
    (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) AS Total_Waiting_TFC, 

    ROW_NUMBER() OVER ( PARTITION BY r.Provider_code,r.`Time_Period`
    ORDER BY (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) ASC) AS TFC_rank
    FROM admitted_rtt_waiting_list_all AS r
    JOIN 10Providers_Low_Waiting AS p
    ON r.Provider_code = p.Provider_code
    AND r.Time_Period = p.Time_Period
 )
 SELECT 
 `Provider_code`,`Provider_name`,`Treatment_function_code`,`Treatment_function_name`,`Time_Period`,
 Total_Waiting_TFC,TFC_Rank
 FROM `TFC_Ranked`
 WHERE TFC_Rank <= 5
 ORDER BY `Time_Period`,`Provider_code`,Total_Waiting_TFC ASC;

 -- for non admitted rtt waiting list Top 10 providers and their TFC with highest waiting list

 WITH Provider_Totals AS (
    SELECT
    provider_code,provider_name, Time_Period,  SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) AS total_Waiting,
    ROW_NUMBER() OVER (PARTITION BY Time_Period   ORDER BY SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) DESC) AS provider_Rank
    FROM nonadmitted_rtt_waiting_list_all
    GROUP BY `Provider_code`, provider_name,`Time_Period`
 ),
 Top10_Providers AS (
    SELECT *
    FROM Provider_Totals
    WHERE provider_Rank <= 10
 ),

 TFC_Ranked AS (
    SELECT r.`Provider_code`,r.`Provider_name`,r.`Treatment_function_code`,r.`Treatment_function_name`, r.Time_Period,
    (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) AS Total_Waiting_TFC, 

    ROW_NUMBER() OVER ( PARTITION BY r.Provider_code,r.`Time_Period`
    ORDER BY (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) DESC) AS TFC_rank
    FROM nonadmitted_rtt_waiting_list_all AS r
    JOIN Top10_Providers AS p
    ON r.Provider_code = p.Provider_code
    AND r.Time_Period = p.Time_Period
 )
 SELECT 
 `Provider_code`,`Provider_name`,`Treatment_function_code`,`Treatment_function_name`,`Time_Period`,
 Total_Waiting_TFC,TFC_Rank
 FROM `TFC_Ranked`
 WHERE TFC_Rank <= 5
 ORDER BY `Time_Period`,`Provider_code`,Total_Waiting_TFC DESC;

 -- non admitted rtt patients with the least waiting time as per provider and their TFC

 WITH Provider_Totals AS (
    SELECT
    provider_code,provider_name, Time_Period,  SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) AS total_Waiting,
    ROW_NUMBER() OVER (PARTITION BY Time_Period   ORDER BY SUM(`Wait_0_18`+ `Wait_19_52` + wait_52_plus) ASC) AS provider_Rank
    FROM nonadmitted_rtt_waiting_list_all
    GROUP BY `Provider_code`, provider_name,`Time_Period`
 ),
 10Providers_Low_Waiting AS (
    SELECT *
    FROM Provider_Totals
    WHERE provider_Rank <= 10
 ),

 TFC_Ranked AS (
    SELECT r.`Provider_code`,r.`Provider_name`,r.`Treatment_function_code`,r.`Treatment_function_name`, r.Time_Period,
    (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) AS Total_Waiting_tfc, 

    ROW_NUMBER() OVER ( PARTITION BY r.Provider_code,r.`Time_Period`
    ORDER BY (r.Wait_0_18 + r.Wait_19_52 + r.wait_52_plus) ASC) AS TFC_rank
    FROM nonadmitted_rtt_waiting_list_all AS r
    JOIN 10Providers_Low_Waiting AS p
    ON r.Provider_code = p.Provider_code
    AND r.Time_Period = p.Time_Period
 )
 SELECT 
 `Provider_code`,`Provider_name`,`Treatment_function_code`,`Treatment_function_name`,`Time_Period`,
 Total_Waiting_tfc,TFC_Rank
 FROM `TFC_Ranked`
 WHERE TFC_Rank <= 5
 ORDER BY `Time_Period`,`Provider_code`,Total_Waiting_tfc ASC;

 CREATE TABLE Provider_IMD(
   Provider_Code VARCHAR(10) NOT NULL,
   Provider_Name VARCHAR(255),
   LSOA_Code VARCHAR(20),
   IMD_Rank INT,
   IMD_Decile TINYINT,
   LSOA_Name VARCHAR(255),
   LSOA_District VARCHAR(50),

   
   PRIMARY KEY (Provider_Code)

 );

 LOAD DATA LOCAL INFILE"C:/Users/44774/Desktop/CBF PROJECT/IMD Table for Analysis.csv" -- i discovered an error in the initial data and tried re-loading
INTO TABLE Provider_imd
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(provider_code,provider_name,lsoa_code,imd_rank,imd_decile,lsoa_name,lsoa_district);

select * FROM provider_imd;


SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = TRUE;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SELECT * FROM provider_imd;

--Joing the imd table to admitted waiting list table

SELECT * 
FROM admitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`;

--Joining IMD with non admitted rtt waiting list
SELECT * 
FROM nonadmitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`;

--Calculating average waiting times by IMD Decile for admitted providers

DELETE from provider_imd
where `IMD_Decile` = 0;


SELECT imd_decile, AVG(wait_0_18 + wait_19_52 + wait_52_plus) AS avg_total_waiting
FROM admitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS p
ON r.`Provider_code` = p.`Provider_Code`
GROUP BY `IMD_Decile`
ORDER BY `IMD_Decile`;

--Calculating average waiting time IMD Decile from non admitted rtt waiting list

SELECT imd_decile, AVG(wait_0_18 + wait_19_52 + wait_52_plus) AS avg_total_waiting
FROM nonadmitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS p
ON r.`Provider_code` = p.`Provider_Code`
WHERE `IMD_Decile` IS NOT NULL
GROUP BY `IMD_Decile`
ORDER BY `IMD_Decile`;
---Calculating 10 Top most deprived providers and their waiting times from admitted rtt
SELECT 
i.provider_code,i.provider_name,imd_decile,sum(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM admitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`
WHERE `IMD_Decile` IS NOT NULL
GROUP BY `Provider_Code`,`Provider_Name`,`IMD_Decile`
ORDER BY `IMD_Decile` ASC, total_waiting DESC
LIMIT 10;

--Calculating 10 Top most deprived providers and their waiting times from nonadmitted rtt

SELECT 
i.provider_code,i.provider_name,imd_decile,sum(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM nonadmitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`
WHERE `IMD_Decile` IS NOT NULL
GROUP BY `Provider_Code`,`Provider_Name`,`IMD_Decile`
ORDER BY `IMD_Decile`ASC , total_waiting DESC
LIMIT 10;

--comparing waiting times between deprived and affluent group in admitted rtt
SELECT
CASE WHEN imd_decile BETWEEN 1 AND 2 THEN 'Most Deprived(1-2)'
     WHEN imd_decile BETWEEN 9 AND 10 THEN 'Least Deprived(9-10)'
     ELSE 'Middle'
END AS Deprivation_group,
AVG(wait_0_18 + wait_19_52 + wait_52_plus) AS AVG_Waiting
FROM admitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`
GROUP by Deprivation_group;

--comparing waiting times between deprived and affluent group in non admitted rtt
SELECT
CASE WHEN imd_decile BETWEEN 1 AND 2 THEN 'Most Deprived(1-2)'
     WHEN imd_decile BETWEEN 9 AND 10 THEN 'Least Deprived(9-10)'
     ELSE 'Middle'
END AS Deprivation_group,
AVG(wait_0_18 + wait_19_52 + wait_52_plus) AS AVG_Waiting
FROM nonadmitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`
GROUP by Deprivation_group;

--Top 5 Treatment function in the most deprived areas for non admitted patients
SELECT 
Treatment_function_code,Treatment_function_name,
Sum(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM nonadmitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`
WHERE i.`IMD_Decile` IN (1,2)
GROUP BY `Treatment_function_code`,`Treatment_function_name`
ORDER BY total_waiting DESC
LIMIT 5;

--Top treatment function in least deprived area of admitted rtt due to them having more waiting times
 SELECT 
Treatment_function_code,Treatment_function_name,
Sum(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM admitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code`
WHERE i.`IMD_Decile` IN (9,10)
GROUP BY `Treatment_function_code`,`Treatment_function_name`
ORDER BY total_waiting DESC
LIMIT 5;

--Waiting times by IMD Decile over time for admitted rtt
SELECT 
Time_period,Imd_decile,SUM(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM admitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i 
ON r.`Provider_code` = i.`Provider_Code`
WHERE `IMD_Decile` IS NOT NULL
GROUP BY `Time_Period`,`IMD_Decile`
ORDER BY `Time_Period`,`IMD_Decile`;


--Trend analysis: Waiting times by IMD Decile over time for nonadmitted rtt
SELECT 
Time_period,Imd_decile,SUM(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM nonadmitted_rtt_waiting_list_all AS r
LEFT JOIN provider_imd AS i 
ON r.`Provider_code` = i.`Provider_Code`
WHERE `IMD_Decile` IS NOT NULL
GROUP BY `Time_Period`,`IMD_Decile`
ORDER BY `Time_Period`,`IMD_Decile`;

--which providers in IMD 1-2 are under the most pressure
SELECT 
r.provider_code,r.provider_name,i.imd_decile,
SUM(wait_0_18 + wait_19_52 + wait_52_plus) AS total_waiting
FROM nonadmitted_nov_rtt_waiting_list AS r 
LEFT JOIN provider_imd AS i
ON r.`Provider_code` = i.`Provider_Code` 
WHERE `IMD_Decile` IN (1,2)
GROUP BY r.`Provider_code`,r.`Provider_name`,i.`IMD_Decile`
ORDER BY total_waiting DESC;
---Star Schema Data Modelling

CREATE TABLE dim_provider ( --the first dimension table
   provider_code VARCHAR(10) PRIMARY KEY,
   provider_name VARCHAR(255),
   provider_postcode VARCHAR(10),
   lsoa_code VARCHAR(20),
   lsoa_name VARCHAR(255),
   district_code VARCHAR(20),
   imd_rank INT,
   imd_decile TINYINT
);

CREATE TABLE dim_treatment_function ( -- the second dimension table
   treatment_function_code VARCHAR(10) PRIMARY KEY,
   treatment_function_name VARCHAR(255)
);


CREATE TABLE dim_time (  --the third dimension table
   time_period DATE PRIMARY KEY,
   year INT,
   Month INT,
   month_name VARCHAR(20),
   quarter VARCHAR(10)
);

CREATE TABLE Fact_rtt_waiting_list ( -- the fact table
   rtt_id INT AUTO_INCREMENT PRIMARY KEY,
   provider_code VARCHAR(10),
   Treatment_function_code VARCHAR(10),
   Time_period DATE,
   Pathway_type VARCHAR(20),  

   wait_0_18 INT,
   Wait_19_52 INT,
   Wait_52_plus INT,
  

   Foreign Key (Provider_code) REFERENCES dim_provider (provider_code),
   Foreign Key (Treatment_function_code) REFERENCES dim_treatment_function (treatment_function_code),
   Foreign Key (time_period) REFERENCES dim_time(time_period)
);
 
ALTER TABLE fact_rtt_waiting_list --adding additional column that was initially ignored
ADD COLUMN `Median_wait` DECIMAL(10,2),
ADD COLUMN percentile_95  DECIMAL(10,2),
ADD COLUMN completed_pathways INT;


INSERT INTO dim_provider (provider_code,provider_name) -- loading table to provider dimension table
SELECT DISTINCT provider_code,provider_name
FROM admitted_rtt_waiting_list_all

UNION

SELECT DISTINCT provider_code,provider_name
FROM nonadmitted_rtt_waiting_list_all;

UPDATE dim_provider AS d  --matching the post codes correctly
JOIN nhs_trust AS t 
ON d.provider_name = t.`TRUST_Name`
SET d.provider_postcode =t.`Post_code`;

ALTER TABLE dim_provider
CHANGE COLUMN district_code lsoa_district VARCHAR(50);

UPDATE dim_provider AS d  --joining tables to filter the right required column 
JOIN provider_imd AS i 
ON d.provider_code = i.`Provider_Code` 
SET
d.lsoa_code =i.`LSOA_Code`,
d.lsoa_name = i.`LSOA_Name`,
d.lsoa_district = i.`LSOA_District`,
d.imd_rank = i.`IMD_Rank`, 
d.imd_decile = i.`IMD_Decile`; 

INSERT INTO dim_treatment_function (treatment_function_code,treatment_function_name) -- joinging admitted and non admitted data into the second dimension table
SELECT DISTINCT treatment_function_code,treatment_function_name
FROM admitted_rtt_waiting_list_all

UNION

SELECT DISTINCT treatment_function_code,treatment_function_name
FROM nonadmitted_rtt_waiting_list_all;


INSERT INTO dim_time (time_period,year,month,month_name,quarter) -- the time dimension table
SELECT DISTINCT
      Time_Period, YEAR(Time_period),
      MONTH(Time_period), DATE_FORMAT(Time_period,'%M'), CONCAT('Q', QUARTER(Time_period))
FROM admitted_rtt_waiting_list_all 

UNION

SELECT DISTINCT
      Time_Period, YEAR(Time_period),
      MONTH(Time_period), DATE_FORMAT(Time_period,'%M'), CONCAT('Q', QUARTER(Time_period))
FROM nonadmitted_rtt_waiting_list_all;

INSERT INTO fact_rtt_waiting_list (
   provider_code,`Treatment_function_code`,`time_period`,`Pathway_type`,wait_0_18,`Wait_19_52`,`Wait_52_plus`,`Median_wait`,percentile_95,completed_pathways
)
SELECT
provider_code,`Treatment_function_code`,`Time_period`,'Admitted',wait_0_18,`Wait_19_52`,`Wait_52_plus`,`Median_wait`,percentile_95,completed_pathways
FROM admitted_rtt_waiting_list_all; 

INSERT INTO fact_rtt_waiting_list (
   provider_code,`Treatment_function_code`,`time_period`,`Pathway_type`,wait_0_18,`Wait_19_52`,`Wait_52_plus`,`Median_wait`,percentile_95,completed_pathways
)
SELECT
provider_code,`Treatment_function_code`,`Time_period`,'Non-admitted',wait_0_18,`Wait_19_52`,`Wait_52_plus`,`Median_wait`,percentile_95,completed_pathways
FROM nonadmitted_rtt_waiting_list_all;
