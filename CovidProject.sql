SELECT 
    *
FROM
    CovidProject.coviddeaths
WHERE continent is not null
ORDER BY 3 , 4 ;


-- SELECT 
    -- *
-- FROM
    -- CovidProject.vaccination
-- ORDER BY 3 , 4 DESC;

Select location, date,total_cases, new_cases, total_deaths,population
From CovidProject.coviddeaths
WHERE continent is not null
order by 1,2;

-- looking at Total Cases vs Total Deaths
-- shows likelihood of dying due to covid in your country like'%pal%'
Select location, date,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From CovidProject.coviddeaths
Where location like '%pal%'
and continent is not null
order by 1,2;


-- Looking as total cases vs population
-- what percentage of population got covid
Select location, date,population,total_cases, (total_cases/population)*100 as PopulationPercentage
From CovidProject.coviddeaths
Where location like '%pal%'
and continent is not null
order by 1,2;

-- Looking at which country has the highest covid infection rate compared to population
-- Select Distinct first_name and Group BY is same
Select location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PopulationInfectedPercentage
From CovidProject.coviddeaths
WHERE continent is not null
Group By location, population
order by 1,2 DESC;



-- showing countries with highest death count per population
-- CAST the value as SIGNED which corresponds to INTERGER in MYSQL(signed=int)
Select location,max(CAST(total_deaths as signed))as TotalDeathsCount
From CovidProject.coviddeaths
WHERE continent is not null
Group By location
Order by TotalDeathsCount DESC;


-- Let's break thing down by continent 
Select continent,max(CAST(total_deaths as signed))as TotalDeathsCount
From CovidProject.coviddeaths
WHERE continent is not null
Group By continent
Order by TotalDeathsCount DESC;



-- Let's break thing down by continent 
Select continent,max(CAST(total_deaths as signed))as TotalDeathsCount
From CovidProject.coviddeaths
WHERE continent is not null
Group By continent
Order by TotalDeathsCount DESC;



-- Showing the continents with the highest count per population

-- Let's break thing down by continent 
Select continent,max(CAST(total_deaths as signed))as TotalDeathsCount
From CovidProject.coviddeaths
WHERE continent is not null
Group By continent
Order by TotalDeathsCount DESC


-- Global numbers 
Select location, date,population,total_cases, (total_cases/population)*100 as PopulationPercentage
From CovidProject.coviddeaths
Where location like '%pal%'
and continent is not null
order by 1,2;


Select location, date,population,total_cases, (total_cases/population)*100 as PopulationPercentage
From CovidProject.coviddeaths
Where location like '%pal%'
and continent is not null
order by 1,2;


Select date, sum(new_cases)as TotalCases,sum(CAST(new_deaths as signed) )as TotalDeaths,sum(CAST(new_deaths as signed))/sum(new_cases)*100 as DeathsPercentage
From CovidProject.coviddeaths
-- Where location like '%pal%'
Where continent is not null
Group by date
order by 1,2;

-- Total cases, Total Deaths 
Select sum(new_cases)as TotalCases,sum(CAST(new_deaths as signed) )as TotalDeaths,sum(CAST(new_deaths as signed))/sum(new_cases)*100 as DeathsPercentage
From CovidProject.coviddeaths
-- Where location like '%pal%'
Where continent is not null
-- Group by date
order by 1,2;


-- Looking at Total Population vs Vaccinations

-- USE CTE 
With PopVsVac(continent, location,date,population,new_vaccination, rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as signed)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.coviddeaths dea
join CovidProject.vaccination vac
	on dea.location = vac.location
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/population) *100
From PopVsVac


	


-- TEMP TABLE
-- Drop table if exists #PercentPopulationVaccinated

CREATE Table #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar(255),
date datetime,
population numeric, 
new_Vaccination numeric,
rollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.coviddeaths dea
join CovidProject.vaccination vac
	on dea.location = vac.location

Select *, (RollingPeopleVaccinated/population )*100
From #PercentPopulationVaccinated	


CREATE View PercentPopulationVaccinated	as
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as signed)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.coviddeaths dea
join CovidProject.vaccination vac
	on dea.location = vac.location
Where dea.continent is not null

