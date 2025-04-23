# Bank Customer Churn Analysis


![BankImage](https://github.com/user-attachments/assets/abbf3fa7-76c4-4a7e-97ee-375857819338)

##Table of Contents

-[Introduction](#Introduction)

-[Dataset Overview](#Dataset-Overview)

-[Project Objective](#Project-Objective)

-[Data Cleaning](#Data-Cleaning)

-[Analysis and Insight](#Analysis-and-Insight)

-[Dashboard](#Dashboard)

-[Recommendation](#Recommendation)

-[Conclusion](#Conclusion)

## Introduction

Customer churn is a significant challenge for financial institutions, impacting revenue and profitability. Understanding the key drivers of churn can help banks develop effective retention strategies. This project aims to analyze customer behavior, segment customers based on their banking activities, and uncover patterns that distinguish churned customers from retained ones.

## Dataset Overview

This dataset is made up of 15 columns and 10000 rows
- Field			      Description
- CustomerID		    A unique identifier for each customer
- Surname		      The Customer’s last name
- Credit score		  A numerical value representing the customer’s credit score
- Geography		    The country where the customer resides (France, Spain or Germany)
- Gender		        The customers gender (Male or Female)
- Age			        The customer’s age
- Tenure			      The number of years the customer has been with the bank
- Balance		      The customer’s account balance
- NumOfProducts	  The number of bank products the customer uses (e.g. savings account, credit card)
- HasCrCard	      Whether the customer has a credit card (1 = yes, 0 = no)
- IsActiveMember	  Whether the customer is an active member (1 = yes, 0 = no)
- Estimated Salary	The estimated salary of the customer
- Exited          	Whether the customer has churned (1 = yes, 0 = no)

<img width="847" alt="Excel Screenshot" src="https://github.com/user-attachments/assets/ce83c5d4-d4b7-45f4-9e96-d0e225590567" />

## Project Objective

Key Business Questions to Solve:
1. Understanding Customer Churn
- ✅ What attributes (e.g., credit score, balance, tenure, number of products) are most common among churners?
- ✅ What is the overall churn rate? How does it vary across demographics?
- ✅ Are customers with higher balances more likely to stay or leave?
2. Customer Segmentation & Behavioral Analysis
- ✅ Can customers be grouped into different segments based on their banking behavior?
- ✅ How do high-value customers (e.g., high balance, multiple products) compare to low-value customers?
- ✅ What proportion of churned customers had multiple products vs. single products?
3. Geographic & Demographic Trends
- ✅ How does churn rate differ by country (France, Spain, Germany)?
- ✅ Do older customers have a lower churn rate compared to younger customers?
- ✅ Is there a significant difference in churn between male and female customers?
4. Customer Engagement & Activity Levels
- ✅ Do inactive members have a higher churn rate than active members?
- ✅ What is the relationship between credit score and churn?
- ✅ Are customers with credit cards less likely to churn?
5. Financial & Revenue Insights
- ✅ What is the average balance and salary of churned vs. retained customers?
- ✅ Are customers with lower credit scores more likely to churn?
- ✅ Does tenure (years with the bank) influence churn rates?

## Data Cleaning

-	Renaming of table
```sql
Rename table `bank customer churn data.zip` to Bank_Customer_Churn;
select * from bank_customer_churn;
```
-	To check for duplicate
```sql
select creditscore, balance, tenure, numofproducts, hascrcard, age, estimatedsalary, count(*) from bank_customer_churn
group by creditscore, balance, tenure, numofproducts,hascrcard, age, estimatedsalary
having count(*) > 1;
```
-	Adding new columns to the table
```sql
Alter table bank_customer_churn
 add column Age_group text after Age;
 ```
 ```sql
set SQL_SAFE_UPDATES=0;
 update bank_customer_churn
 set Age_group = case
				when age between 0 and 20 then "Youth"
				when age between 21 and 41 then "Young_Adult"
				when age between 45 and 64 then "Middle_Age"
				when age between 63 and 83 then "Seniors"
				else "Elderly"
				end;
```
```sql
Alter table bank_customer_churn
add column NHI int after isactivemember;
```
 ```sql
set SQL_SAFE_UPDATES = 0;
 Update bank_customer_churn
 set NHI = concat(Numofproducts+ HasCrCard+IsActivemember);
```
## Analysis and Insight
1. Understanding Customer Churn
- ✅ What attributes are most common among churners?
- a. Gender:
- Insight: Female had a count churn of 1139 while male have 898.
- b. Geography:
- Insight: Germany has the highest churn count of 814, followed by France having a churn count of 810 while span had the lowest churn count of 413.
- c. Age Group:
- Insight: The middle-age had the highest churn count of 1001, young adult has the churn count of 750, while the elderly had a churn count of 239, followed by senior having 42 and youth has 5 as their churn count.
- d. HasCrCard:
- Insight: Customers who have CrCard has the highest churn count of 1424 while those who do not have CrCard has a churn count of 613.
- e. NumOfProduct:
- Insight: Customer using a single product has a churn count of 1409 compared to those customers using multiple products having a churn count of 628.
 - f. Tenure:
- Insight: Mid_tenure have the highest churn count of 785 followed by low tenure having 741 and lastly high tenure with a churn count of 511.
The most common attributes here is HasCrCard having the highest churn count of 1424.

  ✅ What is the overall churn rate? How does it vary across demographics?
- Insight: The overall churn rate in this dataset is 20.37%
Churn rate across Demographics
- a. Geography:
- Insight: Germany has the highest churn rate of 39.96%, followed by France with a churn rate of 39.76% and lastly is Spain having a churn rate of 20.27%.
- b. Gender:
- Insight: The female has a churn rate of 55.92% while the male has a churn rate of 44.08%.
- c. Age-Group:
- Insight: Middle-age group has the highest churn rate of 49.14%, young adult has a churn rate of 36.82%, elderly has a churn rate of 11.73%, seniors has a churn rate of 2.06% and  lastly, youth has a churn rate of 0.25%.
- d. IsActiveMember:
- Insights: Non_active customers have a churn rate of 63.92% while Active customers have a churn rate of 36.08%

✅ Are customers with higher balances more likely to stay or leave?
- Insights: Yes, when I limited the customers to 15, there were 9 customers that churned as compared to 6 customers that did not churn.

2. Customer Segmentation & Behavioral Analysis
- ✅ Can customers be grouped into different segments based on their banking behavior?
- Insights: Moderate-customers has the highest churn count of 5045, reliable-customers has a churn count of 3248, Low-value customers have 1303 churn count and lastly Elite customers have 404 churn count.
- ✅ How do high-value customers compare to low-value customers?
- Insights: High value customers have a churn count of 6302 while low value customers have 3698.

✅ What proportion of churned customers had multiple products vs. single products?
- Insights: Customers with multiple products has a churn rate of 30.83% while customers with single product have a churn rate of 69.17%.

3. Geographic & Demographic Trends
- ✅ How does churn rate differ by country (France, Spain, Germany)?
- Insights: Germany have a churn rate of 39.96%, France have 39.76% churn rave and Spain have 20.27% churn rate.

✅ Do older customers have a lower churn rate compared to younger customers?
- Insights: Yes, Older customers have a lower churn rate compared to the younger customers. Except for the youths having the lowest churn rate of 0.25% in the age group, maybe because that age group just started using the bank and does not have too much business with the bank yet.
- ✅ Is there a significant difference in churn between male and female customers?
- Insights: There is a difference in the churn rate between the Female and male gender. Females have the highest churn rate of 55.92% and Males has churn rate of 44.08%.
4. Customer Engagement & Activity Levels
- ✅ Do inactive members have a higher churn rate than active members?
- Insights: Yes, inactive members have a higher churn rate of 63.92% as compared to active members having a churn rate of 36.08%.
- ✅ What is the relationship between credit score and churn?
- Insights: Customers under medium credit score group have the highest churn rate of 51.64%, followed by high credit score group with 40.89% churn rate and lastly customers with low credit score group having 7.46% churn rate.
- ✅ Are customers with credit cards less likely to churn?
- Insights: No, customers with credit cards are even more likely to churn, having a churn rate of 69.91% compared to customers without credit cards having a churn rate of 30.09%.
5. Financial & Revenue Insights
- ✅ What is the average balance and salary of churned vs. retained customers?
- Insights: The average balance and average salary of churned customers are $91108.54 and $101465.68 while that of retained customers are $72745.3 and $99738.39 respectively.
- ✅ Are customers with lower credit scores more likely to churn?
- Insights: From this dataset, No. Customers with low credit score churned less with the churn rate of &.47%, high credit score group is next with churn rate of40.89. Meanwhile, medium credit score group had the highest churn rate of 51.64%.

✅ Does tenure (years with the bank) influence churn rates?
- Insights: Yes, Mid-Tenure and Low-Tenure group have the same churn rate of 36.36% while the High-Tenure group have the lowest churn rate of 27.27% amongst them all.

<img width="595" alt="LinkedIn1" src="https://github.com/user-attachments/assets/6099f21f-38db-4be6-a5d4-a2b9bb6b5302" />

<img width="593" alt="LinkedIn2" src="https://github.com/user-attachments/assets/3e59a1ca-1801-4000-bd22-aa36a328ff95" />

## Dashboard

![Bank Churn Dashbiard](https://github.com/user-attachments/assets/3a25821c-960b-4151-8aa2-0c35ca320a71)


## Recommendation

- Demographic Recommendations:
1. Targeted Marketing: Design targeted marketing
campaigns to appeal to female customers, who have a higher churn rate.
2. Geographic Focus: Focus on improving customer
satisfaction in Germany and France, where churn rates are highest.
3. Age-Specific Services: Offer age-specific services
and benefits to middle-aged customers, who have the highest churn rate.

- Behavioral Recommendations
1. Tenure-Based Incentives: Offer incentives and
rewards to customers who have been with the bank for 0-3 years to reduce churn.
2. Reactivation Campaigns: Launch reactivation
campaigns to win back non-active customers and reduce churn.
3. Card Ownership Benefits: Provide benefits and
rewards to customers who own credit cards to reduce churn.

- Financial Recommendations
1. Salary-Based Services: Offer salary-based services
and benefits to high-income earners to reduce churn.
2. Balance-Based Incentives: Offer incentives and
rewards to customers with high average balances to reduce churn.
3. Financial Education: Provide financial education
and planning services to customers to help them manage their finances
effectively.

- Customer Segmentation Recommendations
1.  High-Value
Customer Retention: Implement strategies to retain high-value customers, who
have a higher count.
2.  Moderate Customer Engagement: Engage with moderate customers, who have the
highest count, to improve satisfaction and reduce churn.
3.  Low-Value Customer Acquisition: Focus on acquiring new low-value customers to
increase market share.

- Customer Engagement Recommendations
1.	Credit Score-Based Services: Offer credit score-based services and benefits to
customers with medium credit scores to reduce churn.
2.	Product Usage Incentives: Offer incentives and rewards to customers who use
multiple products to reduce churn.

3.	Customer Feedback: Collect customer feedback and implement changes to improve
customer satisfaction and reduce churn.

## Conclusion
Personalized and Data-Driven Approach: To reduce customer churn, a personalized and data-driven approach is necessary. This involves understanding customer demographics, behavior, financial characteristics, and preferences to design targeted strategies.
Multi-Faceted Strategy: A multi-faceted strategy that addresses various aspects of customer relationships is required. This includes demographic, behavioral, financial, and customer engagement factors.
Customer Segmentation: Customer segmentation is crucial to identify high-value customers, moderate customers, and low-value customers. Tailored strategies can then be developed to retain, engage, and acquire customers in each segment.
Proactive and Reactive Measures: Both proactive and reactive measures are necessary. Proactive measures include targeted marketing, tenure-based incentives, and financial education. Reactive measures include reactivation campaigns and customer feedback mechanisms.
Continuous Monitoring and Improvement: Continuous monitoring and improvement of customer relationships and churn rates are essential. This involves regularly collecting customer feedback, analyzing data, and refining strategies to optimize results.
