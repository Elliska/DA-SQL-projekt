-- Výzkumné otázky

-- Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT
    '2007-2017' AS sledovane_obdobi ,
	name AS odvetvi,
    MAX(CASE WHEN payroll_year  = 2017 THEN prum_mzda END) - MAX(CASE WHEN payroll_year  = 2007 THEN prum_mzda END) AS rust_kc 
FROM t_michaela_maleckova_project_SQL_primary_final
WHERE payroll_year BETWEEN 2007 AND 2017
GROUP BY name
ORDER BY rust_kc;
-- ---------------------------------------------------------------------------------------------------------

-- Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- verze 1 celkem:
SELECT 
	product,
	payroll_year,
	avg_hodnota_kc ,
	round(avg(prum_mzda),1) AS avg_mzda,
	round(prum_mzda/avg_hodnota_kc) AS pocet_produktu,
	cp.price_unit AS jednotka
FROM t_michaela_maleckova_project_sql_primary_final AS cp
WHERE payroll_year IN (2007,2017) AND product IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
GROUP BY payroll_year, product
ORDER BY product, payroll_year;

-- verze 2 pro všechna odvětví:
SELECT 
	payroll_year ,
	product ,
	name,
	prum_mzda AS prum_mzda ,
	avg_hodnota_kc AS cena_produktu,
	round(prum_mzda/avg_hodnota_kc) AS pocet_produktu , -- počet kg/l které je možné si z platu pořídit
	cp.price_unit AS jednotka
FROM t_michaela_maleckova_project_sql_primary_final AS cp
WHERE payroll_year IN (2007,2017)  AND product IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
ORDER BY payroll_year, product;
-- ---------------------------------------------------------------------------------------------------------

-- Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
WITH product_2007 AS (
	SELECT 
		product,
		avg_hodnota_kc AS hodnota_2007
	FROM t_michaela_maleckova_project_sql_primary_final
	WHERE payroll_year = 2007
),
product_2017 AS (
	SELECT 
		product,
		avg_hodnota_kc AS hodnota_2017
	FROM t_michaela_maleckova_project_sql_primary_final
	WHERE payroll_year = 2017
)
SELECT 
	p1.product, 
	REPLACE(p1.hodnota_2007, '.', ',') AS hodnota_2007, 
	REPLACE(p2.hodnota_2017, '.', ',') AS hodnota_2017,
	replace(( round(((p2.hodnota_2017 - p1.hodnota_2007) / p1.hodnota_2007 * 100),2) ),'.', ',') AS percentage
FROM product_2007 p1
JOIN product_2017 p2 ON p1.product = p2.product
GROUP BY product
ORDER BY percentage;
-- ---------------------------------------------------------------------------------------------------------

-- Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
WITH vypocet AS (
	WITH souhrn AS (
		SELECT 
			payroll_year ,
			'potraviny' AS polozka ,
			avg_hodnota_kc
		FROM t_michaela_maleckova_project_sql_primary_final AS cp
		GROUP BY payroll_year
		-- 
		UNION
		-- 
		SELECT
			payroll_year ,
			'platy',
			avg(prum_mzda) AS avg_mzda
		FROM t_michaela_maleckova_project_SQL_primary_final
		GROUP BY payroll_year
		ORDER BY polozka, payroll_year	
	)
	SELECT 
		payroll_year ,
		polozka ,
		avg_hodnota_kc ,
		LAG(avg_hodnota_kc, 1) OVER (PARTITION BY polozka ORDER BY payroll_year) AS prev_year_avg ,
		round(((avg_hodnota_kc  - LAG(avg_hodnota_kc, 1) OVER (PARTITION BY polozka ORDER BY payroll_year))/LAG(avg_hodnota_kc, 1) OVER (PARTITION BY polozka ORDER BY payroll_year)*100),1) AS procenta
	FROM souhrn AS s
)
SELECT 
	REPLACE(payroll_year, ',', '') AS payroll_year,
	polozka,
	REPLACE(procenta, '.', ',') AS procenta
	-- avg_hodnota_kc,
	-- prev_year_avg
FROM vypocet AS vp
WHERE
	procenta >= 10 or polozka IN ('potraviny', 'platy') AND payroll_year IN (2007,2008,2011,2012,2014,2015) 
	-- nejsem si jistá, jak zajistit filtrování rovnou, bez manuálního vypsání roků
ORDER BY payroll_year asc, polozka desc;
-- ---------------------------------------------------------------------------------------------------------

/* Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem? */

SELECT
	payroll_year ,
	round( ((prum_mzda - LAG(prum_mzda, 1) OVER (ORDER BY payroll_year)) / LAG(prum_mzda, 1) OVER (ORDER BY payroll_year) *100), 1) AS mezirocni_procento_mzda ,
	round( ((avg_per_year - LAG(avg_per_year, 1) OVER (ORDER BY payroll_year)) / LAG(avg_per_year, 1) OVER (ORDER BY payroll_year) *100), 1) AS mezirocni_procento_kc_produkt ,
	round( ((GDP - LAG(GDP, 1) OVER (ORDER BY payroll_year))/ LAG(GDP, 1) OVER (ORDER BY payroll_year)*100) , 1) AS mezirocni_procento_gdp
FROM t_michaela_maleckova_project_sql_secondary_final AS tmmpspf ;

