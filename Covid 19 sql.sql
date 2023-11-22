SELECT*
FROM PortfolioProject. .CovidDeaths
Where continent is not null
ORDER BY 3, 4

--SELECT*
--FROM PortfolioProject. .CovidVaccinations
--ORDER BY 3, 4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject. .CovidDeaths
ORDER BY 1, 2

--Total Cases vs Total Deaths
--Show likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage	
FROM PortfolioProject. .CovidDeaths
WHERE location like '%Philipp%'
ORDER BY 1, 2

--Total Cases vs. Population
--Shows What perecentage of  population got Covid
SELECT Location, date, total_cases, Population, (total_cases/Population)*100 as CovidCasesPercentage	
FROM PortfolioProject. .CovidDeaths
--WHERE location like '%States%'
ORDER BY 1, 2

--Looking at Countries with High Infection Rate Compared to  Population
SELECT Location,MAX(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as 
PercentPopulationInfected
FROM PortfolioProject. .CovidDeaths
--WHERE location like '%States%'
Group by Location, Population
ORDER BY PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population


SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject. .CovidDeaths
--WHERE location like '%States%'
Group by Location
ORDER BY TotalDeathCount desc

--Breakdown by Continent


SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject. .CovidDeaths
Where continent is not null
Group by continent
ORDER BY TotalDeathCount desc

--Showing  The continents with highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject. .CovidDeaths
Where continent is not null
Group by continent
ORDER BY TotalDeathCount desc

--Global Numbers
--SELECT  date,SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
--FROM PortfolioProject. .CovidDeaths
--where continent is not NULL
--GROUP BY date 
--ORDER BY 1, 2

SELECT  SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject. .CovidDeaths
where continent is not NULL
ORDER BY 1, 2

--Looking total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by
dea.location,dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac. date
where dea.continent  is not NULL
order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by
dea.location,dea.Date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100
FROM PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac. date
where dea.continent  is not NULL
--order by 2,3
)
SELECT* , (RollingPeopleVaccinated/Population) * 100
From PopvsVac



--Temp Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert Into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by
dea.location,dea.Date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100
FROM PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac. date
--where dea.continent  is not NULL
--order by 2,3


SELECT* , (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated

--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated1 as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by
dea.location,dea.Date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100
FROM PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac. date
where dea.continent  is not NULL
--order by 2,3


SELECT *
FROM PercentPopulationVaccinated1