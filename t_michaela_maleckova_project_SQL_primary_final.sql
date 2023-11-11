-- Soubor se skripty pro vytvoření pohledu a tabulek

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

CREATE INDEX payroll_year ON t_michaela_maleckova_project_SQL_primary_final(payroll_year);

CREATE INDEX prum_mzda ON t_michaela_maleckova_project_SQL_primary_final(prum_mzda);

CREATE INDEX hodnota_kc ON t_michaela_maleckova_project_SQL_primary_final(hodnota_kc);


DROP INDEX IF EXISTS payroll_year ON t_michaela_maleckova_project_SQL_primary_final;

DROP INDEX IF EXISTS prum_mzda ON t_michaela_maleckova_project_SQL_primary_final;

DROP INDEX IF EXISTS hodnota_kc ON t_michaela_maleckova_project_SQL_primary_final;





