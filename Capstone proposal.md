# Capstone Proposal: Predicting and preventing US traffic fatalities 

### 1) What is the problem you want to solve?
Fatalities on US highways in 2015 increased by 7.2% from 2014 to 35092 individuals.  The goal of this project is to analyze traffic fatality and supporting data to identify spatial patterns and factors that are related to fatal traffic incidents.  Additionally, the 2014 and 2015 data will be compared in detail to identify specific segments of the population that saw increased fatalities.

### 2)  Who is your client and why do they care about this problem? What will they DO or DECIDE based on your analysis that they wouldn't have otherwise?
This project is interesting to state and local planners, law enforcement, and driving instructors.  This results will identify communities that are at higher risk of fatal crashes and also identify contributing risk factors likely to be involved, such as speeding, intoxicated driving, and adverse weather.  These insights could inform targeted campaigns to reduce the risk factors or help police be better prepared.

### 3) What data are you going to use for this?  How will you acquire the data?

*Main dataset:* [Fatality analysis reporting system data on fatal traffic crashes in 2014 and 2015](https://data.world/nhtsa/fars-data)

*Supporting datasets:* 

[US Census data](https://www.census.gov/data.html), which is needed to standardize county- and state-wide statistics by population size 

Additional street characteristics from [OpenStreetMaps](https://www.openstreetmap.org/about) Features include: maxspeed, width, number of lanes 

Weather data from [NOAA weather stations](https://www.ncdc.noaa.gov/data-access/land-based-station-data) or [weather underground API](https://www.wunderground.com/weather/api/)

### 4) In brief, outline your approach to solving this problem

a) spatial statistics to identify areas with a high density of fatalities and variation in predictor variables

b) detailed comparison of 2014 to 2015 data to ask if certain regions or population segments had increased fatalities or if it was an across the board increase

c) cluster analysis of fatal accidents, based on characteristics, and geospatial analysis of clusters

### 5) What are your deliverables?
I will deliver documented code describing my analyses and a slide deck including visualizations and major results.  Included in the visualizations will be maps detailing population-adjusted traffic fatality rate and the prevalence of identified risk factors



