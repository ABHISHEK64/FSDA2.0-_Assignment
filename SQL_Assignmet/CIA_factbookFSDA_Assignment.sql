create database pop;
use pop;
CREATE TABLE cia (
	country VARCHAR(45) NOT NULL, 
	area DECIMAL(38, 0), 
	birth_rate DECIMAL(38, 2), 
	death_rate DECIMAL(38, 2), 
	infant_mortality_rate DECIMAL(38, 2), 
	internet_users DECIMAL(38, 0), 
	life_exp_at_birth DECIMAL(38, 2), 
	maternal_mortality_rate DECIMAL(38, 0), 
	net_migration_rate DECIMAL(38, 2), 
	population DECIMAL(38, 0), 
	population_growth_rate DECIMAL(38, 2)
);
set session sql_mode='';

LOAD DATA INFILE "D:\cia.csv" into table cia
fields terminated by ','
enclosed by '"'lines terminated by '\n'
ignore 1 rows;
select * from cia;
//country has max poupulation
select country,population from cia where population=(select max(population) from cia);
//country has min poupulation
select * from cia where population=(select min(population) from cia);
//country has maximum poupulation_growth_rate
select country,population_growth_rate from cia where population_growth_rate=(select max(population_growth_rate) from cia);
//country has maximum poupulation_density
select country,(population/area) as Population_density from cia order by Population_density desc limit 1;
//coutry has extraordinary population
select country,population from cia order by population desc limit 10;