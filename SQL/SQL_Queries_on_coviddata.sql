select * from SQLProject.coviddeath;

select * from SQLProject.covidvaccine;

select location, date, total_cases, new_cases, total_deaths, population
from SQLProject.coviddeath
order by location, date;

select location, date, total_cases, total_deaths, round((total_deaths/total_cases) * 100, 2) as Death_Percentage
from SQLProject.coviddeath
order by location, date;

-- death percentage country wise
select location, date, total_cases, total_deaths, round((total_deaths/total_cases) * 100, 2) as Death_Percentage
from SQLProject.coviddeath
where location like '%ind%'
order by total_cases desc;

-- total cases vs population
select location, date, total_cases, population, round((total_cases/population) * 100, 2) as covidcases_Percentage
from SQLProject.coviddeath
order by covidcases_percentage desc;


-- country with highest no case
select location, max(cast(total_cases as unsigned)) as highest_cases_count, population, max(round((total_cases/population) * 100, 2)) as max_covidcases_Percentage
from SQLProject.coviddeath
group by location, population
order by highest_cases_count;


-- count of death, countries with highest death count
select continent, location, max(cast(total_deaths as unsigned)) as totaldeathcount
from SQLProject.coviddeath
group by location, continent;


select distinct continent
from SQLProject.coviddeath;

select distinct location 
from SQLProject.coviddeath;


select date, sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths, (sum(new_deaths)/sum(new_cases)) * 100 as death_percentage
from SQLProject.coviddeath
group by date
order by totalcases desc, totaldeaths desc;

select sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths, (sum(new_deaths)/sum(new_cases)) * 100 as death_percentage
from SQLProject.coviddeath
order by totalcases desc, totaldeaths desc;


select *
from SQLProject.covidvaccine;

-- total no of people vaccinated
select death.location, death.date, death.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by death.location order by death.location, death.date) as locationwise
from SQLProject.coviddeath death
join SQLProject.covidvaccine vac
on death.location = vac.location and
	death.date = vac.date
order by death.location;


-- using cte
with populationvsvaccine (location, date, population, new_vaccinations, locationwise)
as (
	select death.location, death.date, death.population, vac.new_vaccinations,
	sum(vac.new_vaccinations) over (partition by death.location order by death.location, death.date) as locationwise
	from SQLProject.coviddeath death
	join SQLProject.covidvaccine vac
	on death.location = vac.location and
		death.date = vac.date
	-- order by death.location
)

select *, (locationwise/population) * 100
from populationvsvaccine;

select *
from SQLProject.coviddeath;

/*
UPDATE SQLProject.coviddeath
SET total_cases = CASE WHEN total_cases = ' ' THEN NULL ELSE total_cases END,
    new_cases = CASE WHEN new_cases = ' ' THEN NULL ELSE new_cases END,
    new_cases_smoothed = CASE WHEN new_cases_smoothed = ' ' THEN NULL ELSE new_cases_smoothed END,
    total_deaths = CASE WHEN total_deaths = ' ' THEN NULL ELSE total_deaths END,
    new_deaths_smoothed = CASE WHEN new_deaths_smoothed = ' ' THEN NULL ELSE new_deaths_smoothed END,
    total_cases_per_million = CASE WHEN total_cases_per_million = ' ' THEN NULL ELSE total_cases_per_million END,
    total_cases_smoothed_per_million = CASE WHEN total_cases_smoothed_per_million = ' ' THEN NULL ELSE total_cases_smoothed_per_million END,
    total_deaths_per_million = CASE WHEN total_deaths_per_million = ' ' THEN NULL ELSE total_deaths_per_million END;
 */   


-- creating temp table
drop table if exists temp_percentpopvsvac;
create temporary table temp_percentpopvsvac(
location varchar(50),
date datetime,
population int,
new_vaccine int,
locationwise int
);

insert into temp_percentpopvsvac 
select death.location, death.date, death.population, vac.new_vaccinations,
	sum(vac.new_vaccinations) over (partition by death.location order by death.location, death.date) as locationwise
	from SQLProject.coviddeath death
	join SQLProject.covidvaccine vac
	on death.location = vac.location and
		death.date = vac.date;

select *, (locationwise/population) * 100
from temp_percentpopvsvac;

create view sqlproject.PercentPopulationVaccinated as
select death.location, death.date, death.population, vac.new_vaccinations,
	sum(vac.new_vaccinations) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
	from SQLProject.coviddeath death
	join SQLProject.covidvaccine vac
	on death.location = vac.location and
		death.date = vac.date;



