-- Soubor se skripty pro vytvoření pohledu a tabulek

-- -----------------------------------------------------------------------------------------------------------------
-- První tabulka
-- -----------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS t_michaela_maleckova_project_SQL_primary_table2;

-- create table t_michaela_maleckova_project_SQL_primary_table1 as
SELECT
    payroll_year,
    cpi.name ,
    round(AVG(cp.value)) AS prum_mzda
FROM czechia_payroll AS cp
JOIN czechia_payroll_industry_branch AS cpi
     ON cp.industry_branch_code = cpi.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code != 100 AND payroll_year BETWEEN 2006 AND 2017-- Průměrná mzda a přepočtený plný úvazek
GROUP BY payroll_year, cpi.name
ORDER BY cpi.name, payroll_year ;

-- create table t_michaela_maleckova_project_SQL_primary_table2 as
SELECT
	-- value,
	YEAR (date_from) AS measure_year,
	name AS product,
	price_value,
	price_unit ,
	round(avg(value),1) AS avg_hodnota_kc
FROM czechia_price AS cp 
JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
WHERE year(date_from) BETWEEN 2006 AND 2017 AND name != 'Jakostní víno bílé' -- u vína jsou záznamy až od roku 2015
GROUP BY year(date_from), name
ORDER BY name, year(date_from);

-- CREATE OR REPLACE VIEW t_michaela_maleckova_project_SQL_primary_view as
SELECT *
FROM t_michaela_maleckova_project_sql_primary_table1 AS cp
JOIN t_michaela_maleckova_project_sql_primary_table2 AS cpp  
	ON cp.payroll_year = cpp.measure_year
ORDER BY payroll_year ;

-- -----------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_michaela_maleckova_project_SQL_primary_final;

CREATE TABLE t_michaela_maleckova_project_SQL_primary_final AS
	SELECT * FROM t_michaela_maleckova_project_SQL_primary_view;

SELECT DISTINCT payroll_year FROM t_michaela_maleckova_project_sql_primary_final AS tmmpspt 
ORDER BY payroll_year ;

-- -----------------------------------------------------------------------------------------------------------------
-- Druhá tabulka
-- -----------------------------------------------------------------------------------------------------------------

-- CREATE TABLE t_michaela_maleckova_project_SQL_secondary_final as
SELECT 
	mm.payroll_year ,
	mm.prum_mzda ,
	mm.measure_year ,
	'potraviny' ,
	avg(avg_hodnota_kc) AS avg_per_year,
	e.GDP,
	e.population ,
	e.gini ,
	e.taxes
FROM t_michaela_maleckova_project_SQL_primary_final	AS mm
JOIN economies AS e 
	ON mm.payroll_year = e.year
	AND e.country = ('Czech Republic')
GROUP BY mm.payroll_year
HAVING avg(avg_hodnota_kc)
ORDER BY payroll_year;

