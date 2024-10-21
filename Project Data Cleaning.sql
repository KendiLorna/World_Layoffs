-- Data Cleaning

SELECT * FROM layoffs;
-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Remove/replace null or blank values
-- 4. Remove unnecessary rows/columns

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;
-- To see all duplicate values
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging;

-- CTE for row numbers to determine if there are duplicates and then delete the duplicates
WITH duplicates_cte AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicates_cte
WHERE row_num>1;

SELECT * 
FROM layoffs_staging
WHERE company='Beyond meat';
-- Create another table for the updates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num>1;

-- Delete duplicates only 2
DELETE 
FROM layoffs_staging2
WHERE row_num>1;

-- Standardizing data
-- Triming company name 
SELECT company,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT company
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE company = "ebay";

UPDATE layoffs_staging2
SET industry = "Retail"
WHERE industry LIKE 'https%';

UPDATE layoffs_staging2
SET country = "United Arab Emirates"
WHERE country = 'UAE';

SELECT `date`,
str_to_date(`date`,'%d/%m/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= str_to_date(`date`,'%d/%m/%Y');

UPDATE layoffs_staging2
SET industry = "Data"
WHERE company ="Appsmith" ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Blanks 626 rows
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off =""
AND percentage_laid_off="";

-- Deleted 626 rows that didnt have data in the columns of interest
DELETE
FROM layoffs_staging2
WHERE total_laid_off =""
AND percentage_laid_off="";

-- Remove unnecessary columns

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;