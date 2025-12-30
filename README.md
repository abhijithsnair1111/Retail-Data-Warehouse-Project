# Retail Data Warehouse : ETL Medallion Pipeline

Welcome to the Retail Data Warehouse Project 🪛  
This is a comprehensive SQL **Data Warehouse Project** consisting of an end-to-end **ETL Pipeline** implemented through the **Medallion Architecture.**

## 🚀 Project Overview
The goal of this project is to take unorganized data from a retail chain spanning across different countries, put them through a full ETL pipeline and produce clean and business ready data for analysis and reporting.  
This main concepts of this project are
- **ETL Pipeline :** Extracting, Transforming and Loading data from th source into the Data Warehouse
  
- **Medallion Architecture :** Designing the Architecture based on the Medallion Structure (**Bronze**, **Silver** and **Gold** layers)
  
- **Data Modelling :** Developing **Fact** and **Dimension** tables using **Star Schema** for Analysis and Reporting purposes

## 🛠 Data Architecture
The Data architecture of this project is based on the **Medallion Structure**, that is the data flows through three layers **Bronze** , **Silver** and **Gold**  

![High Level Data Architecture](docs/data_architecture.png)

**Bronze Layer :** Data is extracted from the source as it is. The files are stored into the Warehouse

**Silver Layer :** Data is extracted from the Bronze layer as it is. Further manipulating the raw data by cleaning, standardizing, normalizing

**Gold Layer :** Data is not extracted, but only access to data that has been combined and organised from the Silver layer is provided

## 💡 Project Pipeline
### Source
The source file for this project consisted of two major groups of data tables, each with three  
tables inside of them regrading details about **Customers** , **Products** and **Sales**
1. **Customer Relationship Managment (CRM)**

    - Basic Customer information `crm_cust_info`
      
    - Basic Product information `crm_prd_info`
      
    - Basic Sales information `crm_sales_details`

2. **Enterprise Resource Planning (ERP)**

    - Additonal Customer Demographics information `erp_cust_az12`
      
    - Additional Customer Geographic information `erp_loc_a101`
      
    - Additional Product Category information `erp_px_cat_g1v2`

### ETL Process
The Medallion structure was selected for this particular project in order to establish a strict seperation of cencerns. 
The entire Extract, Transform and Load processes for this project was implemented multiple times through out the these three
layer according to the pre defined actions that should be taken inside each layer

- **Bronze Layer**
  - Data is loaded into the Bronze layer directly from the CSV source file
  
  - Data is not transformed in any capacity


- **Silver Layer**
  - Data is loaded into the Silver layer directly from the Bronze layer

  - Data is manupulated by **Cleaning** , **Standardizing** and **Normalizing** each column

  - Data **Enrichment** is also done through **Derived Columns**

- **Gold Layer**
  - No data is loaded into the Gold layer as tables

  - **Views** are created as **Dimension** and **Fact** tables by combing existing tables in the Silver layer

  - Data transformation includes **Integraton**, **Aggregations** and **Business Logics**

  - The Fact and Dimension tabels are modelled to form as **Star Schema** structure to the data

### Business Ready Data
After processing data through three layer the end data is user friendly and ready for business actions
The Medallion structure provides an outcome that can be used for consumption by analysts ans non-technical users accordingly









