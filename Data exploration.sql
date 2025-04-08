

--Research Questions

-- 1.Which unicorn companies have had the biggest return on investment?
-- 2.How long does it usually take for a company to become a unicorn?
-- 3.Which industries have the most unicorns? 
-- 4.Which countries have the most unicorns? 
-- 5.Which investors have funded the most unicorns?

--------------------------------------------------------------------------------------------------

USE UnicornCompanies

SELECT *
FROM Info
ORDER BY Id;

SELECT *
FROM Finance
ORDER BY Id;

--------------------------------------------------------------------------------------------------


-- 1.Which unicorn companies have had the biggest return on investment?

SELECT TOP 10 Company,(CONVERT(BIGINT,Valuation)-CONVERT(BIGINT,Funding))/CONVERT(BIGINT,Funding) AS ROI
FROM Finance
ORDER BY ROI DESC 


--Zapier has the biggest return on investment followed by Dunamu, Workhuman, and CFGI.


--------------------------------------------------------------------------------------------------


-- 2.How long does it usually take for a company to become a unicorn?

SELECT AVG(Unicorn_Year-Year_Founded) AS Average
FROM Info JOIN Finance
ON Info.Id=Finance.Id;

--On average, a company takes 6 years to become a unicorn.

SELECT TOP 10 (Unicorn_Year-Year_Founded) AS Years,COUNT(1) AS Frequency
FROM Info JOIN Finance
ON Info.Id=Finance.Id
GROUP BY Unicorn_Year-Year_Founded
ORDER BY Frequency DESC

--Majority companies take 4 to 7 years to become a unicorn.


--------------------------------------------------------------------------------------------------


-- 3.Which industries have the most unicorns? 

SELECT Industry,COUNT(Industry) AS Frequency,
ROUND(CAST(COUNT(Industry) AS float)/(SELECT COUNT(*) FROM Info JOIN Finance
ON Info.Id=Finance.Id)*100,0) AS Percentage
FROM Info JOIN Finance
ON Info.Id=Finance.Id
GROUP BY Industry
ORDER BY Frequency DESC

--Fintech industry has most unicorns followed by Internet software & services and e-commerce.

--------------------------------------------------------------------------------------------------


-- 4.Which countries have the most unicorns? 

WITH UnicornComp AS
(SELECT Info.Id,Info.Company,Info.Industry,Info.City,Info.Country,Info.Continent,Info.Year_Founded,
Fin.Funding,Fin.Valuation,Fin.Unicorn_Year,Fin.Select_Investors
FROM Info INNER JOIN Finance AS Fin
ON Info.Id=Fin.Id)
SELECT TOP 10 Country,COUNT(1) AS Frequency,ROUND(CAST(COUNT(1) AS float)/ (SELECT COUNT(*) FROM UnicornComp)*100,0) AS 'Percentage'
FROM UnicornComp
GROUP BY Country
ORDER BY Frequency DESC

--United States has the most unicorns followed by China and India.


--------------------------------------------------------------------------------------------------


-- 5.Which investors have funded the most unicorns?

SELECT *
FROM Finance
ORDER BY Id;

UPDATE Finance
SET Select_Investors = REPLACE(Select_Investors, ', ', ',')

SELECT TOP 10 value Investor,COUNT(*) AS Unicorns
FROM Finance
CROSS APPLY string_split(Select_Investors,',')
GROUP BY value
ORDER BY COUNT(*) DESC

--Accel has invested in most unicorns followed by Tiger Global Management and Andreessen Horowitz.
