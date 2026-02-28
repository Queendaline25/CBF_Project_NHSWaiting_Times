
# Project Title: Comparing Referral to Treatment (RTT) waiting times of England NHS Trust (2025) with the index of multiple deprivation(IMD).

## Problem statement: This project aims to analyse RTT waiting time performance across NHS providers and examine how these patterns vary by deprivation levels in the provider catchment areas. By integrating RTT datasets with IMD scores and accurately mapping provider codes to IMD decile number. The analysis seeks to identify whether patients in more deprived areas experience disproportionately longer waits for elective care and also,  whether some treatment functions have more waiting times than others.

### Objectives:
### Primary Objective:
*   To analyse NHS Referral to Treatment (RTT) waiting times across providers and determine how these waiting times vary by levels of socioeconomic deprivation, as measured by the Index of Multiple Deprivation (IMD).
Secondary Objectives:
*   To accurately map NHS provider codes to their corresponding IMD decile numbers, ensuring clean, reliable joins across datasets.
*   To identify patterns, disparities, or trends in RTT performance between more deprived and less deprived provider catchment area.
*   To explore whether deprivation is associated with longer waiting times for elective care.
*   To create clear, interactive visualisations that support operational decision making and highlight potential health inequalities.
*   To provide data driven insights that can support equitable resource allocation and targeted interventions.

### Data Sources:
1. NHS RTT Waiting Times Dataset:
    *   Monthly RTT performance data published by NHS England. https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/rtt-data-2024-25/

2. Index of Multiple Deprivation (IMD) Dataset
https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019

3. NHS Organisation Data Service (ODS)
https://geoportal.statistics.gov.uk/datasets/ab70b4d242464355a2e7859226f8e2b9
    

4.  Supporting Data:
    *   Population estimates (ONS)
    *   Geographical lookup tables (LSOA → Local Authority → Region)
    *   NHS region boundary

       
### Tools and Resources:
*   Microsoft Excel (V lookup, Index and Match)
*   MYSQL (Joins, Group BY, CTEs, Window functions etc)
*   Data Modelling Tools (dbdiagram.io)
*   Visualization and Reporting tools (Looker Studio)
*   Version Control and collaboration tools(Git and GitHub)



### Project Structure:
```
├── Data_Raw        # Original RTT datasets (untouched)
├── Data_Clean      # Cleaned and transformed datasets
├── SQL_scripts     # SQL scripts for cleaning,analysing and modelling
├── Data_Modelling  # Star Schema EER diagram and table structure
├── Dashboard       # Looker Studio link + screenshots
├── Docs            # Data dictionary, and notes
├── images          # Images used in README
└── README.md       # Project documentation
```
### How to Run the Project

* Clone the repo
* Load the data
* Run SQL scripts
* Connect to Looker Studio
* View the dashboard


###  Methodology: 
1. #### Data Collection
    *   Downloaded RTT monthly datasets from NHS England.
    *   Obtained IMD 2019 (or latest available) dataset from GOV.UK.
    * Collected Provider level data with postcodes from NHS England.
    * Data understanding of the RTT dataset and reporting
    *   Imported all datasets into SQL.

2. #### Data Cleaning & Preparation:
   Raw RTT datasets contained inconsistencies in provider codes, specialty names and Time period formats. Cleaning steps included:

    *   Standardised Time_Period column into a consistent Year-Month format data types.
    *   Removed duplicate rows and corrected inconsistent provider codes.
    *   Removed suppressed or incomplete records.
    Validated totals against published NHS figures to ensure acuracy
    *  Mapped provider level data from NHS England and ONSPD by joining both dataset on postcodes inorder to retrieve the provider LSOA 2011 numbers
    * Used the retrieved LSOA numbers to get the IMD decile number for each NHS provider catchment area
    *   Validated joins using Provider codes
3. #### Data Integration
    *   Join RTT data with provider level region data.
    *   Retrieved IMD decile numbers from published  IMD data available in UK government website For NHS providers catchment area.
   *  Mapped the cleaned RTT dataset with the IMD table for index of multiple deprivation(IMD) analysis
    *   Created a combined dataset linking:
        *   RTT metrics
        *   IMD deciles
        *   Provider names and codes

4. #### Data Modelling(Star Schema):

    To support efficient analysis and dashboarding, the data was modelled into a star schema:
    * Fact table: RTT activity and waiting time metrics at provider, treatment function and month level.

    * Dimension tables:

    * dim_time for date attributes(year,month and quarter)
    * dim_provider for provider names,Districts, LSOA and decile numbers.
    * dim_treatment_function for RTT treatment function codes


5. #### Transformations and Feature Engineering:
    Additional fields were created in looker studio to support deeper analysis:
    * Percentage change in activity and waiting times
    * performance indicators such as % within 18 weeks and % within 52 weeks
    * deprivation related calculations.

6. ####  Exploratory Data Analysis:

    Looker studio was initially used to explore:
    * Trends in activity and waiting times
    * provider level variations
    * treatment function level performance
    * outliers and unusual patterns.
    
    EDA  informed which metrics and visuals were most meaningful for the dashboard

 7. #### Dashboard Design and visualizations

    The cleaned and modelled data was connected to looker studio to build an interactive dashboard. Design decisions included:

    * KPI score cards with intriquing insights
    * Trend charts and waiting time patterns between Admitted and Non Admitted RTT.
    * Treatment functions breakdowns for waiting time comparison

    * Provider level waiting times comparison among different treatment functions.

    * Index of multiple deprivation(IMD) views to highlight deprivations levels.



### Key Findings and Insights:
*   Clear Understanding of RTT Performance Across Providers within the 18weeks timeline and backlogs
*   Insight Into the Relationship Between Deprivation and Waiting Times

### Ethical Considerations:
1. Data Privacy and Confidentiality
*   All data used is publicly available and aggregated at provider or geographic level.
*   No patient level or identifiable information is included.
2. Responsible Interpretation of Deprivation Data
*   IMD scores represent area level deprivation, not individual socioeconomic status.
*   Findings are presented carefully to avoid stereotyping providers or implying causation where only correlation exists.
*   Results acknowledge the complexity of health inequalities and avoid oversimplification.
3. Transparency in Methods and Assumptions
*   All data cleaning steps, joins, and transformations are documented.
*   Provider code mappings and IMD assignments are validated and clearly explained.
*   Limitations—such as data suppression, missing values, or geographic approximations—are openly stated.


