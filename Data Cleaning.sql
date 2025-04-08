Use UnicornCompanies;

SELECT *
FROM Info
ORDER BY Id;

SELECT *
FROM Finance
ORDER BY Id;

--------------------------------------------------------------------------------------------------

--Checking for duplicate company name

SELECT Company,COUNT(Company) 
FROM Info
GROUP BY Company
HAVING COUNT(Company) > 1 ;

SELECT Company,COUNT(Company) 
FROM Finance
GROUP BY Company
HAVING COUNT(Company) > 1 ;

SELECT * 
FROM Info
WHERE Company='Bolt' OR Company='Fabric';

--Both Bolt and Fabric appear twice in our data but they are different companies in different cities with the same name.
--Therefore, we will keep these in our data.

--------------------------------------------------------------------------------------------------

--Dropping rows with unknown or no funding.

SELECT DISTINCT Funding 
FROM Finance;

DELETE FROM Finance
WHERE Funding IN ('$0M','Unknown');

--------------------------------------------------------------------------------------------------

--Reformatting the currency values

UPDATE Finance
SET Valuation = RIGHT(Valuation, LEN(Valuation) - 1);

UPDATE Finance
SET Valuation = REPLACE(REPLACE(Valuation, 'B','000000000'), 'M', '000000');

UPDATE Finance
SET Funding = RIGHT(Funding, LEN(Funding) - 1);

UPDATE Finance
SET Funding = REPLACE(REPLACE(Funding, 'B','000000000'), 'M', '000000');

SELECT *
FROM Finance
ORDER BY Id;

--------------------------------------------------------------------------------------------------

--Checking for companies with invalid founding year and deleting those companies' data.

DELETE FROM Finance
WHERE Id IN 
(SELECT Info.Id
FROM Info INNER JOIN Finance
ON Info.Id=Finance.Id
WHERE Unicorn_Year-Year_Founded<0);

--------------------------------------------------------------------------------------------------
