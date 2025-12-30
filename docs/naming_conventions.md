# Naming Conventions
This is a detailed explaination about the naming convention used in the Schemas, Tables, Views, Columns and Procedures of this Database.

## General Rules
- **Name Format :** Use `snake_case` for all types of objects, lowercase letters for words and underscore `_` for spacing.
- **Language :** Use English for all object names.
- **Avoid Reserved Words :** No reservered word for SQL can be used in as an object name

## Schema Rules
- Use the lowercase version of the layer's name for that schema
    - `bronze`
    - `silver`
    - `gold`

## Table & View Rules
### Bronze
- Bronze layer is entirely consists of tables only. All the tables should follow the convention of source name followed by enitity name.
- The source name is the abbreviated form of the source and the table name should match the original data file in that source.
- The table name should be of the format `<source>_<entity>`
  - Example of a source : `crm`
  - Example of an enitity : `cust_info`
  - Example of a table name : `crm_cust_info`
  
### Silver
- Silver layer is entirely consists of tables only. All the tables should follow the convention of source name followed by enitity name.
- The source name is the abbreviated form of the source and the table name should match the original data file in that source.
- The table name should be of the format `<source>_<entity>`
  - Example of a source : `erp`
  - Example of an enitity : `cust_az12`
  - Example of a table name : `erp_cust_az12`
  
### Gold
- Gold layer is entirely consists of views only. All the views should follow the convention of category name in which the view belongs to followed by a descriptive name of the data in that view.
- The category names belong to two main categories, **dimension** and **fact**, the description of the data should be easy to understand for non-technical users.
- The view name should be of the format `<category>_<entity>`
  - Examples of category : `dim` , `fact`
  - Examples of entity : `products` , `sales`
  - Examples of view : `dim_products` , `fact_sales`

## Column Rules
### Surrogate Key
- All Surrogate Key columns in the dimension table should start with the table name follwed by the suffix 'key'.
- The column name should be of the format `<table_name>_key`
    - Example of a table name : `customer`
    - Example of a surrogate key column : `customer_key`

### Technical Columns
- All technical columns in the tables and views should start with the prefix 'dwh' followed by the description of the column's purpose.
- The column name should be of the format `dwh_<column_name>`
  - Example of a column purpose : `load_date`
  - Example of a technical column : `dwh_load_date`


## Stored Procedure

- All Stored Procedure should follow the convention of naming the procedure with the suffix 'load' followed by the layer that is being loaded.
- The stored procedure name should be of the format `load_<layer>`
  - Example of a layer name : `bronze`
  - Example of a stored procedure : `load_bronze`