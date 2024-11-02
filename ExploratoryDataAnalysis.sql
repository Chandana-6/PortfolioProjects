SELECT * FROM layoffs_testing2;
SELECT MAX(total_laid_off),MAX(percentage_laid_off) FROM layoffs_testing2;
SELECT * FROM layoffs_testing2 WHERE percentage_laid_off = 1 ORDER BY funds_raised_millions DESC;
SELECT company, SUM(total_laid_off) FROM layoffs_testing2 GROUP BY company ORDER BY 2 DESC;
SELECT industry, SUM(total_laid_off) FROM layoffs_testing2 GROUP BY industry ORDER BY 2 DESC;
SELECT country, SUM(total_laid_off) FROM layoffs_testing2 GROUP BY country ORDER BY 2 DESC;
SELECT year(`date`), SUM(total_laid_off) FROM layoffs_testing2 GROUP BY year(`date`) ORDER BY 1 DESC;
SELECT stage,SUM(total_laid_off) FROM layoffs_testing2 GROUP BY stage ORDER BY 2 DESC;
WITH rolling_total_CTE AS(
SELECT substring(`DATE`,1,7) as `month`,SUM(total_laid_off) AS total_down FROM layoffs_testing2 WHERE substring(`DATE`,1,7) IS NOT NULL 
GROUP BY `month` ORDER BY 1 ASC)
SELECT `month`,total_down,SUM(total_down) OVER(ORDER BY `MONTH`) as rolling_total FROM rolling_total_CTE;


WITH company_year_CTE(company,years,total_laid_off) AS (
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_testing2 GROUP BY company,year(`date`) ) ,
company_rank_cte AS(SELECT *,DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as ranks
FROM company_year_cte WHERE years IS NOT NULL ) 
SELECT * FROM company_rank_cte WHERE ranks <= 5;
