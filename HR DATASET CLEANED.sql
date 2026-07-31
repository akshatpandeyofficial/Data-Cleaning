select * from messy_hr_data;

-- creating new table For staging
create table hr_fix
select * from messy_hr_data;

-- select statement
select * from hr_fix;

-- alter table 

alter table hr_fix
ADD Column ID Int auto_increment Primary key;


-- Removing Duplicates
with Dupe_cte as (
select *,
row_number() over(
partition by name , age , salary, department order by id ) as roww_num
from hr_fix)
delete from hr_fix
where ID IN (
select ID from 
Dupe_cte where roww_num >1);


-- Update Null Values
update hr_fix
set age = 0 
where age is NULL;

select distinct age from hr_fix;
update hr_fix
set age = 
case
when age = 'thirty' then '30'
else age 
end;

select distinct salary from hr_fix;
update hr_fix
set salary = 
case
 when salary = 'SIXTY THOUSAND' then '60000'
 else salary
 end;
 
 update hr_fix
 set salary = 0
 where salary = 'nan';

update hr_fix
 set `Phone Number` = NULL
 where `Phone Number` = 'nan'
 and `Phone Number` = '0' ;

-- Updating cloumn 
update hr_fix
set name = upper(name),
salary = trim(salary),
gender = trim(gender),
Department = trim(department);

select * from hr_fix 
where Email  NOT LIKE '%@%.%';

delete from hr_fix
where email  NOT LIKE '%@%.%';

select distinct `Joining Date` from hr_fix;

UPDATE hr_fix
SET `Joining Date` = CASE
    WHEN `Joining Date` LIKE '%,%' THEN
        STR_TO_DATE(`Joining Date`, '%M %e, %Y')

    WHEN `Joining Date` LIKE '%/%/%' AND LEFT(`Joining Date`,4) REGEXP '^[0-9]{4}$' THEN
        STR_TO_DATE(`Joining Date`, '%Y/%m/%d')

    WHEN `Joining Date` LIKE '%/%/%' THEN
        STR_TO_DATE(`Joining Date`, '%m/%d/%Y')

    WHEN `Joining Date` LIKE '%-%-%' THEN
        STR_TO_DATE(`Joining Date`, '%m-%d-%Y')

    WHEN `Joining Date` LIKE '%.%.%' THEN
        STR_TO_DATE(`Joining Date`, '%Y.%m.%d')

    ELSE NULL
END;

SELECT DISTINCT `Phone Number`
FROM hr_fix;

UPDATE hr_fix
SET `Phone Number` = NULL
WHERE `Phone Number` = '0';

update hr_fix
SET Age = NULL
WHERE Age = '0';

-- Update Column Datatype

alter Table hr_fix
modify Age INT;

ALTER TABLE hr_fix
MODIFY `Joining Date` DATE;

ALTER TABLE hr_fix
MODIFY salary INT;

-- Droping ID Column
ALTER TABLE hr_fix
DROP COLUMN ID;

create table final_hr_Cleansheet
select * from hr_fix;

-- Final Cleaned Dataset
select * from final_hr_cleansheet;