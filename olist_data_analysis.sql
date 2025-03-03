-- SQL olist data analysis
CREATE DATABASE olist_data;

CREATE TABLE olist_customers_dataset (
	customer_id					VARCHAR(45),
	customer_unique_id			VARCHAR(45),
	customer_zip_code_prefix 	INT,
	customer_city				VARCHAR(50),
	customer_state				VARCHAR(5)
);

SELECT * FROM olist_customers_dataset;

CREATE TABLE olist_geolocation_dataset (
	geolocation_zip_code_prefix		INT,
	geolocation_lat					DOUBLE PRECISION,
	geolocation_lng					DOUBLE PRECISION,
	geolocation_city				VARCHAR(50),
	geolocation_state 				VARCHAR(2)
);

SELECT * FROM olist_geolocation_dataset;

CREATE TABLE olist_order_items_dataset (
	order_id			VARCHAR(32),
	order_item_id		INT,
	product_id			VARCHAR(32),
	seller_id			VARCHAR(32),
	shipping_limit_date	TIMESTAMP,
	price				FLOAT,
	freight_value		FLOAT	
);

SELECT * FROM olist_order_items_dataset;

CREATE TABLE olist_order_payments_dataset (
	order_id				VARCHAR(32),
	payment_sequential		INT,
	payment_type			VARCHAR(20),
	payment_installments	INT,
	payment_value			FLOAT
);

SELECT * FROM olist_order_payments_dataset;

CREATE TABLE olist_order_reviews_dataset (
	review_id					VARCHAR(32),
	order_id					VARCHAR(32),
	review_score				INT,
	review_comment_title		VARCHAR(500),
	review_comment_message		VARCHAR(1000),
	review_creation_date		VARCHAR(50), -- since we do not know the format of this column, so we first accept it as a string
	review_answer_timestamp		VARCHAR(50) -- in next step we'll convert it into a timestamp or data
);

SELECT * FROM olist_order_reviews_dataset;

-- there was an error when importing data, due to timestamp's current format which is inconsistent with timestamp postgres expects
-- so we run the following updates firs

ALTER TABLE olist_order_reviews_dataset 
ALTER COLUMN review_creation_date TYPE TIMESTAMP USING TO_DATE(review_creation_date, 'YYYY/MM/DD'),
ALTER COLUMN review_answer_timestamp TYPE TIMESTAMP USING TO_TIMESTAMP(review_answer_timestamp, 'MM/DD/YYYY HH24:MI');

-- check if it's done?
SELECT * FROM olist_order_reviews_dataset;

-- it has converted the date column to timestamp as well with time being 00:00; we need to fix it first
ALTER TABLE olist_order_reviews_dataset 
ALTER COLUMN review_creation_date TYPE DATE USING review_creation_date::DATE;
-- review_creation_date::DATE → Converts TIMESTAMP to DATE by removing the time part.

-- check if it's done?
SELECT * FROM olist_order_reviews_dataset;

CREATE TABLE olist_orders_dataset (
	order_id						VARCHAR(32),
	customer_id						VARCHAR(32),
	order_status					VARCHAR(25),
	order_purchase_timestamp		VARCHAR(50), -- since we do not know the format of this column, so we first accept it as a string
	order_approved_at				VARCHAR(50), -- -- in next step we'll convert it into a timestamp or data
	order_delivered_carrier_date	VARCHAR(50),
	order_delivered_customer_date	VARCHAR(50),
	order_estimated_delivery_date	VARCHAR(50)	
);

SELECT * FROM olist_orders_dataset;

-- earlier we sat the timestamp and date type data to varchar intentionally as it was throwing error in import
-- converting the tiemstamp and date type date back to timestamp and date respectively.

ALTER TABLE olist_orders_dataset 
ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP USING TO_TIMESTAMP(order_purchase_timestamp, 'MM/DD/YYYY HH24:MI'),
ALTER COLUMN order_approved_at TYPE TIMESTAMP USING TO_TIMESTAMP(order_approved_at, 'MM/DD/YYYY HH24:MI'),
ALTER COLUMN order_delivered_carrier_date TYPE TIMESTAMP USING TO_TIMESTAMP(order_delivered_carrier_date, 'MM/DD/YYYY HH24:MI'),
ALTER COLUMN order_delivered_customer_date TYPE TIMESTAMP USING TO_TIMESTAMP(order_delivered_customer_date, 'MM/DD/YYYY HH24:MI'),
ALTER COLUMN order_estimated_delivery_date TYPE DATE USING TO_DATE(order_estimated_delivery_date, 'YYYY/MM/DD');

-- check if it's done?
SELECT * FROM olist_orders_dataset;

CREATE TABLE olist_products_dataset (
	product_id					VARCHAR(32),
	product_category_name		VARCHAR(100),
	product_name_lenght			INT,
	product_description_lenght	INT,
	product_photos_qty			INT,
	product_weight_g			INT,
	product_length_cm			INT,
	product_height_cm			INT,
	product_width_cm			INT
);

SELECT * FROM olist_products_dataset;

CREATE TABLE olist_sellers_dataset (
	seller_id				VARCHAR(32),
	seller_zip_code_prefix	INT,
	seller_city				VARCHAR(50),
	seller_state			VARCHAR(2)
);

SELECT * FROM olist_sellers_dataset;

CREATE TABLE product_category_name_translation (
	product_category_name			VARCHAR(150),
	product_category_name_english	VARCHAR(150)
);

SELECT * FROM product_category_name_translation;


-- CALLING ALL THE TABLES TO CHECK IF THE DATA IS FETCHED SUCCESSFULLY

SELECT * FROM olist_customer_dataset;
SELECT * FROM olist_geolocation_dataset;
SELECT * FROM olist_order_items_dataset;
SELECT * FROM olist_order_payments_dataset;
SELECT * FROM olist_order_reviews_dataset;
SELECT * FROM olist_orders_dataset;
SELECT * FROM olist_products_dataset;
SELECT * FROM olist_sellers_dataset;
SELECT * FROM product_category_name_translation;

-- ***********************************************BUSINESS PROBLEMS***********************************************

-- **QUESTION 1: TOTAL REVENUE**
-- What is the total revenue generated by Olist, and how has it changed over time?

-- we see the value of the order lies in the payment_value column of the table olist_order_payments_dataset
SELECT SUM(payment_value) AS total_revenue 
FROM olist_order_payments_dataset;


-- **QUESTION 2: ORDER VOLUME OVER TIME**
-- How many orders were placed on Olist, and how does this vary by month or season?

-- How many orders places on Olist
SELECT COUNT(order_id) AS total_orders
FROM olist_orders_dataset;

-- Order variation by month
SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
    COUNT(order_id) AS total_orders
FROM olist_orders_dataset
GROUP BY year, month
ORDER BY year, month;

-- on the basis of season
SELECT 
	EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
	CASE
		WHEN EXTRACT(MONTH FROM order_purchase_timestamp) IN (12, 1, 2) THEN 'Winter'
		WHEN EXTRACT(MONTH FROM order_purchase_timestamp) IN (3, 4, 5) THEN 'Spring'
		WHEN EXTRACT(MONTH FROM order_purchase_timestamp) IN (6, 7, 8) THEN 'Summer'
		WHEN EXTRACT(MONTH FROM order_purchase_timestamp) IN (9, 10, 11) THEN 'Fall'
	END AS season,
	COUNT(order_id) AS total_orders
FROM olist_orders_dataset
GROUP BY purchase_year, season
ORDER BY purchase_year, season
;

-- **QUESTION 3: POPULAR PRODUCT CATEGORIES**
-- What are the most popular product categories on Olist, 
-- and how do their sales volumes compare to each other?
SELECT COUNT(*) FROM olist_products_dataset;
SELECT COUNT(*) FROM olist_order_items_dataset;
SELECT * FROM olist_order_items_dataset;

-- ** we need to extract product category name, numer of total orders, and total sale items**
-- number of total orders can be calculated from olist_order_dataset,
-- category name is to be extracted from olist_products_dataset,
-- total sale can be calculated from price field in table olist_order_items_dataset

SELECT opd.product_category_name,
	COUNT(ood.order_id) AS total_orders,
	SUM(ooid.price) AS total_sales_price
FROM olist_order_items_dataset AS ooid
JOIN  olist_products_dataset AS opd
	ON ooid.product_id = opd.product_id
JOIN olist_orders_dataset AS ood
	ON ood.order_id = ooid.order_id
GROUP BY opd.product_category_name
ORDER BY total_orders DESC, total_sales_price DESC
;

-- **QUESTION 4: AVERAGE ORDER VALUE (AOV)**
-- What is the average order value (AOV) on Olist, 
-- and how does this vary by product category or payment method?

-- avrage order value variation by product category or payment method
-- so we need order from olist_orders_dataset, ood
-- product_category from olist_products_dataset, opd
-- payment_type from olist_order_payments_dataset, oopd
-- and price from olist_order_items_dataset, ooid

SELECT opd.product_category_name, 
	oopd.payment_type, 
	AVG(ooid.price + ooid.freight_value) AS avg_order_value_category_payment_method_wise
FROM olist_order_items_dataset AS ooid
JOIN olist_orders_dataset AS ood
	ON ooid.order_id=ood.order_id
JOIN olist_order_payments_dataset AS oopd
	ON oopd.order_id=ooid.order_id
JOIN olist_products_dataset AS opd
	ON opd.product_id=ooid.product_id
GROUP BY opd.product_category_name, oopd.payment_type
ORDER BY avg_order_value_category_payment_method_wise DESC
;	

-- **QUESTION 5: ACTIVE SELLERS OVER TIME**
-- How many sellers are active on Olist, 
-- and how does this number change over time?

SELECT 
	EXTRACT(YEAR FROM ood.order_delivered_carrier_date) AS year,
	EXTRACT(MONTH FROM ood.order_delivered_carrier_date) AS month,
	COUNT(DISTINCT ooid.seller_id) AS distinct_active_sellers
FROM olist_order_items_dataset AS ooid
JOIN olist_orders_dataset AS ood
	ON ooid.order_id=ood.order_id
WHERE ood.order_status != 'canceled'
	-- AND 
	-- ood.order_delivered_carrier_date >= (SELECT MAX(order_delivered_carrier_date) FROM olist_orders_dataset) - INTERVAL '1 year'
GROUP BY year, month
ORDER BY year, month
;
-- ** if user want to get the active sellers of last 1 year since the most recent date of order delivered to carrier,
-- ** uncomment the above where clause


-- **QUESTION 6: SELLER RATINGS IMPACT**
-- What is the distribution of seller ratings on Olist, 
-- and how does this impact sales performance?


SELECT ooid.seller_id, 
	oord.review_score,
	COUNT(DISTINCT ooid.order_id) AS total_orders,
	SUM(ooid.price + ooid.freight_value) AS total_sale
FROM olist_orders_dataset AS ood
JOIN olist_order_items_dataset AS ooid
	ON ood.order_id=ooid.order_id
JOIN olist_order_reviews_dataset AS oord
	ON ood.order_id=oord.order_id
WHERE oord.review_score IS NOT NULL
GROUP BY ooid.seller_id, oord.review_score
ORDER BY ooid.seller_id, oord.review_score DESC
;

-- **QUESTION 7: REPEAT CUSTOMERS**
-- How many customers have made repeat purchases on Olist, and what percentage of total sales do they account for?

SELECT ocd.customer_id,
	COUNT(ocd.customer_id) AS customer_total_orders,
	SUM(ooid.price + ooid.freight_value) AS total_sale_value,
	SUM(ooid.price + ooid.freight_value) / (SELECT SUM(price + freight_value) FROM olist_order_items_dataset) AS percentage_value
FROM olist_orders_dataset AS ood
JOIN olist_customers_dataset AS ocd
	ON ocd.customer_id=ood.customer_id
JOIN olist_order_items_dataset AS ooid
	ON ooid.order_id=ood.order_id
GROUP BY ocd.customer_id
HAVING COUNT(ocd.customer_id) > 1
ORDER BY percentage_value DESC
;

-- **QUESTION 8: CUSTOMER RATINGS IMPACT**
-- What is the average customer rating for products sold on Olist, 
-- and how does this impact sales performance?

WITH seller_stats AS(
	SELECT 
		ooid.seller_id,
		ood.order_id,
		AVG(oord.review_score) OVER(PARTITION BY ooid.seller_id) AS avg_review_score,
		-- COUNT(ood.order_id) OVER(PARTITION BY ooid.seller_id) AS total_orders,
		SUM(ooid.price) OVER(PARTITION BY ooid.seller_id) AS total_sale
	FROM olist_order_reviews_dataset AS oord
	JOIN olist_orders_dataset AS ood
		ON oord.order_id=ood.order_id
	JOIN olist_order_items_dataset AS ooid
		ON ooid.order_id=ood.order_id
)
SELECT 
	DISTINCT s.seller_id,
	s.avg_review_score,
	COUNT(DISTINCT s.order_id) AS total_orders,
	s.total_sale
FROM seller_stats AS s
GROUP BY s.seller_id, s.avg_review_score, s.total_sale
ORDER BY total_orders DESC
;

-- the query given below is also serving the same purpose, and it is a bit faster

SELECT 
    ooid.seller_id,
    AVG(oord.review_score) AS avg_review_score,
    COUNT(DISTINCT ood.order_id) AS total_orders,
    SUM(ooid.price) AS total_sale
FROM olist_order_reviews_dataset AS oord
JOIN olist_orders_dataset AS ood
    ON oord.order_id = ood.order_id
JOIN olist_order_items_dataset AS ooid
    ON ooid.order_id = ood.order_id
GROUP BY ooid.seller_id
ORDER BY total_orders DESC
;



-- **QUESTION 9: ORDER CANCELLATION RATE**
-- What is the average order cancellation rate on Olist, and how does this impact seller performance?
WITH canceled_orders_info AS(
	SELECT ooid.seller_id,
		COUNT(CASE WHEN ood.order_status='canceled' THEN ood.order_id END) 
			OVER(PARTITION BY ooid.seller_id) AS canceled_orders,
		SUM(CASE WHEN ood.order_status='canceled' THEN ooid.price END) 
			OVER(PARTITION BY ooid.seller_id) AS total_value_canceled,
		COUNT(CASE WHEN ood.order_status != 'canceled' THEN ood.order_id END) 
            OVER (PARTITION BY ooid.seller_id) AS non_canceled_orders,
        SUM(CASE WHEN ood.order_status != 'canceled' THEN ooid.price END) 
            OVER (PARTITION BY ooid.seller_id) AS total_value_non_canceled
	FROM olist_orders_dataset AS ood
	JOIN olist_order_items_dataset AS ooid
		ON ood.order_id=ooid.order_id
)
SELECT 
	DISTINCT coi.seller_id,
	(coi.canceled_orders + coi.non_canceled_orders) AS total_orders,
	coi.canceled_orders,
	coi.non_canceled_orders,
	CAST(coi.canceled_orders * 100 AS FLOAT)
		/ NULLIF(coi.canceled_orders + coi.non_canceled_orders, 0) AS order_cancel_percentage,
	coi.total_value_canceled,
	coi.total_value_non_canceled,
	CAST(coi.total_value_canceled AS FLOAT)
		/ NULLIF(coi.total_value_canceled + coi.total_value_non_canceled, 0) AS cancel_value_percentage
FROM canceled_orders_info AS coi
ORDER BY coi.canceled_orders DESC
;

-- other way to do the same task is:

WITH canceled_orders_info AS (
    SELECT 
        ooid.seller_id,
        COUNT(CASE WHEN ood.order_status = 'canceled' THEN ood.order_id END) 
            OVER (PARTITION BY ooid.seller_id) AS canceled_orders,
        SUM(CASE WHEN ood.order_status = 'canceled' THEN ooid.price END) 
            OVER (PARTITION BY ooid.seller_id) AS total_value_canceled,
        COUNT(CASE WHEN ood.order_status != 'canceled' THEN ood.order_id END) 
            OVER (PARTITION BY ooid.seller_id) AS non_canceled_orders,
        SUM(CASE WHEN ood.order_status != 'canceled' THEN ooid.price END) 
            OVER (PARTITION BY ooid.seller_id) AS total_value_non_canceled
    FROM olist_orders_dataset AS ood
    JOIN olist_order_items_dataset AS ooid
        ON ood.order_id = ooid.order_id
)
SELECT 
    seller_id,
    MAX(canceled_orders) AS canceled_orders,
    MAX(total_value_canceled) AS total_value_canceled,
    MAX(non_canceled_orders) AS non_canceled_orders,
    MAX(total_value_non_canceled) AS total_value_non_canceled
FROM canceled_orders_info
GROUP BY seller_id
ORDER BY canceled_orders DESC;

-- **QUESTION 10: TOP-SELLING PRODUCTS**
-- What are the top-selling products on Olist, 
-- and how have their sales trends changed over time?

SELECT 
	EXTRACT(YEAR FROM ood.order_purchase_timestamp) AS year,
	EXTRACT(MONTH FROM ood.order_purchase_timestamp) AS month,
	opd.product_category_name,
	COUNT(ood.order_id) AS total_sale,
	SUM(ooid.price) AS total_revenue
FROM olist_products_dataset AS opd
JOIN olist_order_items_dataset AS ooid
	ON opd.product_id=ooid.product_id
JOIN olist_orders_dataset AS ood
	ON ood.order_id=ooid.order_id
GROUP BY year, month, opd.product_category_name
ORDER BY year, month, total_sale DESC
;

-- **QUESTION 11: PAYMENT METHOD ANALYSIS**
-- Which payment methods are most commonly used by Olist customers, 
-- and how does this vary by product category or geographic region?

SELECT 
    ocd.customer_state AS customer_region, -- Customer's geographic region
    opd.product_category_name, -- Product category
    oopd.payment_type, -- Payment method
    COUNT(oopd.order_id) AS total_orders, -- Total number of orders
    SUM(oopd.payment_value) AS total_payment_value -- Total payment value
FROM 
    olist_order_payments_dataset AS oopd
JOIN 
    olist_orders_dataset AS ood
    ON oopd.order_id = ood.order_id
JOIN 
    olist_customers_dataset AS ocd
    ON ood.customer_id = ocd.customer_id
JOIN 
    olist_order_items_dataset AS ooid
    ON ood.order_id = ooid.order_id
JOIN 
    olist_products_dataset AS opd
    ON ooid.product_id = opd.product_id
GROUP BY 
    ocd.customer_state, -- Group by customer region
    opd.product_category_name, -- Group by product category
    oopd.payment_type -- Group by payment method
ORDER BY 
    ocd.customer_state, 
    opd.product_category_name, 
    total_orders DESC
;
	
-- **QUESTION 12: IMPACT OF REVIEWS & RATINGS**
-- How do customer reviews and ratings affect sales and product performance on Olist?

WITH product_review_n_sale_analysis AS(
	SELECT 
		COALESCE(opd.product_category_name, 'Uncategorized') AS product_category_name,
		COUNT(opd.product_category_name) OVER(PARTITION BY opd.product_category_name) AS total_orders,
		AVG(oord.review_score) OVER(PARTITION BY opd.product_category_name) AS avg_review,
		SUM(ooid.price + ooid.freight_value) OVER(PARTITION BY opd.product_category_name) AS total_sale
	FROM olist_orders_dataset AS ood
	JOIN
		olist_order_items_dataset AS ooid
		ON ood.order_id=ooid.order_id
	JOIN 
		olist_order_reviews_dataset AS oord
		ON oord.order_id=ood.order_id
	JOIN 
		olist_products_dataset AS opd
		ON opd.product_id=ooid.product_id
)
SELECT 
	DISTINCT prsa.product_category_name,
	prsa.total_orders,
	CAST(prsa.avg_review AS FLOAT(4)),
	prsa.total_sale
FROM product_review_n_sale_analysis AS prsa
WHERE prsa.total_orders != 0
ORDER BY prsa.total_orders DESC
;

-- **QUESTION 13: PROFIT MARGINS & STRATEGY**
-- Which product categories have the highest profit margins on Olist, and how can the company increase profitability across different categories?

-- insufficient information. As cost column is not available in the data, therefore calculating the profit is not possible.

-- **QUESTION 14: MARKETING SPEND & ROI**
-- How does Olist's marketing spend and channel mix impact sales and customer acquisition costs, and how can the company optimize its marketing strategy to increase ROI?

-- **QUESTION 15: CUSTOMER DENSITY & RETENTION**
-- Geolocation having high customer density. Calculate customer retention rate according to geolocations.

SELECT 
	ood.customer_id,
	COUNT(ood.customer_id) AS total_orders
FROM olist_customers_dataset AS ocd
JOIN 
	olist_orders_dataset AS ood
	ON ood.customer_id=ocd.customer_id
GROUP BY ood.customer_id
ORDER BY total_orders DESC
;
-- this shows that each customer purchased only once, there's none who came twice.

WITH customer_orders AS (
    SELECT 
        ocd.customer_state,
        ocd.customer_id,
        COUNT(ood.order_id) AS total_orders
    FROM 
        olist_customers_dataset AS ocd
    JOIN 
        olist_orders_dataset AS ood
        ON ocd.customer_id = ood.customer_id
    GROUP BY 
        ocd.customer_state, ocd.customer_id
),
retention_analysis AS (
    SELECT 
        customer_state,
        COUNT(DISTINCT customer_id) AS total_customers,
        COUNT(DISTINCT CASE WHEN total_orders > 1 THEN customer_id END) AS repeat_customers
    FROM 
        customer_orders
    GROUP BY 
        customer_state
)
SELECT 
    customer_state,
    total_customers,
    repeat_customers,
    (repeat_customers * 100.0 / total_customers) AS retention_rate
FROM 
    retention_analysis
ORDER BY 
    retention_rate DESC;








