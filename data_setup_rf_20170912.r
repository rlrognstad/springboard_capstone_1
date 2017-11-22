library(tidyverse)

#consumption
consumption <- read.table("~/github/springboard_capstone_1/alcohol_consumption/state_consumption_data_2.csv", sep = ',', header = TRUE) %>%
  mutate(GEO_ID = as.numeric(as.character(GEO_ID)))

data_source <- read.table("~/github/springboard_capstone_1/alcohol_consumption/data_source.csv", sep = ',', header = TRUE)

state_codes <- read.table("~/github/springboard_capstone_1/alcohol_consumption/state_codes.csv", sep = ',', header = TRUE)%>%
  mutate(GEO_ID = as.numeric(as.character(GEO_ID)))

bev_type <- read.table("~/github/springboard_capstone_1/alcohol_consumption/bev_type.csv", sep = ',', header = TRUE)


combo <- consumption %>%
  left_join(data_source, by = "DATA_SOURCE_CODE") %>%
  left_join(state_codes, by = "GEO_ID") %>%
  left_join(bev_type, by = "BEVERAGE_TYPE_CODE") %>%
  filter(BEVERAGE_TYPE == "All_beverages",
         GEO_ID %in% 1:56, 
         YEAR >= 2010) %>%
  select(one_of(c("YEAR", "GALLONS_ALCOHOL", "GALLONS_ALCOHOL_PER_CAP_21", "DECILE_21",  "STATE", "GEO_ID"))) %>%
  mutate(STATE = substr(as.character(STATE), 2, nchar(as.character(STATE))))

#png(file = "e:/personal/traffic_project/consumption_1_5_10.png",  units = "in", width = 14, height = 7, res = 500)
ggplot(filter(combo, DECILE_21 %in% c(1,5,10))) + geom_point(aes(x = YEAR, y = GALLONS_ALCOHOL_PER_CAP_21, color = STATE),size = 5, alpha = .7) + 
  facet_grid(~DECILE_21)+
  theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
        axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
        panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
        legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))
#dev.off()		

#png(file = "e:/personal/traffic_project/consumption_1_10.png",  units = "in", width = 14, height = 7, res = 500)		
ggplot(filter(combo, DECILE_21 %in% c(1,10))) + geom_point(aes(x = YEAR, y = GALLONS_ALCOHOL_PER_CAP_21, color = STATE),size = 5, alpha = .7) + 
  facet_grid(~DECILE_21)+
  theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
        axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
        panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
        legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))
#dev.off()		

#taxes
beer <- read.table("~/github/springboard_capstone_1/alcohol_consumption/data/TX1B - ChangesOverTime.csv", sep = ",", header = TRUE)
colnames(beer)[c(1,4)] <- c("STATE_CODE", "BEER_TAX")
beer <- beer %>%
  select(one_of(c("STATE_CODE" ,"BEER_TAX"))) %>%
  mutate(BEER_TAX = as.numeric(substr(BEER_TAX, 2, nchar(as.character(BEER_TAX))))) %>%
  group_by(STATE_CODE) %>%
  summarize(BEER_TAX = max(BEER_TAX))

wine <- read.table("~/github/springboard_capstone_1/alcohol_consumption/data/TX2W - ChangesOverTime.csv", sep = ",", header = TRUE)
colnames(wine)[c(1,4)] <- c("STATE_CODE", "WINE_TAX")

wine <- wine %>%
  select(one_of(c("STATE_CODE" ,"WINE_TAX"))) %>%
  mutate(WINE_TAX = as.numeric(substr(WINE_TAX, 2, nchar(as.character(WINE_TAX)))))%>%
  group_by(STATE_CODE) %>%
  summarize(WINE_TAX = max(WINE_TAX))

spirits <- read.table("~/github/springboard_capstone_1/alcohol_consumption/data/TX3S - ChangesOverTime.csv", sep = ",", header = TRUE)
colnames(spirits)[c(1,4)] <- c("STATE_CODE", "SPIRITS_TAX")
spirits <- spirits %>%
  select(one_of(c("STATE_CODE" ,"SPIRITS_TAX"))) %>%
  mutate(SPIRITS_TAX = as.numeric(substr(SPIRITS_TAX, 2, nchar(as.character(SPIRITS_TAX)))))%>%
  group_by(STATE_CODE) %>%
  summarize(SPIRITS_TAX = max(SPIRITS_TAX))

all_tax <- beer %>% 
  left_join(wine, by = "STATE_CODE") %>%
  left_join(spirits, by = "STATE_CODE") %>%
  mutate(STATE_CODE = as.character(STATE_CODE))

state_codes <- read.table("~/github/springboard_capstone_1/alcohol_consumption/data/state_codes.csv", sep = ",", header = TRUE) %>%
  select(-STATENS) %>%
  filter(STATE <= 56) %>%
  mutate(STATE_LONG = as.character(STATE_LONG))
colnames(state_codes) <- c("STATE_NUM", "STATE_CODE", "STATE")


combo_tax <- combo %>%
  left_join(state_codes,  by = "STATE") %>%
  left_join(all_tax, by = "STATE_CODE")

tax_long <- combo_tax %>%
  gather("TYPE", "TAX", BEER_TAX:SPIRITS_TAX)

#png(file = "e:/personal/traffic_project/taxes_consumption.png",  units = "in", width = 14, height = 7, res = 500)
ggplot(tax_long) + geom_point(aes(x = TAX, y = GALLONS_ALCOHOL_PER_CAP_21), size = 5, alpha = 0.7) + facet_grid(~TYPE, scales="free_x") +
  geom_smooth(aes(x = TAX, y = GALLONS_ALCOHOL_PER_CAP_21)) +
  theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
        axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
        panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
        legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))
#dev.off()	

ggplot(combo_tax) + geom_point(aes(x = BEER_TAX, y = GALLONS_ALCOHOL_PER_CAP_21, color = YEAR))			

#read in FARS data
acc_dui <- read.csv("~/github/springboard_capstone_1/alcohol_consumption/data/alcohol_dui.csv", sep = ",",  header = TRUE)

#combine with law data
colnames(tax_long)[colnames(tax_long) == "STATE"] <- "STATE_LONG"
colnames(tax_long)[colnames(tax_long) == "STATE_NUM"] <- "STATE"
colnames(tax_long)[colnames(tax_long) == "STATE_CODE"] <- "STATE_SHORT"
all_dui <- acc_dui %>%
  left_join(tax_long, by = c("YEAR", "STATE", "STATE_LONG", "STATE_SHORT"))

ggplot(data = all_dui) + geom_point(aes(x = GALLONS_ALCOHOL_PER_CAP_21, y = ACH_MIL), size = 3, alpha = 0.3)+ 
  geom_smooth(aes( x = GALLONS_ALCOHOL_PER_CAP_21, y = ACH_MIL)) +
  theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
        axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
        panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
        legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))

ggplot(data = all_dui,aes(x = POP_MIL, y = ACH_MIL)) + geom_point( size = 3, alpha = 0.3)+ 
  geom_smooth() +
  theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
        axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
        panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
        legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))


ggplot(data = dui_tax_short,aes(x = BEER_TAX, y = ACH_MIL)) + geom_point( size = 3, alpha = 0.3)+ 
  geom_smooth() +
  theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
        axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
        panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
        legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))

#new predictor data
#household income and poverty rate
income <- read.table("~/github/springboard_capstone_1/census_data/household_income.csv", sep = ",", header = TRUE)
income <- income[,c(1,4,10,41)]
colnames(income)  <- c("YEAR","STATE_LONG", "PERCENT_POVERTY", "MEDIAN_INCOME")
income <- income %>%
          mutate(MEDIAN_INCOME = as.numeric(paste0(substr(as.character(MEDIAN_INCOME), 2, 3), substr(as.character(MEDIAN_INCOME), 5,7))),
                 PERCENT_POVERTY = as.numeric(PERCENT_POVERTY))

#insured
insure <- read.table("~/github/springboard_capstone_1/census_data/uninsured.csv", sep = ",", header = TRUE)
insure <- insure[,c(5,7,12)]
colnames(insure)  <- c("YEAR","STATE_LONG", "PERCENT_UNINSURE")

#education
ed11 <- read.table("~/github/springboard_capstone_1/census_data/edu_2011.csv", sep = ",", header = TRUE)
ed12 <- read.table("~/github/springboard_capstone_1/census_data/edu_2012.csv", sep = ",", header = TRUE)
ed13 <- read.table("~/github/springboard_capstone_1/census_data/edu_2013.csv", sep = ",", header = TRUE)
ed14 <- read.table("~/github/springboard_capstone_1/census_data/edu_2014.csv", sep = ",", header = TRUE)
ed15 <- read.table("~/github/springboard_capstone_1/census_data/edu_2015.csv", sep = ",", header = TRUE)

ed_all <- ed11 %>%
      bind_rows(ed12) %>%
      bind_rows(ed13) %>%
      bind_rows(ed14) %>%
      bind_rows(ed15) %>%
      mutate(LESS_HS_P = LESS_HIGH_SCHOOL / TOTAL, 
             HS_P = HIGH_SCHOOL / TOTAL, 
             SOME_C_P = SOME_COLLEGE / TOTAL, 
             BACHELORS_P = BACHELORS / TOTAL, 
             GRAD_PROF_P = GRADUATE_PROFESSIONAL / TOTAL,
             STATE_LONG = as.character(STATE_LONG))

all_dui_2 <- all_dui %>%
            left_join(income, by = c("YEAR", "STATE_LONG")) %>%
            left_join(insure, by = c("YEAR", "STATE_LONG")) %>%
            left_join(ed_all, by = c("YEAR", "STATE_LONG"))


unique(ed_all$STATE_LONG[!(ed_all$STATE_LONG %in% all_dui$STATE_LONG)])

##########################################
#build model
library(randomForest)

dui_tax_short <- spread(all_dui_2, TYPE, TAX) %>%
                select(one_of(c("ACC_MIL", "ACH_MIL", "YEAR", "STATE_SHORT", "POP_MIL", "SUSPEND", "INTERLOCK_1ST", "INTERLOCK_REPEAT", 
                      "GALLONS_ALCOHOL_PER_CAP_21", "BEER_TAX","PERCENT_POVERTY", "MEDIAN_INCOME", "PERCENT_UNINSURE", "LESS_HS_P", 
                      "HS_P", "SOME_C_P", "BACHELORS_P", "GRAD_PROF_P"))) %>%
                mutate(STATE_SHORT = as.factor(STATE_SHORT)) %>%
                filter(STATE_SHORT != "DC",
                       YEAR < 2015)
dui_tax_short <- na.omit(dui_tax_short)

dui_rf <- randomForest(ACH_MIL~YEAR + STATE_SHORT + ACC_MIL +POP_MIL + SUSPEND + INTERLOCK_1ST + INTERLOCK_REPEAT + 
                      GALLONS_ALCOHOL_PER_CAP_21 + BEER_TAX + PERCENT_POVERTY + MEDIAN_INCOME + PERCENT_UNINSURE + LESS_HS_P +
                        HS_P + SOME_C_P + BACHELORS_P + GRAD_PROF_P,
                        dui_tax_short[!is.na(dui_tax_short$BEER_TAX),],
                        importance=TRUE)
                       
dui_rf

importance(dui_rf)


dui_rf_2 <- randomForest(ACH_MIL~STATE_SHORT + ACC_MIL +POP_MIL + INTERLOCK_REPEAT + 
                         GALLONS_ALCOHOL_PER_CAP_21 + BEER_TAX,
                       dui_tax_short[!is.na(dui_tax_short$BEER_TAX),],
                       importance=TRUE)
dui_rf_2

importance(dui_rf_2)


dui_rf_3 <- randomForest(ACH_MIL~YEAR + POP_MIL + SUSPEND + INTERLOCK_REPEAT + 
                           GALLONS_ALCOHOL_PER_CAP_21 + BEER_TAX,
                         dui_tax_short[!is.na(dui_tax_short$BEER_TAX),],
                         importance=TRUE, ntree = 100000)
dui_rf_3

importance(dui_rf_3)
plot(dui_rf_3)
varImpPlot(dui_rf_3)
