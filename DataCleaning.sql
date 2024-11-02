CREATE TABLE layoffs_testing LIKE layoffs;
DROP TABLE layoffs_staging;
INSERT INTO layoffs_testing SELECT * FROM layoffs; 
SELECT * FROM layoffs_testing;
WITH Duplicates_CTE AS
(
SELECT * , ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off, percentage_laid_off, `date`,stage,country,
funds_raised_millions) AS row_num FROM layoffs_testing)
SELECT * FROM Duplicates_CTE WHERE row_num > 1;
DROP TABLE `layoffs_testing2`;
CREATE TABLE `layoffs_testing2` (`company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT layoffs_testing2 
SELECT * , ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off, percentage_laid_off, `date`,stage,country,
funds_raised_millions) AS row_num
FROM layoffs_testing;
DELETE FROM layoffs_testing2 WHERE row_num > 1;
UPDATE layoffs_testing2 SET Company = TRIM(Company);
UPDATE layoffs_testing2 SET industry = "Crypto" WHERE industry LIKE "Crypto%"; 
SELECT DISTINCT(country) FROM layoffs_testing2 WHERE country LIKE "United States%";
UPDATE layoffs_testing2 SET country = TRIM(TRAILING "." FROM country) WHERE country LIKE "United States%";
UPDATE layoffs_testing2 SET `date` = str_to_date(`date`,"%m/%d/%Y");
ALTER TABLE layoffs_testing2 MODIFY column `date` DATE;
SELECT * FROM layoffs_testing2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
UPDATE layoffs_testing2 SET industry = NULL WHERE industry = "";
SELECT * FROM layoffs_testing2 t1 JOIN layoffs_testing2 t2 ON t1.company = t2.company WHERE (t1.industry IS NULL) AND (t2.industry IS NOT NULL);
UPDATE layoffs_testing2 t1 JOIN layoffs_testing2 t2 ON t1.company = t2.company SET t1.industry = t2.industry WHERE (t1.industry IS NULL)
AND (t2.industry IS NOT NULL);
SELECT * FROM layoffs_testing2 WHERE company="AirBNB";
DELETE FROM layoffs_testing2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
ALTER TABLE layoffs_testing2 
DROP COLUMN row_num;
SELECT * FROM layoffs_testing2 ORDER BY total_laid_off;