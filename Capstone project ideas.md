### 1.  Predicting (and preventing) traffic fatalities

Problem: Tens of thousands of people are killed in vehicle-related crashes every year in the United States. Understanding the spatial and temporal patterns of these crashes could inform state and local planners and law enforcement to reduce fatalities by changing infrastructure patterns, local regulations, or driver training.

Dataset(s): Main dataset is US Department of Transportation traffic fatalities dataset: [FARS] (https://www.transportation.gov/fastlane/2015-traffic-fatalities-data-has-just-been-released-call-action-download-and-analyze) 
There is lots of potential to combine other datasets like OpenStreetView, driving behaviour from StreetLight Data or Waze, population data from census, possibly data on speed limits or other traffic laws/regulations. Weather data as it could be interesting because it is related to visibility and other physical driving conditions.

Main question(s): What spatial trends exist in the traffic fatality prevalence data? How are these trends related to predictor variables (weather conditions, traffic conditions, road/infrastructure, etc.)?

Issues: This is a very rich dataset and this project could get out of hand without a focused question. I would need to really narrow it down after some initial exploration. One idea is to focus on pedestrian or cyclist crashes or one city or region.


### 2. Will a bill pass in the senate?

Problem: Changing legislation at a national level can be a time-consuming and unpredictable process. This project would build a model to predicting bill pass probability and the votes of individual senators.

Dataset(s): Voting records and text of bills from the [Senate] (https://www.senate.gov/legislative/votes.htm)

Main question(s): What features can predict the vote of individual senators and the pass rate of bills overall? Some ideas include: state, party, age, past voting record, time to re-election. I could also look at features of the bills themselves at high level, including features like time of year proposed, number of concurrent bills, and total length of text, or really analyse the text using sentiment analysis and text mining.


### 3. Predicting restaurant inspection issues based on Yelp reviews

Problem: Citizens rely on health inspections to ensure food in restaurants is safe and in many cases these inspections occur at random. This project would use Yelp reviews to predict likely inspection violations. City officials could use this information to decide which restaurants to target for inspections and restaurant mangers may be able to use it as an early warning system for detecting problems in their own establishments.

Dataset(s): This project was inspired by a [DrivenData competition](https://www.drivendata.org/competitions/5/keeping-it-fresh-predict-restaurant-inspections/page/33/) that focused on this question in Boston, though there are other cities that publish their health inspection data like [NYC] (https://health.data.ny.gov/Health/Food-Service-Establishment-Last-Inspection/cnih-y5dw/data), [Rochester] (http://rochester.nydatabases.com/database/nys-restaurant-inspections), and [Delaware] (https://data.delaware.gov/Health/Restaurant-Inspection-Violations/384s-wygj/data)

Main question(s): What features of local Yelp reviews or geographic data are related to particular kinds of safety violations in restaurants? Are certain ratings, words, or sentiment in reviews related to specific kinds of violations? 
