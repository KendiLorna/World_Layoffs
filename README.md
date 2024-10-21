## World_layoffs
### INTRODUCTION

The dataset used is on world layoffs obtained from Kaggle. It records layoffs around the world from March 2020 to October 2024. The file contained a table with seven columns: company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, and funds_raised.
.

### OBJECTIVE

To explore the trend of layoffs from 2020-2024 by industry, company, country, and stage of development.
This is important to show which industries are growing and vice versa and with more data such as hiring trends and specific redundant roles, can be used to inform career choices and which emerging skills and industries to invest in and which to avoid.

### DATA SOURCE

Kaggle datasets  [Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

### TOOLS

MySQL

### METHODOLOGY

Data cleaning

- Remove Duplicates
```
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
```
```
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
```
- Standardize the data
```
-- Data from 59 countries
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = "United Arab Emirates"
WHERE country = 'UAE';

--Check if all companies are properly classified
SELECT company, industry
FROM layoffs_staging2;

-- Updated the table to reflect changes
UPDATE layoffs_staging2
SET industry = "Data"
WHERE company ="Appsmith" ;

UPDATE layoffs_staging2
SET industry = "Retail"
WHERE industry LIKE 'https%';

-- Convert string to date format in the date column
SELECT `date`,
str_to_date(`date`,'%d/%m/%Y')
FROM layoffs_staging2;

-- Update table to reflect changes
UPDATE layoffs_staging2
SET `date`= str_to_date(`date`,'%d/%m/%Y');

-- Change the column from text to date data type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

```
- Remove/replace null or blank values
```--626 blank rows
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off =""
AND percentage_laid_off="";

-- Deleted 626 rows that didn't have data in the columns of interest
DELETE
FROM layoffs_staging2
WHERE total_laid_off =""
AND percentage_laid_off="";
````
- Remove unnecessary rows/columns
```
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
```
#### Exploratory Data Analysis
- By country

Least layoffs by country

![Bottom 10 by country](https://github.com/user-attachments/assets/5223b6c2-33fc-426f-a566-407879efa581)
Highest layoffs by country

![Top layoffs by country](https://github.com/user-attachments/assets/e33fdf71-24ef-4c91-86a5-b7a4cea35792)

- By Company

![Top ten companies with high layoffs](https://github.com/user-attachments/assets/c6560b60-b86f-4702-b493-cad45dca3fec)

- By year

  ![Layoffs by year](https://github.com/user-attachments/assets/ab2be937-178c-4a42-b2a7-61a0ccd432fc)

- By year and country
![By country,by year](https://github.com/user-attachments/assets/6b0c0bcf-fc8b-458c-a19a-f6320cfb3c27)

- By year and industry

![Top 5 by indusrty by year ](https://github.com/user-attachments/assets/91624252-dd45-4a2d-be3e-3af408709c65)

- By development stage

 ![By stage](https://github.com/user-attachments/assets/cee7c199-ab57-4edc-810d-1a4dbf349050)

### CONCLUSION

The data is running from March 2020 to October 2024 therefore current.
From the data available and during that period there have been 282 companies that have laid off 100% of their workforce.
The USA is tops
The total laid off from the data up to Oct 2024 is 666,436.

### LIMITATIONS
The data available is from only 65 countries in the world which is not fully representative of the world situation so it is not conclusive. Only two countries from Africa are present.
626 rows of data were deleted during the data cleaning process because they had blank values for the total laid off and percentage laid off columns which were of focus and therefore further reduced data to explore.

### RECOMMENDATION
