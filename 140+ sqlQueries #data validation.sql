/*	Data Validation of the project- 'HR Data Analysis'	*/
-- 140+ Advance SQL Queries. 

with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)	-- CTE
-- Note: Refer above CTE 
	
-----------------------------------------------------------
/* KPIS */ 

	-- for CURRENT EMPLOYEES
	
-- Salary Budget 
select  round(sum(hr.yearly_package_rs)/1000000000, 2) as salary_budget
from hr
where hr.attrition_label = 'Current Employees';

-- employees count
select 'Current employees' as employee_status, count(hr.emp_id) from hr
where hr.attrition_label = 'Current Employees';

-- work life balance ratings
select 'work life balance' as employee_status, 
	round(avg(hr.work_life_balance_rating) , 2 ) as avgg_rating from hr
where hr.attrition_label = 'Current Employees'; 

-- job satisfaction ratings
select 'job satisfaction' , 
	round(avg(hr.job_satisfaction_rating),2 ) as avgg_rating from hr
where hr.attrition_label = 'Current Employees';

-- attrition %

/*
t1 as(
	select count(hr.emp_id) all_e from hr
), 
t2 as(
	select count(hr.emp_id) x_e from hr
	where hr.attrition = 'Yes'
)
*/		-- NOTE : add this CTE to our 'hr' CTE 

select ‘attrition %’, (x_e/all_e)*100 as outputt from t1, t2




	-- for Ex-EMPLOYEES

-- Salary Budget for Ex-emp
select  round(sum(hr.yearly_package_rs)/1000000, 2) as salary_budget_mn
from hr
where hr.attrition_label = 'Ex-Employees';


-- employees count 
Select 'Ex employees' as employee_status, count(hr.emp_id) from hr
where hr.attrition_label = 'Ex-Employees';


--  avg  rating of work life balance for Ex-employees
select 'work life balance' as rating, 
	round(avg(hr.work_life_balance_rating) , 2 ) as avgg_rating from hr
where hr.attrition_label = 'Ex-Employees';


--  avg  rating of job satisfaction for EX-employees
select 'job satisfaction' , 
	round(avg(hr.job_satisfaction_rating),2 ) as avgg_rating from hr
where hr.attrition_label = 'Ex-Employees';


 -- ------------------------------------------------------------------
 
 /*Employees by Education degree*/
 
 	-- For  current employees
 
-- used CTE =>
/*

with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)
,
female as
(
select hr.education ed, count(*) as female_countt
from hr
where hr.attrition ='No'  and hr.gender ='Female'
group by hr.education 
order by female_countt desc
), 
male as
(
select hr.education ed, count(*) as male_countt
from hr
where hr.attrition ='No'  and hr.gender ='Male'
group by hr.education 
order by male_countt desc
) ,

j as
(
	select male.ed Education, male.male_countt male, female.female_countt female
	from 
	male join female on male.ed = female.ed
)
*/

select *, (j.male + j.female) as Total
from j


	-- for Ex-Employees

/*
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)
,
female as
(
select hr.education ed, count(*) as female_countt
from hr
where hr.attrition ='Yes'  and hr.gender ='Female'
group by hr.education 
order by female_countt desc
)
,
male as
(
select hr.education ed, count(*) as male_countt
from hr
where hr.attrition ='Yes'  and hr.gender ='Male'
group by hr.education 
order by male_countt desc
)

,

j as
(
	select male.ed Education, male.male_countt male, female.female_countt female
	from 
	male join female on male.ed = female.ed
)

*/
select *, (j.male + j.female) as Total
from j

-- -----------------------------------------------------------------
 /*Employees by Job Role*/

-- For current employees
with 
male as (
	select job_role roles, count(*) males from employees
	where 
	gender = 'Male' and attrition = 'No'
	group by job_role
	
),

female as(
	select job_role roles, count(*) females from employees
	where 
	gender = 'Female' and attrition = 'No'
	group by job_role
	
),

joint as
(
	select male.*, female.females from
	male join female on male.roles = female.roles
)

select *, (joint.males + joint.females) as Total
from  joint
order by Total desc;


-- For Ex-Employees

with 
male as (
	select job_role roles, count(*) males from employees
	where 
	gender = 'Male' and attrition = 'Yes'
	group by job_role
	
),

female as(
	select job_role roles, count(*) females from employees
	where 
	gender = 'Female' and attrition = 'Yes'
	group by job_role
	
),

joint as
(
	select male.*, female.females from
	male join female on male.roles = female.roles
)

select *, (joint.males + joint.females) as Total
from  joint
order by Total desc;


-- -------------------------------------------------------------
 /*Salary Budget % by Departments */
 
	-- For current Employees
 with 
tbl as
(
	select e.employee_id as eid, e.department, s.yearly_package_rs as pkg
	from employees as e join salary as s 
	on e.employee_id=s.emp_id
	where e.attrition = 'No'
),

allbudget as(
	select  sum(pkg) as alll from tbl
),

d as (
	select department, sum(pkg) as dept from tbl
	group by department
)	
--CTE

select d.department as departments, round((d.dept / allbudget.alll)*100, 2) budget_percent 
from d, allbudget



	-- For Ex-employees
with 
tbl as
(
	select e.employee_id as eid, e.department, s.yearly_package_rs as pkg
	from employees as e join salary as s 
	on e.employee_id=s.emp_id
	where e.attrition = 'Yes'
),

allbudget as(
	select  sum(pkg) as alll from tbl
),

d as (
	select department, sum(pkg) as dept from tbl
	group by department
)


select d.department as departments, round((d.dept / allbudget.alll)*100, 2) budget_percent
from d, allbudget



-- -------------------------------------------------------------
 /* Employees % by gender */
 
 
--	For current employees
with
total as(
	select count(*)*1.0 as allcount from employees
	where attrition_label = 'Current Employees'
),

eachh as(
	select gender, count(*)*1.0 as empcount from employees
	where attrition_label = 'Current Employees'
	group by gender
)


select eachh.*, round((eachh.empcount/total.allcount)*100, 2) as emp_percent
from eachh, total
 
 
 
 --	For Ex-employees
with
total as(
	select count(*)*1.0 as allcount from employees
	where attrition_label = 'Ex-Employees'
),

eachh as(
	select gender, count(*)*1.0 as empcount from employees
	where attrition_label = 'Ex-Employees'
	group by gender
)


select eachh.*, round((eachh.empcount/total.allcount)*100, 2) as emp_percent
from eachh, total;





-- -------------------------------------------------------------
 /* Employees % by Training months */


--	For current employees
with
tbl as (
	select e.employee_id as ids, s.training_months as Training_months, e.attrition_label as al
	from 
	employees as e join salary as s on e.employee_id = s.emp_id
	where e.attrition_label ='Current Employees'
),

total as(
	select count(*)*1.0 as tcount from tbl
	
),

eachh as(
	select tbl.Training_months, count(*) as empcount from tbl
	where tbl.al = 'Current Employees'
	group by tbl.Training_months
)

select eachh.*, round(((eachh.empcount*1.0)/total.tcount)*100, 2) as emp_percent
from eachh, total
order by  emp_percent desc;




--	For Ex-employees
with
tbl as (
	select e.employee_id as ids, s.training_months as Training_months, e.attrition_label as al
	from 
	employees as e join salary as s on e.employee_id = s.emp_id
	where e.attrition_label ='Ex-Employees'
),

total as(
	select count(*)*1.0 as tcount from tbl
	
),

eachh as(
	select tbl.Training_months, count(*) as empcount from tbl
	where tbl.al = 'Ex-Employees'
	group by tbl.Training_months
)

select eachh.*, round(((eachh.empcount*1.0)/total.tcount)*100, 2) as emp_percent
from eachh, total
order by  emp_percent desc;



-- -------------------------------------------------------------
 /* Employees % by Marital Status */
 
 
--	For Current employees
with
tbl as (
	select e.employee_id as ids, s.marital_status as status, e.attrition_label as al
	from 
	employees as e join salary as s on e.employee_id = s.emp_id
	where e.attrition_label ='Current Employees'
),
total as(
	select count(*)*1.0 as tcount from tbl
	
),
eachh as(
	select tbl.status, count(*) as empcount from tbl
	group by tbl.status
)

select eachh.*, round(((eachh.empcount*1.0)/total.tcount)*100, 2) as emp_percent
from eachh, total
order by  emp_percent desc;


--	For Ex-employees
with
tbl as (
	select e.employee_id as ids, s.marital_status as status, e.attrition_label as al
	from 
	employees as e join salary as s on e.employee_id = s.emp_id
	where e.attrition_label ='Ex-Employees'
),
total as(
	select count(*)*1.0 as tcount from tbl
	
),
eachh as(
	select tbl.status, count(*) as empcount from tbl
	group by tbl.status
)

select eachh.*, round(((eachh.empcount*1.0)/total.tcount)*100, 2) as emp_percent
from eachh, total
order by  emp_percent desc;

-- -------------------------------------------------------------
 /* Employees by performance */

--	For Current Employees
with
tbl as (
	select e.employee_id as ids, s.performance as pp, e.attrition_label as al
	from 
	employees as e join salary as s on e.employee_id = s.emp_id
	where e.attrition_label ='Current Employees'
)

select tbl.pp as performance, count(*) as empcount from tbl
group by performance
order by empcount desc;


--	For Ex-Employees
with
tbl as (
	select e.employee_id as ids, s.performance as pp, e.attrition_label as al
	from 
	employees as e join salary as s on e.employee_id = s.emp_id
	where e.attrition_label ='Ex-Employees'
)

select tbl.pp as performance, count(*) as empcount from tbl
group by performance
order by empcount desc;


-- -------------------------------------------------------------
 /* Employees by Age gropu and gender */


--	For Current Employees 
with
males as (
	select age_group as ag, count(*) as male
	from employees
	where attrition_label ='Current Employees' and gender = 'Male'
	group by ag
),
females as (
	select age_group as ag, count(*) as female
	from employees
	where attrition_label ='Current Employees' and gender = 'Female'
	group by ag
), 
joint as(
	select m.*, f.female
	from males as m join females as f
	on m.ag = f.ag
)

select *, (male+female) as  totalcount
from joint
order by totalcount desc;



--	For Ex-Employees 
with
males as (
	select age_group as ag, count(*) as male
	from employees
	where attrition_label ='Ex-Employees' and gender = 'Male'
	group by ag
),
females as (
	select age_group as ag, count(*) as female
	from employees
	where attrition_label ='Ex-Employees' and gender = 'Female'
	group by ag
), 
joint as(
	select m.*, f.female
	from males as m join females as f
	on m.ag = f.ag
)

select *, (male+female) as  totalcount
from joint
order by totalcount desc;



-----------------------------------------------------------
-- For page: "Salary & payouts"

/* KPIS of Salary & Payouts*/ 

-- For Current Employees
select 'base_salary_Budget' as KPI, 
	round(sum(yearly_salary_rs)/1000000, 0) as Value_in_Millions
from hr
where attrition_label = 'Current Employees'


-- For Ex-Employees
select 'base_salary_Budget' as KPI, 
	round(sum(yearly_salary_rs)/1000000, 0) as Value_in_Millions
from hr
where attrition_label = 'Ex-Employees'


-- For Current Employees
select 'Performance_bonus_Budget' as KPI, 
	round(sum(performance_bonus_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Current Employees'


-- For Ex-Employees
select 'Performance_bonus_Budget' as KPI, 
	round(sum(performance_bonus_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Ex-Employees'

-- For Current Employees
select 'over_time_incentive_Budget' as KPI, 
	round(sum(over_time_incentive_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Current Employees'


-- For Ex-Employees
select 'over_time_incentive_Budget' as KPI, 
	round(sum(over_time_incentive_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Ex-Employees'


-- For Current Employees
select 'business_travel_allowance_Budget' as KPI, 
	round(sum(business_travel_allowance_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Current Employees'


-- For Ex-Employees
select 'business_travel_allowance_Budget' as KPI, 
	round(sum(business_travel_allowance_rs)/1000, 1) as Value_in_k
from hr
where attrition_label = 'Ex-Employees'


-- For Current Employees
select 'office_travel_allowance_Budget' as KPI, 
	round(sum(office_travel_allowance_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Current Employees'


-- For Ex-Employees
select 'office_travel_allowance_Budget' as KPI, 
	round(sum(office_travel_allowance_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Ex-Employees'


-- For Current Employees
select 'marital_allowance_Budget' as KPI, 
	round(sum(marital_allowance_rs)/1000000, 1) as Value_in_Millions
from hr
where attrition_label = 'Current Employees'


-- For Ex-Employees
select 'marital_allowance_Budget' as KPI, 
	round(sum(marital_allowance_rs)/1000, 1) as Value_in_k
from hr
where attrition_label = 'Ex-Employees'


-----------------------------------------------------------
/*Payout mattrix by a specific category*/


--  ----------------------------------------------
-- # business_travel_allowance_rs 

--1.  BTA by age_group
	
	-- for Current Employees
select age_group as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select age_group as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	


--2.  BTA by gender
	
	-- for Current Employees
select gender as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select gender as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--3.  BTA by department
	
	-- for Current Employees
select department as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select department as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--4.  BTA by job_role
	
	-- for Current Employees
select job_role as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select job_role as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--5.  BTA by job_level
	
	for Current Employees
select job_level as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by category desc;

	
	-- for Ex-Employees
select job_level as category, 
	round(sum(business_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(business_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by category desc;
	
--  ----------------------------------------------

--  ----------------------------------------------

-- # office_travel_allowance_rs 

--1.  OTA by age_group
	
	-- for Current Employees
select age_group as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select age_group as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	


--2.  OTA by gender
	
	-- for Current Employees
select gender as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select gender as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--3.  OTA by department
	
	-- for Current Employees
select department as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select department as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--4.  OTA by job_role
	
	-- for Current Employees
select job_role as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select job_role as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--5.  OTA by job_level
	
-- 	for Current Employees
select job_level as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by category desc;

	
	-- for Ex-Employees
select job_level as category, 
	round(sum(office_travel_allowance_rs)/1000000 ,2) as amount_in_Million,
	round(sum(office_travel_allowance_rs)/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by category desc;
	
--  ----------------------------------------------

--  ----------------------------------------------
-- # performance_bonus_rs 

--1.  PB by age_group
	
	-- for Current Employees
select age_group as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select age_group as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	


--2.  PB by gender
	
	-- for Current Employees
select gender as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select gender as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--3.  PB by department
	
	-- for Current Employees
select department as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select department as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--4.  PB by job_role
	
	-- for Current Employees
select job_role as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select job_role as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--5.  PB by job_level
	
-- 	for Current Employees
select job_level as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by category desc;

	
	-- for Ex-Employees
select job_level as category, 
	round(sum(performance_bonus_rs )/1000000 ,2) as amount_in_Million,
	round(sum(performance_bonus_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by category desc;
	
--  ----------------------------------------------

--  ----------------------------------------------
-- # over_time_incentive_rs 

--1.  OT by age_group
	
	-- for Current Employees
select age_group as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select age_group as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	


--2.  OT by gender
	
	-- for Current Employees
select gender as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select gender as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--3.  OT by department
	
	-- for Current Employees
select department as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select department as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--4.  OT by job_role
	
	-- for Current Employees
select job_role as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select job_role as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--5.  OT by job_level
	
-- 	for Current Employees
select job_level as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by category desc;

	
	-- for Ex-Employees
select job_level as category, 
	round(sum(over_time_incentive_rs )/1000000 ,2) as amount_in_Million,
	round(sum(over_time_incentive_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by category desc;
	
--  ----------------------------------------------


--  ----------------------------------------------
-- # marital_allowance_rs 

--1.  MA by age_group
	
	-- for Current Employees
select age_group as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select age_group as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	


--2.  MA by gender
	
	-- for Current Employees
select gender as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select gender as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--3.  MA by department
	
	-- for Current Employees
select department as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select department as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
-- 4.  MA by job_role
	
	-- for Current Employees
select job_role as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select job_role as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--5.  MA by job_level
	
	-- 	for Current Employees
select job_level as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by category desc;

	
	-- for Ex-Employees
select job_level as category, 
	round(sum(marital_allowance_rs )/1000000 ,2) as amount_in_Million,
	round(sum(marital_allowance_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by category desc;
	
--  ----------------------------------------------


--  ----------------------------------------------
-- # yearly_salary_rs #base salary

--1.  YBS by age_group
	
	-- for Current Employees
select age_group as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select age_group as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	


--2.  YBS by gender
	
	-- for Current Employees
select gender as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
--	for Ex-Employees
select gender as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--3.  YBS by department
	
	-- for Current Employees
select department as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select department as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
-- 4.  YBS by job_role
	
	-- for Current Employees
select job_role as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by amount_in_Million desc;

	
	-- for Ex-Employees
select job_role as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by amount_in_Million desc;	
	
	
	
--5.  YBS by job_level
	
	-- 	for Current Employees
select job_level as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Current Employees'
group by category
order by category desc;

	
	-- for Ex-Employees
select job_level as category, 
	round(sum(yearly_salary_rs )/1000000000 ,2) as amount_in_Billion,
	round(sum(yearly_salary_rs )/1000000 ,2) as amount_in_Million,
	round(sum(yearly_salary_rs )/1000 ,2) as amount_in_k
from hr
where attrition_label = 'Ex-Employees'
group by category
order by category desc;
	

--  ----------------------------------------------

------------------------------------------------------------------------
-- For page: "Employees' Performance"

/* Employees by Performance parameters (listed as-) */ 


with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)

-----------------------------------------------------------



	-- 1. range_work_x

-- For Current Employees
select range_work_x as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;


-- For Ex-Employees
select range_work_x as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 2. range_company_switches

-- For Current Employees
select range_company_switches as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select range_company_switches as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 3. range_years_at_company

-- For Current Employees
select range_years_at_company as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select range_years_at_company as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 4. range_years_in_curr_role

-- For Current Employees
select range_years_in_curr_role as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select range_years_in_curr_role as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 5. range_years_since_last_promotion

-- For Current Employees
select range_years_since_last_promotion as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select range_years_since_last_promotion as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 6. range_salary_hike

-- For Current Employees
select range_salary_hike as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select range_salary_hike as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 7. job_level

-- For Current Employees
select job_level as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by performance_parameter desc;

-- For Ex-Employees
select job_level as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by performance_parameter desc;


-- -------------------------------------------------------------------------

	-- 8. performance

-- For Current Employees
select performance as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select performance as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 9. over_time

-- For Current Employees
select over_time as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select over_time as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------

	-- 10. range_yearly_package

-- For Current Employees
select range_yearly_package as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Current Employees'
group by  performance_parameter
order by employees_count desc;

-- For Ex-Employees
select range_yearly_package as performance_parameter, 
	count(*) as  employees_count
from hr
where attrition_label = 'Ex-Employees'
group by  performance_parameter
order by employees_count desc;


-- -------------------------------------------------------------------------


----------------------------------------------------------------------
-- For page: "Feedback Ratings"
		-- Chart : Feedback Breakdown



/* Employees by Rating parameter (Scale) values  (listed as-) */ 


	-- 1. work_life_balance_rating

-- For Current Employees


-- wlb curr total
select work_life_balance_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Current Employees'
group by rating_values
order by rating_values desc;


-- wlb curr male
select work_life_balance_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Current Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- wlb curr female
select work_life_balance_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Current Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;


-- For Ex-Employees


-- wlb x total
select work_life_balance_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Ex-Employees'
group by rating_values
order by rating_values desc;


-- wlb x male
select work_life_balance_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- wlb x female
select work_life_balance_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;




----------------------------------------------------

	-- 2. relationship_satisfaction_rating

-- For Current Employees


-- rs curr total
select relationship_satisfaction_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Current Employees'
group by rating_values
order by rating_values desc;


-- rs curr male
select relationship_satisfaction_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Current Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- rs curr female
select relationship_satisfaction_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Current Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;


-- For Ex-Employees


-- rs x total
select relationship_satisfaction_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Ex-Employees'
group by rating_values
order by rating_values desc;


-- rs x male
select relationship_satisfaction_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- rs x female
select relationship_satisfaction_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;






----------------------------------------------------

	-- 3. job_satisfaction_rating

-- For Current Employees


-- js curr total
select job_satisfaction_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Current Employees'
group by rating_values
order by rating_values desc;


-- js curr male
select job_satisfaction_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Current Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- js curr female
select job_satisfaction_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Current Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;


-- For Ex-Employees


-- js x total
select job_satisfaction_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Ex-Employees'
group by rating_values
order by rating_values desc;


-- js x male
select job_satisfaction_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- js x female
select job_satisfaction_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;






----------------------------------------------------

	-- 4. job_involvement_rating

-- For Current Employees


-- ji curr total
select job_involvement_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Current Employees'
group by rating_values
order by rating_values desc;


-- ji curr male
select job_involvement_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Current Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- ji curr female
select job_involvement_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Current Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;


-- For Ex-Employees


-- ji x total
select job_involvement_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Ex-Employees'
group by rating_values
order by rating_values desc;


-- ji x male
select job_involvement_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- ji x female
select job_involvement_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;





----------------------------------------------------

	-- 5. environment_satisfaction_rating

-- For Current Employees


-- es curr total
select environment_satisfaction_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Current Employees'
group by rating_values
order by rating_values desc;


-- es curr male
select environment_satisfaction_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Current Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- es curr female
select environment_satisfaction_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Current Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;


-- For Ex-Employees


-- es x total
select environment_satisfaction_rating  as rating_values,
	count(*) as totol_count
from hr
where attrition_label = 'Ex-Employees'
group by rating_values
order by rating_values desc;


-- es x male
select environment_satisfaction_rating  as rating_values,
	count(*) as male_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Male'
group by rating_values
order by rating_values desc;


-- es x female
select environment_satisfaction_rating  as rating_values,
	count(*) as female_count
from hr
where attrition_label = 'Ex-Employees' and gender = 'Female'
group by rating_values
order by rating_values desc;





-----------------------------------------------------------------------------



----------------------------------------------------------------------
-- For page: "Feedback Ratings"
		-- Chart : Average Rating Comparison (by different Categories)



/* Average rating of a Feedback parameter by a Category  */ 

-- ----------------------------------------------------


	-- 1. Avg Work Life Balance		# For Current Employees

-- 1.1 Avg. work_life_balance_rating by department
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select department as category, round(avg(work_life_balance_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select department as category, round(avg(work_life_balance_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


-- 1.2 Avg. work_life_balance_rating by age_group
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select age_group as category, round(avg(work_life_balance_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select age_group as category, round(avg(work_life_balance_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


-- 1.3 Avg. work_life_balance_rating by job_level
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_level as category, round(avg(work_life_balance_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_level as category, round(avg(work_life_balance_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by female.category desc;


-- 1.4 Avg. work_life_balance_rating by job_role
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_role as category, round(avg(work_life_balance_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_role as category, round(avg(work_life_balance_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


-- 1.5 Avg. work_life_balance_rating by gender
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)

select gender as category, round(avg(work_life_balance_rating), 2 ) as avg_rating
from hr
where attrition_label ='Current Employees'
group by category
order by avg_rating desc;



-- ----------------------------------------------------


	-- 2. Avg Relationship Satisfaction Rating	# For Current Employees
	
	
--  2.1 Avg. relationship_satisfaction_rating   by department
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select department as category, round(avg(relationship_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select department as category, round(avg(relationship_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


--  2.2 Avg. relationship_satisfaction_rating   by age_group
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select age_group as category, round(avg(relationship_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select age_group as category, round(avg(relationship_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


--	2.3 Avg. relationship_satisfaction_rating   by job_level
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_level as category, round(avg(relationship_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_level as category, round(avg(relationship_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by female.category desc;


--	2.4 Avg. relationship_satisfaction_rating   by job_role
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_role as category, round(avg(relationship_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_role as category, round(avg(relationship_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;

--	2.5 Avg. relationship_satisfaction_rating   by gender
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)

select gender as category, round(avg(relationship_satisfaction_rating), 2 ) as avg_rating
from hr
where attrition_label ='Current Employees'
group by category
order by avg_rating desc;






-- ----------------------------------------------------


	-- 3. Avg Job Involvement Rating		# For Current Employees
	
	
--  3.1 Avg. job_involvement_rating  by department
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select department as category, round(avg(job_involvement_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select department as category, round(avg(job_involvement_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


--  3.2 Avg. job_involvement_rating  by age_group
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select age_group as category, round(avg(job_involvement_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select age_group as category, round(avg(job_involvement_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;

--	3.3 Avg. job_involvement_rating	by job_level
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_level as category, round(avg(job_involvement_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_level as category, round(avg(job_involvement_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by female.category desc;


--	3.4 Avg. job_involvement_rating  by job_role
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_role as category, round(avg(job_involvement_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_role as category, round(avg(job_involvement_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;

--	3.5 Avg. job_involvement_rating	by gender
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)

select gender as category, round(avg(job_involvement_rating), 2 ) as avg_rating
from hr
where attrition_label ='Current Employees'
group by category
order by avg_rating desc;





-- ----------------------------------------------------


	-- 4. Avg Job Satisfaction Rating		# For Current Employees
	
	
--  4.1 Avg.  job_satisfaction_rating  by department
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select department as category, round(avg(job_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select department as category, round(avg(job_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


--  4.2 Avg.  job_satisfaction_rating  by age_group
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select age_group as category, round(avg(job_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select age_group as category, round(avg(job_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;

--	4.3 Avg.  job_satisfaction_rating  by job_level
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_level as category, round(avg(job_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_level as category, round(avg(job_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by female.category desc;


--	4.4 Avg.  job_satisfaction_rating  by job_role
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_role as category, round(avg(job_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_role as category, round(avg(job_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;

--	4.5 Avg.  job_satisfaction_rating  by gender
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)

select gender as category, round(avg(job_satisfaction_rating), 2 ) as avg_rating
from hr
where attrition_label ='Current Employees'
group by category
order by avg_rating desc;

-- ----------------------------------------------------


	-- 5. Avg Environment Satisfaction Rating	# For Current Employees
	
	
--  5.1 Avg. environment_satisfaction_rating  by department
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select department as category, round(avg(environment_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select department as category, round(avg(environment_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;


--  5.2 Avg. environment_satisfaction_rating  by age_group
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select age_group as category, round(avg(environment_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select age_group as category, round(avg(environment_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;

--	5.3 Avg. environment_satisfaction_rating	by job_level
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_level as category, round(avg(environment_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_level as category, round(avg(environment_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by female.category desc;


--	5.4 Avg. environment_satisfaction_rating  by job_role
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
), 
male as(
	select job_role as category, round(avg(environment_satisfaction_rating), 2) as male_avg_rating
	from hr
	where gender = 'Male' and attrition_label = 'Current Employees'
	group by category	
),
female as(
	select job_role as category, round(avg(environment_satisfaction_rating), 2) as female_avg_rating
	from hr
	where gender = 'Female' and attrition_label = 'Current Employees'
	group by category	
)

select female.*, male.male_avg_rating,
	round( (female.female_avg_rating + male.male_avg_rating)/2, 2) as total_avg_rating
from male join female on male.category = female.category
order by total_avg_rating desc;

--	5.5 Avg. environment_satisfaction_rating	by gender
with 
hr as (
	
	select e.*, s.*, r.* from 
	employees as e join salary as s on e.employee_id=s.emp_id
	join ratings as r on e.employee_id=r.e_id
)

select gender as category, round(avg(environment_satisfaction_rating), 2 ) as avg_rating
from hr
where attrition_label ='Current Employees'
group by category
order by avg_rating desc;


-- ----------------------------------------------------------------------
-- Data Validation is Done!! ... :)