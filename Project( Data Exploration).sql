--DATA EXPLORATION

select*
from  Coviddeaths
order by 3,4

select*
from  Coviddeaths
where continent is not null
order by 3,4

select* 
from  CovidVaccinations
order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from CovidDeaths
where location = 'Ghana'
order by 1,2


--Loking at Total Cases vs Population
--Shows percentage of population got covid

select location, date, population,total_cases ,(total_cases/population)*100 as Infectedpopulationpercentage
from CovidDeaths
--where location = 'Ghana'
order by 1,2


--Looking at Countries with the Highest Infection Rate compared to Population

select location, date,population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as Infectedpopulationpercentage
from CovidDeaths
--where location = 'Ghana'
group by date,location, population
order by Infectedpopulationpercentage desc



--Showing Countries with the Highest Death Count per Population

select location, max (cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location = 'Ghana'
where continent is not null
group by location
order by TotalDeathCount desc

-- per  Continents

select continent, max (cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location = 'Ghana'
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers

select date, sum (new_cases) as totalcaes, sum(cast(new_deaths as int)) as totaldeaths, sum(cast (new_deaths as int))/sum(new_cases) *100 as Deathpercentage
from CovidDeaths
--where location = 'Ghana'
where continent is not  null
group by date
order by 1,2


select sum (new_cases) as totalcaes, sum(cast(new_deaths as int)) as totaldeaths, sum(cast (new_deaths as int))/sum(new_cases) *100 as Deathpercentage
from CovidDeaths
--where location = 'Ghana'
where continent is not  null
--group by date
order by 1,2


select location, date, total_cases,new_cases, new_cases_per_million,new_cases_smoothed,new_cases_smoothed_per_million
from  Coviddeaths
where location = 'falkland islands'

select location,Sum(cast( new_cases_smoothed_per_million as int)) as totalcases 
from CovidDeaths
--where continent is not null
group by location


--Looking at Total Populations vs Vaccinations
--Joining

select *
from CovidDeaths cd
join CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
and cd.continent = cv.continent

select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
from CovidDeaths cd
join CovidVaccinations cv
on cd.location  = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3 


select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations))over (partition by cd.location order by cd.location,cd.date) as Rollingpeoplevacinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location  = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3 

--Using CTE

with PoVsVa (continent,location,date,population, new_vaccinations, rollingpeoplevaccinated)
as 
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations, 
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location,cd.date) as Rollingpeoplevacinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location  = cv.location
and cd.date = cv.date
where cd.continent is not null
)
select *
from PoVsVa


with PoVsVa (continent,location,date,population, new_vaccinations, rollingpeoplevaccinated)
as 
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations, 
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location,cd.date) as Rollingpeoplevacinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location  = cv.location
and cd.date = cv.date
where cd.continent is not null
)
select *, (rollingpeoplevaccinated/population)*100
from PoVsVa


--Using Temp Table 

drop table if exists #PercentagePopulationVaccinated
Create table #PercentagePopulationVaccinated
(
continent nvarchar (255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #PercentagePopulationVaccinated
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location,cd.date) as Rollingpeoplevacinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location  = cv.location
and cd.date = cv.date
where cd.continent is not null

select *, (rollingpeoplevaccinated/population)*100
from #PercentagePopulationVaccinated




















