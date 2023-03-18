select*
from PortfolioProject1..CovidDeaths$
ORDER BY 2

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject1..CovidDeaths$
ORDER BY 1,2
--looking at total cases vs total deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject1..CovidDeaths$
where location like '%morocco%'
ORDER BY 1,2
--looking at total cases vs population
Select location, date,population, total_cases, (total_cases/population)*100 as casespercentage
from PortfolioProject1..CovidDeaths$
--where location like '%morocco%'
ORDER BY 1,2
-- looking at countries with highest infection rate compared to population 
Select location,population, Max(total_cases) as maxinfectioncount, Max((total_cases/population))*100 as maxcasespercentage
from PortfolioProject1..CovidDeaths$
Group by location, population
ORDER BY maxcasespercentage desc
-- showing countries with highest death count
Select location, max(cast(total_deaths as int)) as maxdeathscount
from PortfolioProject1..CovidDeaths$
where continent is not null
Group by location
ORDER BY maxdeathscount desc

-- showing continent with highest death count
Select continent, max(cast(total_deaths as int)) as maxdeathscount
from PortfolioProject1..CovidDeaths$
where continent is not null
Group by continent
ORDER BY maxdeathscount desc

--global numbers
Select date, SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from PortfolioProject1..CovidDeaths$
where continent is not null
Group by date
ORDER BY 1
-- numbers across the world 
Select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from PortfolioProject1..CovidDeaths$
where continent is not null
ORDER BY 1
--looking at total population vs vaccinations
--using CTE
With my_CTE as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)  as peopleVaccinated 
from PortfolioProject1..CovidDeaths$ as dea
Join PortfolioProject1..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
--order by 2,3
)
select *,(peopleVaccinated/population)*100
from my_CTE
--where location like '%albania%'

--Temp table
drop table if exists ma_table
create table ma_table(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
peoplevaccinated numeric)
insert into ma_table
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)  as peopleVaccinated 
from PortfolioProject1..CovidDeaths$ as dea
Join PortfolioProject1..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
select *
from ma_table
--creating a view to store data for later visualizations 
drop view if exists my_view
CREATE VIEW my_view AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)  as peopleVaccinated 
from PortfolioProject1..CovidDeaths$ as dea
Join PortfolioProject1..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null

select*
from my_view



