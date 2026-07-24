-- 1. Remove Duplicates
-- 2. Standardization
-- 3. Null values or Blank Values 
-- 4 Remove Any Column if not Needed 



select * from layoffs;

create table layoff_staging like layoffs;
select * from layoff_staging;

insert layoff_staging
select * from layoffs;

select * from layoff_staging;


with CTE_Clean as (
select*,
row_number () over (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country , funds_raised_millions ) as row_num
from layoff_staging
)
select* from CTE_Clean where row_num >1;  

-- DATA CLEANING
CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoff_staging2;

insert into layoff_staging2
select*,
row_number () over (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country , funds_raised_millions ) as row_num
from layoff_staging;

select * from layoff_staging2; 

select * from layoff_staging2 where row_num >1;
delete  from layoff_staging2 where row_num>1;


-- Standardizing data


select* from layoff_staging2;

-- Trimming Spaces from company Column
select trim(company)
from layoff_staging2;

update layoff_staging2 
set company = trim(company);

-- cleaning redundant data from industry 
select DISTINCT industry from layoff_staging2;
select * from layoff_staging2
where industry LIKE 'crypto%';

update layoff_staging2
set industry = 'Crypto'
where industry LIKE 'Crypto%';



select distinct Country from layoff_staging2
order by 1;


select distinct country , trim(trailing '.' from country);

update layoff_staging2
set country = trim(trailing  '.' from country)
where country  like 'United States%'; 


update layoff_staging2
set `date` = str_to_date(`date` , '%m/%d/%Y');

select * from layoxff_staging2;


ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;

-- Handling Null values 
select * from layoff_staging2
where total_laid_off  IS NULL
AND percentage_laid_off is NULL;


select * from layoff_staging2 
where industry is NULL
OR industry = '';

Update layoff_staging2
set industry = NULL 
where industry = '';


select * from  layoff_staging2 t2
JOIN layoff_staging2 t2
	 ON t1.company = t2.company
where(t1.industry is NULL or t1. industry = '')
AND t2.industry is NOT NULL;

update layoff_staging2 t1
join layoff_staging2 t2
ON t1.company = t2.company
set t1.industry = t2.industry 
where(t1.industry is NULL)
AND t2.industry is NOT NULL;

select * from layoff_staging2
where total_laid_off is NULL
AND percentage_laid_off is NULL;

delete from layoff_staging2
where total_laid_off is NULL
AND percentage_laid_off is NULL;

ALTER Table layoff_staging2
DROP Column row_num;
