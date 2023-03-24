/*The purpose of this project is to analyze data
using PosgreSQL. This involves drawing insights from
International Breweries with the aim of making
informed decisions.*/

/*To begin the project,a table has to be
created in order for the CSV file to be imported*/

CREATE TABLE int_breweries(
	SALES_ID INT,
	SALES_REP TEXT,
	EMAILS VARCHAR,
	BRANDS TEXT,
	PLANT_COST INT,
	UNIT_PRICE INT,
	QUANTITY INT,
	COST INT,
	PROFIT INT,
	COUNTRIES TEXT,
	TERRITORY TEXT,
	REGION TEXT,
	MONTHS TEXT,
	YEARS INT);
/*Thereafter the csv file was imported using UTF8
encoding and headers enabled*/

SELECT*
FROM int_breweries; --to confirm complete table.

/*Analysis of this data will be divided into 3 main
parts:
1. Profit Analysis
2. Brand Analysis
3. Countries Analysis
*/

/*PROFIT ANALYSIS*/

/*1. Within the space of the last three years, what
was the profit worth of the breweries, inclusive of
the anglophone and the francophone territories?*/ 

--first find out how many years within the period
SELECT DISTINCT years
FROM int_breweries
ORDER BY years;

SELECT DISTINCT territory
FROM int_breweries; --distinct values in teritory.

--To answer the question,
SELECT SUM(profit) AS total_profit
FROM int_breweries;

/*2. Compare the total profit between these two
territories in order for the territory manager,
Mr. Stone made a strategic decision that will aid
profit maximization in 2020.*/

SELECT territory,
	SUM(profit) AS total_profit
FROM int_breweries
GROUP BY territory;

/*3. Country that generated the highest profit in
2019*/

SELECT countries,
	SUM(profit) AS highest_profit
FROM int_breweries
WHERE years=2019
GROUP BY countries
ORDER BY highest_profit DESC
LIMIT 1;

/*4. Help him find the year with the highest
profit.*/
SELECT years,
	SUM(profit) AS year_highest_profit
FROM int_breweries
GROUP BY years
ORDER BY year_highest_profit DESC
LIMIT 1;

/*5. Which month in the three years was the least
profit generated?*/ 
SELECT years, months, profit
FROM int_breweries
ORDER BY profit
LIMIT 1;

/*6. What was the minimum profit in the month of
December 2018?*/
SELECT MIN(profit) AS min_profit
	--MAX(profit) AS max_profit
FROM int_breweries
WHERE months='December'
	AND years=2018;

/*7. Compare the profit in percentage for each of
the month in 2019*/
SELECT CASE WHEN months='January' THEN 1
		WHEN months='February' THEN 2
		WHEN months='March' THEN 3
		WHEN months='April' THEN 4
		WHEN months='May' THEN 5
		WHEN months='June' THEN 6
		WHEN months='July' THEN 7
		WHEN months='August' THEN 8
		WHEN months='September' THEN 9
		WHEN months='October' THEN 10
		WHEN months='November' THEN 11
		ELSE 12
	END AS month_num,
	i.months,
	i.monthly_profits,
	i.total_profits,
	100*i.monthly_profits/i.total_profits AS percent
FROM
(SELECT months,
	SUM(profit) AS monthly_profits,
	(SELECT SUM(profit)
	FROM int_breweries
	WHERE years=2019) AS total_profits
FROM int_breweries
WHERE years=2019
GROUP BY months) AS i
ORDER BY month_num;
/*Had to use CASE statements to order the months
column*/

/*8. . Which particular brand generated the highest
profit in Senegal?*/
SELECT brands, SUM(profit) AS highest_profit
FROM int_breweries
WHERE countries='Senegal'
GROUP BY brands
ORDER BY highest_profit DESC
LIMIT 1;

/*BRAND ANALYSIS*/

/*1. Within the last two years, the brand manager
wants to know the top three brands consumed in the
francophone countries*/
SELECT brands, SUM(quantity) AS top_brands_franco
FROM int_breweries
WHERE territory='Francophone'
	AND years IN (2018, 2019) --last two years
GROUP BY brands
ORDER BY top_brands_franco DESC
LIMIT 3;

/*2. Find out the top two choice of consumer brands
in Ghana*/
SELECT brands, SUM(quantity) AS top_brands_ghana
FROM int_breweries
WHERE countries='Ghana'
GROUP BY brands
ORDER BY top_brands_ghana DESC
LIMIT 2;

/*3. Find out the details of beers consumed in the
past three years in the most oil reached country in
West Africa*/
SELECT brands, SUM(quantity) AS no_of_beers
FROM int_breweries
WHERE countries='Nigeria' --oil rich country
	AND brands NOT IN ('beta malt', 'grand malt')
GROUP BY brands
ORDER BY no_of_beers;

/*4. Favorites malt brand in Anglophone region
between 2018 and 2019 */
SELECT brands, SUM(quantity) AS no_fav_malt_brands
FROM int_breweries
WHERE territory='Anglophone'
	AND years IN (2018, 2019)
	AND brands IN ('beta malt', 'grand malt')
GROUP BY brands;

/*5. Which brands sold the highest in 2019 in
Nigeria? */
SELECT brands, SUM(quantity) AS volume_sold
FROM int_breweries
WHERE countries='Nigeria'
	AND years=2019
GROUP BY brands
ORDER BY volume_sold DESC
LIMIT 1;

/*6. Favorites brand in South South region in
Nigeria*/
SELECT brands, SUM(quantity) AS no_fav_brands
FROM int_breweries
WHERE countries='Nigeria'
	AND region='southsouth'
GROUP BY brands
ORDER BY no_fav_brands DESC
LIMIT 1;

/*7. Beer consumption in Nigeria*/
SELECT brands, SUM(quantity) AS no_beer_consumption
FROM int_breweries
WHERE countries='Nigeria'
	AND brands NOT IN ('beta malt', 'grand malt')
GROUP BY brands
ORDER BY no_beer_consumption DESC;

/*8. Level of consumption of Budweiser in the regions
in Nigeria*/
SELECT region, SUM(quantity) AS no_budweiser
FROM int_breweries
WHERE countries='Nigeria'
	AND brands='budweiser'
GROUP BY region
ORDER BY no_budweiser DESC;

/*9. . Level of consumption of Budweiser in the
regions in Nigeria in 2019 (Decision on Promo)*/
SELECT region, SUM(quantity) AS no_budweiser
FROM int_breweries
WHERE countries='Nigeria'
	AND brands='budweiser'
	AND years=2019
GROUP BY region
ORDER BY no_budweiser DESC;

/*COUNTRIES ANALYSIS*/

/*1. Country with the highest consumption of beer.*/
SELECT countries, SUM(quantity) AS no_of_beers
FROM int_breweries
WHERE brands NOT IN ('beta malt', 'grand malt')
GROUP BY countries
ORDER BY no_of_beers DESC
LIMIT 1;

/*2. Highest sales personnel of Budweiser in Senegal*/
SELECT sales_rep,
	emails,
	SUM(unit_price * quantity) AS sales
FROM int_breweries
WHERE brands='budweiser'
	AND countries='Senegal'
GROUP BY sales_rep, emails
ORDER BY sales DESC
LIMIT 1;

/*3. Country with the highest profit of the fourth
quarter in 2019 */
SELECT countries,
	SUM(profit) AS high_profit_2019_4th_quarter
FROM int_breweries
WHERE years=2019
	AND months IN ('October', 'November', 'December')
	--fourth quarter
GROUP BY countries
ORDER BY high_profit_2019_4th_quarter DESC
LIMIT 1;

/*This wraps up the process of answering questions
using data with PostgreSQL. Thank you for you time*/