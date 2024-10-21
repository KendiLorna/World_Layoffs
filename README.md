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
``
-- Delete duplicates only 2
DELETE 
FROM layoffs_staging2
WHERE row_num>1;
```
- Standardize the data
- Remove/replace null or blank values
- Remove unnecessary rows/columns

#### Exploratory Data Analysis
- By country
- By Company
- By Industry
- By total_laid off
- By year and by month

### CONCLUSION

The data is running from March 2020 to October 2024 therefore current.
From the data available and during that period there have been 282 companies that have laid off 100% of their workforce.
The USA is tops
The total laid off from the data up to Oct 2024 is 666,436.

### LIMITATIONS
The data available is from only 65 countries in the world which is not fully representative of the world situation so it is not conclusive. Only two countries from Africa are present.
626 rows of data were deleted during the data cleaning process because they had blank values for the total laid off and percentage laid off columns which were of focus and therefore further reduced data to explore.

### RECOMMENDATION
