Select *
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Order by 2,3


--Comparing extreme poverty levels with access to handwashing facilities

Select dea.location, vac.extreme_poverty, vac.handwashing_facilities
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
and vac.extreme_poverty is not null 
and vac.handwashing_facilities is not null
--Where dea.location like 'Kenya'
Group by dea.location, vac.extreme_poverty, vac.handwashing_facilities
Order by 3


--Comparing number of hospital beds per 1000 and weekly hospital admissions

Select dea.location, dea.date, dea.weekly_hosp_admissions, vac.hospital_beds_per_thousand, MAX(dea.weekly_hosp_admissions) as MaxAdmissions
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
--Where dea.location like 'Kenya'
Group by dea.location, dea.date, dea.weekly_hosp_admissions, vac.hospital_beds_per_thousand
Order by 3, 4


--Select everything from covid death table

Select *
From PortfolioProject..CovidDeaths$
Order by 3,4


--Selecting everything from covid vaccination table

Select *
From PortfolioProject..CovidVaccinations$
Order by 3,4


--Select Data that we are going to be using

Select location, date, population, total_cases, new_cases, total_deaths
From PortfolioProject..CovidDeaths$
Order by 1,2


--Looking at Total cases vs Total deaths
--Looking at likelihood of dying once contracted covid in Kenya

Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like 'Kenya'
Order by 1,2
--1.7% chance of dying in kenya if you get covid on 2.2.22


--Looking at Total_cases vs Population
--Shows what % of the population has COVID19

Select location, date, population, total_cases, total_deaths, (total_cases/population)*100 as InfectionPercentage
From PortfolioProject..CovidDeaths$
Where location like 'Kenya'
Order by 1,2


--Countries with highest infection rates per population in Kenya

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionPercentage
From PortfolioProject..CovidDeaths$
--Where location like 'Kenya'
Where continent is not null
Group by location, population
Order by InfectionPercentage desc


--Showing countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
--Where location like 'Kenya'
Where continent is not null
Group by location, population
Order by HighestDeathCount desc


--BREAKING DOWN DATA BY CONTINENT

--Showing continents with the highest death counts per population

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
--Where location like 'Kenya'
Where continent is null
Group by location
Order by HighestDeathCount desc


--GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by  date
Order by 1,2


--Total global cases

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
--Group by  date
Order by 1,2


--JOINING COVID DEATHS + VACCINATION TABLES

Select *
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date



--Looking at Total Vaccinations vs Population

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


--Looking at Total Vaccinations on rolling basis vs Population

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinations
--, (RollingPeopleVaccinations/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3



--TEMP TABLE

DROP Table if exists #PercentageVaccinationsPerPopulation --delete preexisting table
Create Table #PercentageVaccinationsPerPopulation
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinationAdministered numeric
)


Insert into #PercentageVaccinationsPerPopulation 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinationAdministered
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (RollingVaccinationAdministered/population)*100 as PercentageVaccinationsPerPopulation
From #PercentageVaccinationsPerPopulation



--Creating view to store data for later visualisation

Create View PercentageVaccinationsPerPopulation as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinationAdministered
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null



--View for total vaccinations vs population
Create View TotalVaccinationsPerPopulation as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null


