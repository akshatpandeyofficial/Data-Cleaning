-- Exploratory data Analysis

select * from layoff_staging2;
 
alter table layoff_staging2
drop column row_num;


select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;


select max(total_laid_off) 
from layoff_staging2;

select * from layoff_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select * from layoff_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select max(`date`),min(`date`)
from layoff_staging2;


select industry , sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select country , sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoff_staging2
group by year(`date`)
order by 1 desc;

select stage , sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc;


-- ROLLING TOTAL
select substring(`date`,1,7) AS `Month` , sum(total_laid_off)
from layoff_staging2
where substring(`date`,1,7) IS NOT NULL
group by `month`
order by 1 asc;

with Rolling_total_cte as 
(select substring(`date`,1,7) AS `Month` , sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) IS NOT NULL
group by `month`
order by 1 asc
)
select `month`, total_off, sum(total_off) over (order by `month` ) as rolling_total 
from Rolling_total_cte;

select company , year(`date`), sum(total_laid_off)
from  layoff_staging2
group by company , year(`date`)
order by 3 desc ;

with Company_year (company,years,total_laid_off) as 
(select company , year(`date`), sum(total_laid_off)
from  layoff_staging2
group by company , year(`date`)
), company_year_rank as 
(select * , dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from company_year
where years is NOT NULL
order by ranking)

select * from company_year_rank
where ranking<=5
order by ranking ;