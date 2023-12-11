-- Temporary tables, Views and CTEs lab

USE SAKILA;

/* 1. Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of
rentals (rental_count). */

SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.EMAIL, COUNT(RENTAL_ID) AS "NUMBER_OF_RENTALS" 
FROM SAKILA.RENTAL AS R
LEFT JOIN SAKILA.CUSTOMER AS C ON R.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY CUSTOMER_ID; -- QUERY THAT WILL BE USED IN VIEW

CREATE VIEW SAKILA_CUSTOMER_RENTALS AS (
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.EMAIL, COUNT(RENTAL_ID) AS "NUMBER_OF_RENTALS" 
FROM SAKILA.RENTAL AS R
LEFT JOIN SAKILA.CUSTOMER AS C ON R.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY CUSTOMER_ID);

/* Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
The Temporary Table should use the rental summary view created in Step 1 to join with the payment
table and calculate the total amount paid by each customer. */

SELECT CR.CUSTOMER_ID, CR.FIRST_NAME, CR.LAST_NAME, CR.EMAIL, SUM(P.AMOUNT) AS "TOTAL_PAID"
FROM SAKILA.SAKILA_CUSTOMER_RENTALS AS CR
LEFT JOIN SAKILA.PAYMENT AS P ON CR.CUSTOMER_ID = P.CUSTOMER_ID
GROUP BY CR.CUSTOMER_ID; -- QUERY THAT WILL BE USED IN TEMPORARY TABLE

CREATE TEMPORARY TABLE SAKILA_CUSTOMER_PAYMENTS AS (
SELECT CR.CUSTOMER_ID, CR.FIRST_NAME, CR.LAST_NAME, CR.EMAIL, SUM(P.AMOUNT) AS "TOTAL_PAID"
FROM SAKILA.SAKILA_CUSTOMER_RENTALS AS CR
LEFT JOIN SAKILA.PAYMENT AS P ON CR.CUSTOMER_ID = P.CUSTOMER_ID
GROUP BY CR.CUSTOMER_ID);

/* 3. Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table
created in Step 2. The CTE should include the customer's name, email address, rental count, and total
amount paid. */

SELECT R.FIRST_NAME, R.LAST_NAME, R.EMAIL, R.NUMBER_OF_RENTALS, P.TOTAL_PAID FROM SAKILA_CUSTOMER_RENTALS AS R
JOIN SAKILA_CUSTOMER_PAYMENTS AS P ON R.CUSTOMER_ID = P.CUSTOMER_ID;
-- QUERY THAT WILL BE USED IN CTE

WITH CUSTOMER_DATA AS (
SELECT R.FIRST_NAME, R.LAST_NAME, R.EMAIL, R.NUMBER_OF_RENTALS, P.TOTAL_PAID FROM SAKILA_CUSTOMER_RENTALS AS R
JOIN SAKILA_CUSTOMER_PAYMENTS AS P ON R.CUSTOMER_ID = P.CUSTOMER_ID)

SELECT * FROM CUSTOMER_DATA;

/* 4. Next, using the CTE, create the query to generate the final customer summary report,
which should include: customer name, email, rental_count, total_paid and average_payment_per_rental,
this last column is a derived column from total_paid and rental_count. */

WITH CUSTOMER_DATA AS (
SELECT R.FIRST_NAME, R.LAST_NAME, R.EMAIL, R.NUMBER_OF_RENTALS, P.TOTAL_PAID FROM SAKILA_CUSTOMER_RENTALS AS R
JOIN SAKILA_CUSTOMER_PAYMENTS AS P ON R.CUSTOMER_ID = P.CUSTOMER_ID)

SELECT FIRST_NAME, LAST_NAME, EMAIL, NUMBER_OF_RENTALS, TOTAL_PAID,
ROUND((TOTAL_PAID/NUMBER_OF_RENTALS),2) AS "AVERAGE_PAYMENT_PER_RENTAL"
FROM CUSTOMER_DATA;
