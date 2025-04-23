SELECT * FROM project.`bank customer churn data.zip`;
Rename table `bank customer churn data.zip` to Bank_Customer_Churn;
select * from bank_customer_churn;

-- To check for duplicate
select creditscore, balance, tenure, numofproducts, hascrcard, age, estimatedsalary, count(*) from bank_customer_churn
group by creditscore, balance, tenure, numofproducts,hascrcard, age, estimatedsalary
having count(*) > 1;

-- Aggregate
select count(surname) as total_customers from bank_customer_churn;

select count(gender) as total_Male from bank_customer_churn where gender = "Male";
select count(gender) as total_female from bank_customer_churn where gender = "Female";

select exited, count(surname) as total_churned from bank_customer_churn 
where exited = 1
group by exited;

select exited, count(surname) as total_retained from bank_customer_churn 
where exited = 0
group by exited;

select * from bank_customer_churn;
-- 1. Understanding Customer Churn
-- ✅ What attributes  are most common among churners?
-- gender
select gender, count(*) as churn_count from bank_customer_churn
where Exited = 1
group by gender
order by churn_count desc;

-- Geography
select geography, count(*) as total_churn from bank_customer_churn
where Exited = 1
group by geography
order by total_churn desc;

Alter table bank_customer_churn
 add column Age_group text after Age;
 
 set SQL_SAFE_UPDATES=0;
 update bank_customer_churn
 set Age_group = case
						when age between 0 and 20 then "Youth"
						when age between 21 and 41 then "Young_Adult"
						when age between 45 and 64 then "Middle_Age"
						when age between 63 and 83 then "Seniors"
						else "Elderly"
						end;

-- Age_group
select age_group, count(*) as total_churn from bank_customer_churn
where Exited = 1
group by age_group
order by total_churn desc;

-- HasCrcard
with cte as (select exited, hascrcard, case
						when hascrcard = 1 then "HasCard"
                        else "NoCard"
                        end as card from bank_customer_churn where exited = 1)
select card, count(hascrcard) as total_churn from cte group by card;

-- NumofProducts
with cte as (select exited, NumOfProducts, case
											when numofproducts > 1 then "multiple_products"
											else "single_product"
											end as product_attribute from bank_customer_churn where exited = 1)
select product_attribute, count(NumOfProducts) as total_churn from cte group by product_attribute;

 -- Tenure
 with cte as (select Tenure,  case
													when tenure between 0 and 3 then"Low_Tenure"
													when tenure between 4 and 7 then "Mid_Tenure"
													else "High_Tenure"
													end as Tenure_group from bank_customer_churn where exited = 1)
select tenure_group, count(*) as Churned_Customers from cte group by tenure_group order by tenure_group desc;

-- ✅ What is the overall churn rate? How does it vary across demographics? (Churn rate is the % of customers who have left)
-- Overall Churn-rate
with cte as (select count(*) as total_count, sum(exited) as total_churned  from bank_customer_churn)
select concat(round((total_churned * 100/total_count), 2), "% ") as percentage_Churn from cte;

-- Geography
select Geography, concat(round(count(Geography)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by Geography;


-- Gender
select Gender, concat(round(count(Gender)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by Gender;

-- Age_group
select Age_group, concat(round(count(Age_group)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by Age_group
order by percentage desc;

-- Estimatedsalary
with cte as (select EstimatedSalary, Exited, Count(*) as total_customers, case
															when EstimatedSalary < 50000 then "Low"
                                                            when EstimatedSalary between 50000 and 100000 then "Medium"
                                                            when EstimatedSalary > 100000 then "High"
                                                            End as Estimated_Level from bank_customer_churn group by EstimatedSalary, Exited)
select estimated_level, sum(exited) as churned_customers from cte where exited = 1 group by Estimated_level, exited;

-- Isactivemember
select case when IsActiveMember= 1 then "Active" else "Not_Active" end as Active_count,
 concat(round(count(isactivemember)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by IsActiveMember;

-- ✅ Are customers with higher balances more likely to stay or leave?
select surname, max(balance) as highest_balance, exited from bank_customer_churn
group by surname, exited
order by highest_balance desc
limit 15;

-- 2. Customer Segmentation & Behavioral Analysis
select * from bank_customer_churn;
-- ✅ Can customers be grouped into different segments based on their banking behavior?
select concat(Numofproducts+HasCrCard+IsActivemember) from bank_customer_churn;

alter table bank_customer_churn
add column NHI int after isactivemember;

 set SQL_SAFE_UPDATES = 0;
 Update bank_customer_churn
 set NHI = concat(Numofproducts+ HasCrCard+IsActivemember);
 
with cte as (select *, 
 ntile(3) over (order by balance) as balance_range,
 ntile(3) over (order by creditscore) as credit_range,
 ntile(3) over (order by NHI) as NHI_range
 from bank_customer_churn),
 Groupp as 
 (select (balance_range + credit_range + NHI_range) as sum_score from cte)
 select  case 
					when sum_score = 9 then "Elite Customers"
                    when sum_score between 7 and 8 then "Reliable_Customers"
                    when sum_score between 5 and 6 then "Moderate_customers"
                    when sum_score <= 4 then "Low_ValueCustomers"
                    end as customer_segment , count(*) as Customer_Count from groupp
group by customer_segment
order by customer_count desc;
 
 select * from bank_customer_churn;
 -- ✅ How do high-value customers compare to low-value customers?
with cte as (select *, 
 ntile(3) over (order by balance) as balance_range,
 ntile(3) over (order by creditscore) as credit_range,
 ntile(3) over (order by NHI) as NHI_range
 from bank_customer_churn),
 Groupp as 
 (select (balance_range + credit_range + NHI_range) as sum_score from cte)
 select case
		when sum_score between 0 and 5 then "Low_value_Customer"
        else "High_value_customer"
        end as Customer_Rating, count(*) as Customers from groupp
group by customer_rating;

-- ✅ What proportion of churned customers had multiple products vs. single products?
with cte as (select exited, NumOfProducts, case
											when numofproducts > 1 then "multiple_products"
											else "single_product"
											end as product_proportion from bank_customer_churn)
select product_proportion, concat(round(sum(exited)*100/(select count(*) from cte where exited = 1),2), "% ") as churned from cte 
where exited = 1
group by product_proportion;

-- 3. Geographic & Demographic Trends
-- ✅ How does churn rate differ by country (France, Spain, Germany)?
-- Geography
select Geography, concat(round(count(Geography)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by Geography;

-- ✅ Do older customers have a lower churn rate compared to younger customers?
select * from bank_customer_churn;
select Age_group, concat(round(count(Age_group)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by Age_group;

-- ✅ Is there a difference in churn between male and female customers?
select Gender, concat(round(count(Gender)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by Gender;

-- 4. Customer Engagement & Activity Levels
-- ✅ Do inactive members have a higher churn rate than active member
select case when IsActiveMember= 1 then "Active" else "Not_Active" end as Active_count,
 concat(round(count(isactivemember)*100/(select count(*) from bank_customer_churn where Exited = 1), 2), "% ") as Percentage from bank_customer_churn
where Exited = 1
group  by IsActiveMember;

-- ✅ What is the relationship between credit score and churn?
with cte as (select *, case when creditscore between 350 and 500 then "Low"
								when creditscore between 551 and 701 then "Medium"
								else "High" end as creditscore_group from bank_customer_churn where exited = 1)
select creditscore_group, concat(round((count(creditscore_group)*100/(select count(*) from cte where exited = 1)),2), "% ")
as churn_rate from cte 
where exited = 1
group by creditscore_group;
 
-- ✅ Are customers with credit cards less likely to churn?
with cte as (select exited, hascrcard, case
						when hascrcard = 1 then "credit_card"
                        else "No_creditcard"
                        end as card from bank_customer_churn where exited = 1)
select card, concat(round((count(hascrcard)*100/(select count(*) from cte where exited = 1)),2), "% ") as churn_rate from cte 
where exited = 1
group by card;
 
-- 5. Financial & Revenue Insights
-- ✅ What is the average balance and salary of churned vs. retained customers?
with cte as (select concat("$ ", round(avg(Estimatedsalary),2)) as avg_salary, concat("$ ", round(avg(balance),2)) as avg_balance, exited, case 
															 when exited = 1 then "churned"
                                                             else "retained"
                                                             end as churned_retained from bank_customer_churn
                                                             group by exited)
select avg_balance, avg_salary, churned_retained from cte;

with cte as (select concat("$ ",round(avg(Estimatedsalary),2)) as avg_salary, concat("$ ",round(avg(balance),2)) as avg_balance, exited, case 
															 when exited = 1 then "churned"
                                                             else "retained"
                                                             end as churned_retained from bank_customer_churn
                                                             group by exited)
select avg_balance, avg_salary, churned_retained from cte where churned_retained = "churned";

with cte as (select concat("$ ", round(avg(Estimatedsalary),2)) as avg_salary, concat("$ ", round(avg(balance),2)) as avg_balance, exited, case 
															 when exited = 1 then "churned"
                                                             else "retained"
                                                             end as churned_retained from bank_customer_churn
                                                             group by exited)
select avg_balance, avg_salary, churned_retained from cte where churned_retained = "retained";

-- ✅ Are customers with lower credit scores more likely to churn?
with cte as (select *, case when creditscore between 350 and 500 then "Low"
								when creditscore between 551 and 701 then "Medium"
								else "High" end as creditscore_group from bank_customer_churn where exited = 1)
select creditscore_group, concat(round((count(creditscore_group)*100/(select count(*) from cte where exited = 1)),2), "% ")
as churn_rate from cte 
where exited = 1
group by creditscore_group;

-- ✅ Does tenure (years with the bank) influence churn rates?
with cte as (select count(*) as total_count, exited, Tenure,  case
													when tenure between 0 and 3 then"Low_Tenure"
													when tenure between 4 and 7 then "Mid_Tenure"
													else "High_Tenure"
													end as Tenure_group from bank_customer_churn group by exited, tenure)
select tenure_group, concat(round(count(tenure_group) * 100/(select count(*) from cte where exited = 1),2), "% ") as Churned_rate from cte
where exited = 1
group by tenure_group;
