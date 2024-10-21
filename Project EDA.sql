-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

-- 30 industries in the dataset
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Data from 59 countries
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Ran from 2020 March to 2024 October
SELECT MAX(`date`),MIN(`date`)
FROM layoffs_staging2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

-- 282 companies laid off all the staff(1=100%)
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
WHERE total_laid_off != ""
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;-- The top 10 are tech companies

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;-- reatil has the highest lay offs(71703) and AI the lowest(288)

SELECT industry,country, SUM(total_laid_off) tlo
FROM layoffs_staging2
WHERE total_laid_off != ""
GROUP BY industry,country
ORDER BY tlo DESC;

-- The USA tops,bottom Luxembourg could be due to lack of data on layoffs or protective policies
SELECT country, SUM(total_laid_off) tlo
FROM layoffs_staging2
WHERE total_laid_off != ""
GROUP BY country
ORDER BY tlo ;

-- 2023 highest,2021 lowest with a steady increase(2024 is up to october)
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

-- By country, by year.The USA tops
SELECT country,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country,YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

-- Post IPO had highest number of layoffs(based on stage of growth/stability)-322 were not classified
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;

-- Rollling total of layoffs for months in the world
SELECT SUBSTRING(`date`,1,7) AS `Month`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;
-- 
WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`,SUM(total_laid_off) AS sum_total
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`,sum_total,SUM(sum_total) OVER(ORDER BY `Month`) AS Rolling_sum
FROM Rolling_total;

SELECT country,SUBSTRING(`date`,1,7) AS `Month`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY country,`Month`
ORDER BY country ;

-- Layoffs per company per year ranked highest to lowest
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH company_per_year (Company,`Year`,Total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC -- Total laid off ordered by company and year
), Company_ranking AS
(
SELECT * ,
dense_rank() OVER(PARTITION BY `Year` ORDER BY Total_laid_off DESC) AS Dense_rank_number
FROM company_per_year
WHERE `YEAR` IS NOT NULL -- Partitions layoffs by year then Ranks all companies by total laid off in descending order
)
SELECT * 
FROM Company_ranking
WHERE Dense_rank_number <= 5;-- Top 5 companies laying off each year by number of people laid off

WITH Industry_per_year (Industry,Years,Total_laid_off) AS
(
SELECT industry,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry,YEAR(`date`)
ORDER BY 3 DESC               -- Total laid off ordered by industry and year
), Industry_ranking AS
(
SELECT * ,
dense_rank() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS Rank_number
FROM Industry_per_year
WHERE Years IS NOT NULL    -- Partitions layoffs by year then ranks all industries by total laid off in descending order
)
SELECT * 
FROM Industry_ranking
WHERE Rank_number <= 5; -- This shows the top 5 industry per year that laid off the highest number of people 

