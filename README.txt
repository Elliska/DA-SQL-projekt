# Dokumentace k výukovému projektu SQL v Datové akademii

## Výzkumné otázky

Výzkumné otázky, které byly v rámci projektu zodpovězeny, jsou následující:
* Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
* Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
* Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
* Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
* Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

## Data

Pro zpracování výzkumných otázek byla použita data od Engeto.

## Metodika

Data byla zpracována v DBeaver a databáze byla MariaDB. Vtvořeny byly pomocné tabulky a pohledy.

## Výsledky

### Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
* Ve všech odvětvích mzdy stoupají, nikoliv však rovnoměrně.
* Zkoumané období bylo 2007-2017.

### Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
* V roce 2007 bylo čistě teoreticky možné si koupit 1099 kg chleba a 1324 l mléka
* V roce 2017 bylo čistě teoreticky možné si koupit 926 kg chleba a 1335 l mléka

## Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
* Nejnižší nárůst lze vidět u banánů.
* Dvě kategorie mají dokonce mají pokles nikoliv nárůst a sice cukr krystalový a papriky.

## Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
* Neexistuje žádný rok, ve kterém by nárůst cen potravin byl o 10 a více procent vyšší, než nárůst mezd.
* Existuje ale nárůst o 10,1 % v roce 2017. Platy však v témže roce vzrostly o 2,6 %.

## Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
* Z dat vyplývá, že HDP nemá rozhodující vliv na změny ve mzdách a cenách potravin.
