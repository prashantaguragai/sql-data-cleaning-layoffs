ALTER TABLE layoffs_staging2 MODIFY COLUMN date TEXT;

INSERT INTO layoffs_staging2
SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, date, stage, country, funds_raised_millions
    ) AS row_num
FROM layoffs_staging;

SELECT COUNT(*) FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2 
WHERE row_num > 1 ;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2;

SELECT DISTINCT company, TRIM(company)
FROM layoffs_staging2
WHERE company != TRIM(company);

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Check industry values
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

update layoffs_staging2
set industry ='Crypto'
where industry like 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

update layoffs_staging2
set country = 'United states'
where country like 'united states%';

SELECT DISTINCT date
FROM layoffs_staging2
ORDER BY date;

update layoffs_staging2
set date = str_to_date(DATE, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

-- Check NULL/blank in key columns
select *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
where industry is null or industry='';

SELECT * 
FROM layoffs_staging2
where company ='Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company= t2.company
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

update  layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company= t2.company
set t1.industry=t2.industry
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

update  layoffs_staging2
set industry = null
where industry ='';

alter table layoffs_staging2 DROP COLUMN row_num;


-- Exploratory data analysis

 select *
 from layoffs_staging2;
 
 select max(total_laid_off), max(percentage_laid_off)
 from layoffs_staging2;
 
 select *
 from layoffs_staging2
 where percentage_laid_off =1
 Order by funds_raised_millions desc;
 
  select company, sum(total_laid_off)
 from layoffs_staging2
 group by company
 order by 2 desc;
 
  select min(`date`), max(`date`)
 from layoffs_staging2;
 
  select industry, sum(total_laid_off)
 from layoffs_staging2
 group by industry
 order by 2 desc;
 
  select country, sum(total_laid_off)
 from layoffs_staging2
 group by country
 order by 2 desc;
 
  select year(`date`), sum(total_laid_off)
 from layoffs_staging2
 group by year(`date`)
 order by 1 desc;
 
  select stage, sum(total_laid_off)
 from layoffs_staging2
 group by stage
 order by 2 desc;
 
 select company, sum(percentage_laid_off)
 from layoffs_staging2
 group by company
 order by 2 desc;
 
 select substring(`date`, 1, 7 ) as `month`, sum(total_laid_off)
 from layoffs_staging2
 where substring(`date`, 1, 7 ) is not null
 group by `month`
 order by 1 asc;
 
 with rolling_total as
 (select substring(`date`, 1, 7 ) as `month`, sum(total_laid_off) as total_laid_off
 from layoffs_staging2
 where substring(`date`, 1, 7 ) is not null
 group by `month`
 order by 2 desc)
 select `month`,total_laid_off, sum(total_laid_off) over(order by `month`) AS rolling_total
 from rolling_total;
 
 
 select company,Year(`date`), sum(total_laid_off)
 from layoffs_staging2
 group by company, Year(`date`) 
 order by 3 desc;
 
 
 with company_year as (
 select company,Year(`date`) as years, sum(total_laid_off) as total_laid_off
 from layoffs_staging2
 group by company, Year(`date`) 
), company_year_rank as (
select *, Dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5;

SELECT * FROM layoffs_staging2;