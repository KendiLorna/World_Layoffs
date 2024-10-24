## World layoffs
### OVERVIEW

For the project, I analyzed a dataset from Kaggle containing data on layoffs from 59 countries recorded from March 2020 to October 2024. The dataset includes seven columns: company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, and funds_raised. Using SQL/MySQL for data cleaning and exploratory data analysis I uncovered valuable insights regarding layoffs in various sectors and used Microsoft Power BI to visualize the insights.
The history of layoffs reflects broader trends in the labor market, which has continuously evolved since the Industrial Revolution. Technological advancements, economic fluctuations, and shifting workforce dynamics have profoundly impacted employment patterns. The aim is to shed light on the recent wave of layoffs and understand their implications in the context of ongoing changes in the global economy and technology landscape. 

### OBJECTIVE

To explore the trend of layoffs from 2020-2024 by industry, company, country, year, and stage of development.
This shows which industries are growing and vice versa. In conjunction with more data, such as hiring trends and specific redundant roles, it can inform career choices, which emerging skills and industries to invest in, and which to be wary of.

### DATA SOURCE

Kaggle datasets  [Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

### TOOLS

MySQL and Microsoft Power BI

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

Least layoffs by country Figure 1.0

![Bottom 10 by country](https://github.com/user-attachments/assets/5223b6c2-33fc-426f-a566-407879efa581)

Highest layoffs by country Figure 1.1

![Top layoffs by country](https://github.com/user-attachments/assets/e33fdf71-24ef-4c91-86a5-b7a4cea35792)

- Layoffs by company Figure 1.2

![Top ten companies with high layoffs](https://github.com/user-attachments/assets/c6560b60-b86f-4702-b493-cad45dca3fec)

- Layoffs by year Figure 1.3

  ![Layoffs by year](https://github.com/user-attachments/assets/ab2be937-178c-4a42-b2a7-61a0ccd432fc)

- Layoffs by year and country Figure 1.4

![By country, by year](https://github.com/user-attachments/assets/6b0c0bcf-fc8b-458c-a19a-f6320cfb3c27)

- Layoffs by year and industry Figure 1.5

![Top 5 by indusrty by year ](https://github.com/user-attachments/assets/91624252-dd45-4a2d-be3e-3af408709c65)

- Layoffs by development stage Figure 1.6

 ![By stage](https://github.com/user-attachments/assets/cee7c199-ab57-4edc-810d-1a4dbf349050)

### Data visualisation Figure 1.7

![Power BI visuals](https://github.com/user-attachments/assets/f168884d-3261-4d7e-8328-9915429e50a5)

[Link to interactive Power BI video](https://youtu.be/aARMfmcHkic)

### INSIGHTS

- From 2020 to 2024, 282 companies laid off their entire workforce.

- As of October 2024, the total number of layoffs reported is 667,386.

- The United States accounts for 67% of these layoffs, primarily driven by major tech companies like Amazon and Google.

- Layoffs have increased from 2021 to 2024, partly due to the rise of AI, which has made some roles redundant. During the pandemic, many companies adopted remote work technologies that created roles like customer support. As businesses shifted back to in-office models, there was a significant decrease in demand for these tech services, leading to staff reductions.

- The transportation, finance, hardware, and consumer sectors have consistently seen high numbers of layoffs over the past four years. This is largely due to the rapidly changing nature of these industries and their sensitivity to economic and technological shifts.

- Major tech companies have laid off over 100,000 employees in the last four years. Since these companies often employ large workforces, even a small percentage of layoffs can result in tens of thousands of job losses.

- Post-IPO companies accounted for 50% of layoffs primarily to manage costs and meet investor expectations for profitability. After aggressive hiring during growth phases, companies may be overstaffed if growth doesn't continue as anticipated. Market volatility can also drive layoffs, as falling stock prices prompt management to reassess workforce needs, a pressure less established companies typically don’t face.

### LIMITATIONS

- The data available is from 65 countries which is not fully representative of the world situation. Only five countries from Africa are represented.

- 626 rows of data were deleted during the data cleaning process because they had blank values for the total laid off and percentage laid off columns which were of focus and therefore further reduced data to explore.

### PROJECTIONS BASED ON CURRENT TRENDS

- Technology: Given the adoption of AI and automation, layoffs in the tech sector may continue as companies seek to streamline operations. Major tech firms focus on efficiency, therefore further workforce reductions.

- Finance: The finance sector may also see ongoing layoffs as companies adopt more digital solutions and automation. Economic fluctuations could drive cost-cutting measures, impacting jobs, particularly in traditional roles.

- Transportation: As the industry experiences advancements such as robot cars, self-driving taxis, and the adoption of electric cars, layoffs could persist, especially if companies are forced to adapt to market changes.

- Consumer: This sector may continue to experience layoffs due to economic pressures and shifts in consumer spending habits, especially if companies struggle to maintain profit margins.

- Geographical Location: In the USA, layoffs will likely remain high, particularly in tech and finance. However, emerging markets such as AI may experience different dynamics.

Industries more susceptible to technological disruption and economic instability may see higher rates of layoffs, while those that can adapt and innovate might stabilize and even grow their workforces. Healthcare, food, and retail might experience growth and stability due to their essential nature.
