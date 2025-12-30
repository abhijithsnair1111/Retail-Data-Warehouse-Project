# Data Catalog - Gold Layer
## Overview
The Datawarehouse Project consists of three diffent layers, Bronze, Silver and Gold. These layers are arranged in the database as three schemas which contains various tables. The Gold layer is the final layer consisting of data which is ready for Analysis and Reporting. These tables are divided into two **dimension** tables and one **fact** table.

---

### 1. Customers Dimension (gold.dim_customers)
**Purpose :** The customers dimension table contains of all the relevent details  about the customer demographics which can be linked to the product and sales details via a unique customer key

**Columns :**

| Column Name     | DataType         | Description                                                               |
|---              |---               |---                                                                        |
| customer_key    | INT              | Surrogate Key, unique for each customer                                    |
| customer_id     | INT              | Unique numerical value for each customer                                  |
| customer_number | NVARCHAR(50)     | Alphanumeric value for tracking each customer                             |
| first_name      | NVARCHAR(50)     | Customer's First Name as provided                                         |
| last_name       | NVARCHAR(50)     | Customer's Last Name or Family Name as provided                           |
| country         | NVARCHAR(50)     | Customer's Country of residence as provided (eg: Germany)                 |
| marital_status  | NVARCHAR(50)     | Customer's Marital Status as provided (eg: Single, Married)               |
| gender          | NVARCHAR(50)     | Customer's Gender as provided (eg: Male, Female, N/A)                     |
| birthdate       | DATE             | Customer's Birthdate as provided formatted in YYYY-MM-DD (eg: 2000-09-15) |
| create_date     | DATE             | The date in which the customer detail are added to the database            |
---

### 2. Products Dimension (gold.dim_products)
**Purpose :** The products dimension table contians all the relevant details about the products including detailed breakdown of all the categories

**Columns :**
| Column Name    | Data Type    | Description                                                                  |
|---             |---           |---                                                                           |
| product_key    | INT          | Surrogte key, unique for each product                                        |
| product_id     | INT          | Unique numeric value for each product                                        |
| product_number | NVARCHAR(50) | Alphanumeric value for tracking each product                                 |
| product_name   | NVARCHAR(50) | Product Name of each product along with details such as type, color and size |
| category_id    | NVARCHAR(50) | Product's Category ID used of analysis                                       |
| category       | NVARCHAR(50) | Products's Category Name used at the highest level of classification       |
| subcategory    | NVARCHAR(50) | Product's Subcategory used for more detailed classification                  |
| maintenace     | NVARCHAR(50) | Product's Maintanace requirement (eg: Yes, No)                               |
| cost           | INT          | Product's price at the moment for a single unit                              |
| product_line   | NVARCHAR(50) | Product Line in which the product belong (eg: Mountain, Road)                 |
| start_date     | DATE         | Product initial date of sale or availability                                |


### 3. Sales Fact (gold.fact_sales)

**Purpose :** The sales fact table contains all the details about each sale along with keys to connect to other two dimension tables

**Colums :**
| Column Name  | Data Type    | Description                                                             |
|---           |---           |---                                                                      |
| order_id     | NVARCHAR(50) | Unique alphanumeric characters assigned to each order                   |
| product_key  | INT          | Unique key for each product used as a foreign key for joining purposes  |
| customer_key | INT          | Unique key for each customer used as a foreign key for joining purposes |
| order_date   | DATE         | Date in which that particular order was placed                          |
| ship_date    | DATE         | Date in which that particular order was shipped                         |
| due_date     | DATE         | Date in which that particular order's payment is due                    |
| sales        | INT          | The total amount of the order                                           |
| quantity     | INT          | The total quantity of the products in the order                         |
| price        | INT          | The price of a single unit of the product in the order                  |