create database TelecomAnalytics

use TelecomAnalytics

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_type VARCHAR(20),
    age INT,
    city VARCHAR(50),
    signup_date DATE)

select * from customers

CREATE TABLE network_usage (
    customer_id INT,
    usage_date DATE,
    data_used_gb DECIMAL(10,2),
    call_minutes INT,
    network_type VARCHAR(10))

select * from network_usage

CREATE TABLE network_issues (
    issue_id INT PRIMARY KEY,
    customer_id INT,
    issue_date DATE,
    issue_type VARCHAR(50),
    resolution_time_hrs INT,
    resolved VARCHAR(10))

select * from network_issues

CREATE TABLE billing (
    bill_id INT PRIMARY KEY,
    customer_id INT,
    bill_month DATE,
    bill_amount DECIMAL(10,2),
    payment_status VARCHAR(20))

select * from billing

--Write Joins Across All Datasets
SELECT
c.customer_id,
c.city,
c.customer_type,
n.network_type,
n.data_used_gb,
i.issue_type,
b.bill_amount,
b.payment_status
FROM customers_data c
JOIN network_usage_data n
ON c.customer_id = n.customer_id
JOIN network_issues_data i
ON c.customer_id = i.customer_id
JOIN billing_data b
ON c.customer_id = b.customer_id;

--Calculate Complaint Rate Per Customer

SELECT
customer_id,
COUNT(issue_id) AS complaint_count
FROM network_issues_data
GROUP BY customer_id
ORDER BY complaint_count DESC;

--Window Function for Monthly Trend Analysis

SELECT
YEAR(issue_date) AS issue_year,
MONTH(issue_date) AS issue_month,
COUNT(*) AS total_issues,

SUM(COUNT(*))
OVER(
ORDER BY YEAR(issue_date),
MONTH(issue_date)
) AS running_total

FROM network_issues_data
GROUP BY
YEAR(issue_date),
MONTH(issue_date);

--Which Cities Require Network Improvement?

SELECT
c.city,
COUNT(i.issue_id) AS total_issues
FROM customers_data c
JOIN network_issues_data i
ON c.customer_id = i.customer_id
GROUP BY c.city
ORDER BY total_issues DESC;