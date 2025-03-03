# Olist E-Commerce Data Analysis

## Overview
Olist is a Brazilian e-commerce platform that connects small and medium-sized businesses to customers across Brazil. The platform operates as a marketplace, where merchants can list their products and services, and customers can browse and purchase them online.

The Olist sales dataset, available on Kaggle, is a collection of anonymized data about orders placed on the Olist platform between January 2017 and August 2018. It contains a wide range of information about each order, including the order date, product details, payment and shipping information, customer and seller IDs, and customer reviews. The dataset also includes information about the sellers who list their products on Olist, as well as data on customer behavior and demographics. This dataset is designed to help analysts and researchers better understand the e-commerce landscape in Brazil and identify opportunities for growth and optimization.

## Business Questions
To help Olist gain better insights into their e-commerce platform and optimize available opportunities for growth, this project aims to answer the following business questions:

1. **Revenue Analysis**:
   - What is the total revenue generated by Olist, and how has it changed over time?

2. **Order Analysis**:
   - How many orders were placed on Olist, and how does this vary by month or season?

3. **Product Category Analysis**:
   - What are the most popular product categories on Olist, and how do their sales volumes compare to each other?

4. **Average Order Value (AOV)**:
   - What is the average order value (AOV) on Olist, and how does this vary by product category or payment method?

5. **Seller Analysis**:
   - How many sellers are active on Olist, and how does this number change over time?

6. **Seller Ratings**:
   - What is the distribution of seller ratings on Olist, and how does this impact sales performance?

7. **Customer Retention**:
   - How many customers have made repeat purchases on Olist, and what percentage of total sales do they account for?

8. **Customer Ratings**:
   - What is the average customer rating for products sold on Olist, and how does this impact sales performance?

9. **Order Cancellation Rate**:
   - What is the average order cancellation rate on Olist, and how does this impact seller performance?

10. **Top-Selling Products**:
    - What are the top-selling products on Olist, and how have their sales trends changed over time?

11. **Payment Methods**:
    - Which payment methods are most commonly used by Olist customers, and how does this vary by product category or geographic region?

12. **Impact of Reviews**:
    - How do customer reviews and ratings affect sales and product performance on Olist?

13. **Profit Margins**:
    - Which product categories have the highest profit margins on Olist, and how can the company increase profitability across different categories?

14. **Marketing Strategy**:
    - How does Olist's marketing spend and channel mix impact sales and customer acquisition costs, and how can the company optimize its marketing strategy to increase ROI?

15. **Customer Density and Retention**:
    - Which geolocations have the highest customer density, and what is the customer retention rate according to geolocations?

## Dataset Description
The dataset includes the following key tables:
- **olist_orders_dataset**: Contains order details such as order ID, customer ID, order status, and timestamps.
- **olist_order_items_dataset**: Contains details about the items in each order, including product ID, price, and freight value.
- **olist_products_dataset**: Contains product details such as product ID, category, and dimensions.
- **olist_customers_dataset**: Contains customer details such as customer ID, location, and city.
- **olist_sellers_dataset**: Contains seller details such as seller ID and location.
- **olist_order_payments_dataset**: Contains payment details such as payment type and value.
- **olist_order_reviews_dataset**: Contains customer reviews and ratings for each order.

## Project Structure
- **Data Cleaning**: Preprocessing and cleaning the dataset to handle missing values, duplicates, and inconsistencies.
- **Exploratory Data Analysis (EDA)**: Analyzing the dataset to uncover trends, patterns, and insights.
- **Business Insights**: Answering the business questions using SQL and data visualization tools.

## Tools and Technologies
- **SQL**: For querying and analyzing the dataset.

## How to Use This Repository
1. Clone the repository:
   ```bash
   git clone https://github.com/haseeb-505/olist_data_analysis.git
