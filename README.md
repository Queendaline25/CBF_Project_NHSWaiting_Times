
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

    *   Includes metrics such as:
        *   Number of patients on admitted, non-admitted and complete pathways
        *   Percentage waiting over 18 weeks
        *   Number waiting over 52 weeks
        *   Provider level performance
2. Index of Multiple Deprivation (IMD) Dataset
https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019

    *   Official IMD scores published by the UK Government.
    *   Contains:
    *   Overall IMD score
    *   Deciles and ranks
    *   Geographic identifiers (LSOA codes)

3. NHS Organisation Data Service (ODS)
https://geoportal.statistics.gov.uk/datasets/ab70b4d242464355a2e7859226f8e2b9
    *   Provider codes and names
    *   Trust type (Acute, Community, Specialist, etc.)
    *   Region mapping (ICB, NHS Region)

4.  Supporting Data:
    *   Population estimates (ONS)
    *   Geographical lookup tables (LSOA → Local Authority → Region)
    *   NHS region boundary files 

### Methodology: 
1. Data Collection
    *   Downloaded RTT monthly datasets from NHS England.
    *   Obtained IMD 2019 (or latest available) dataset from GOV.UK.
    * Collected Provider level data with postcodes from NHS England
    *   Imported all datasets into SQL.
2. Data Cleaning & Preparation
    *   Standardised column names and data types.
    *   Handled missing or inconsistent provider codes.
    *   Removed suppressed or incomplete records.
    *  Mapped provider level data from NHS England and ONSPD by joining both dataset on postcodes inorder to retrieve the provider LSOA 2011 numbers
    * Used the retrieved LSOA numbers to get the IMD decile number for each NHS provider catchment area
    *   Validated joins using Provider codes
3. Data Integration
    *   Join RTT data with provider level region data.
    *   Retrieved IMD decile numbers from published  IMD data available in UK government website For NHS providers catchment area.
   *  Mapped the cleaned RTT dataset with the IMD table for index of multiple deprivation(IMD) analysis
    *   Created a combined dataset linking:
        *   RTT metrics
        *   IMD deciles
        *   Provider names and codes
        *   Region
### Tools and Resources:
*   Microsoft Excel (V lookup, Index and Match)
*   MYSQL (Joins, Group BY, CTEs, Window functions etc)
*   Data Modelling Tools (Fact and Dimension Table)
*   Visualization and Reporting tools (Looker Studio)
*   Version Control and collaboration tools(Git and GitHub)
### Key Findings and Insights:
*   Clear Understanding of RTT Performance Across Providers within the 18weeks timeline and backlogs
*   Insight Into the Relationship Between Deprivation and Waiting Times
*   A Clean, Well Modelled Star schema Fact and Dimension table
*   Interactive Dashboard for Stakeholders
*   Actionable Insights and Recommendations
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


