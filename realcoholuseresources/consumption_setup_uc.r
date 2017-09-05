library(tidyverse)

#consumption
consumption <- read.table("e:/personal/traffic_project/realcoholuseresources/state_consumption_data_2.csv", sep = ',', header = TRUE) %>%
              mutate(GEO_ID = as.numeric(as.character(GEO_ID)))

data_source <- read.table("e:/personal/traffic_project/realcoholuseresources/data_source.csv", sep = ',', header = TRUE)

state_codes <- read.table("e:/personal/traffic_project/realcoholuseresources/state_codes.csv", sep = ',', header = TRUE)%>%
    mutate(GEO_ID = as.numeric(as.character(GEO_ID)))

bev_type <- read.table("e:/personal/traffic_project/realcoholuseresources/bev_type.csv", sep = ',', header = TRUE)


combo <- consumption %>%
        left_join(data_source, by = "DATA_SOURCE_CODE") %>%
        left_join(state_codes, by = "GEO_ID") %>%
        left_join(bev_type, by = "BEVERAGE_TYPE_CODE") %>%
        filter(BEVERAGE_TYPE == "All_beverages",
               GEO_ID %in% 1:56, 
               YEAR >= 2010) %>%
        select(one_of(c("YEAR", "GALLONS_ALCOHOL", "GALLONS_ALCOHOL_PER_CAP_21", "DECILE_21",  "STATE", "GEO_ID"))) %>%
		mutate(STATE = substr(as.character(STATE), 2, nchar(as.character(STATE))))

png(file = "e:/personal/traffic_project/consumption_1_5_10.png",  units = "in", width = 14, height = 7, res = 500)
ggplot(filter(combo, DECILE_21 %in% c(1,5,10))) + geom_point(aes(x = YEAR, y = GALLONS_ALCOHOL_PER_CAP_21, color = STATE),size = 5, alpha = .7) + 
	facet_grid(~DECILE_21)+
	theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
		axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
		panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
		legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))
dev.off()		

png(file = "e:/personal/traffic_project/consumption_1_10.png",  units = "in", width = 14, height = 7, res = 500)		
ggplot(filter(combo, DECILE_21 %in% c(1,10))) + geom_point(aes(x = YEAR, y = GALLONS_ALCOHOL_PER_CAP_21, color = STATE),size = 5, alpha = .7) + 
	facet_grid(~DECILE_21)+
	theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
		axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
		panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
		legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))
dev.off()		
	
#taxes
beer <- read.table("e:/personal/traffic_project/data/TX1B - ChangesOverTime.csv", sep = ",", header = TRUE)
colnames(beer)[c(1,4)] <- c("STATE_CODE", "BEER_TAX")
beer <- beer %>%
		select(one_of(c("STATE_CODE" ,"BEER_TAX"))) %>%
		mutate(BEER_TAX = as.numeric(substr(BEER_TAX, 2, nchar(as.character(BEER_TAX))))) %>%
		group_by(STATE_CODE) %>%
		summarize(BEER_TAX = max(BEER_TAX))
	
wine <- read.table("e:/personal/traffic_project/data/TX2W - ChangesOverTime.csv", sep = ",", header = TRUE)
colnames(wine)[c(1,4)] <- c("STATE_CODE", "WINE_TAX")
wine <- wine %>%
		select(one_of(c("STATE_CODE" ,"WINE_TAX"))) %>%
		mutate(WINE_TAX = as.numeric(substr(WINE_TAX, 2, nchar(as.character(WINE_TAX)))))%>%
		group_by(STATE_CODE) %>%
		summarize(WINE_TAX = max(WINE_TAX))

spirits <- read.table("e:/personal/traffic_project/data/TX3S - ChangesOverTime.csv", sep = ",", header = TRUE)
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
			
state_codes <- read.table("e:/personal/traffic_project/data/state_codes.csv", sep = ",", header = TRUE) %>%
				select(-STATENS) %>%
				filter(STATE <= 56) %>%
				mutate(STATE_LONG = as.character(STATE_LONG))
colnames(state_codes) <- c("STATE_NUM", "STATE_CODE", "STATE")


combo_tax <- combo %>%
			left_join(state_codes,  by = "STATE") %>%
			left_join(all_tax, by = "STATE_CODE")

tax_long <- combo_tax %>%
			gather("TYPE", "TAX", BEER_TAX:SPIRITS_TAX)

png(file = "e:/personal/traffic_project/taxes_consumption.png",  units = "in", width = 14, height = 7, res = 500)
ggplot(tax_long) + geom_point(aes(x = TAX, y = GALLONS_ALCOHOL_PER_CAP_21), size = 5, alpha = 0.7) + facet_grid(~TYPE, scales="free_x") +
					geom_smooth(aes(x = TAX, y = GALLONS_ALCOHOL_PER_CAP_21)) +
	theme(axis.title.x = element_text(size=20), axis.text.x  = element_text(size=20, angle = 45, hjust = 1), 
		axis.title.y = element_text( size=20), axis.text.y  = element_text(size=20),
		panel.grid.major = element_line(colour = "black"), strip.text.x = element_text(size = 20),
		legend.title = element_text(size=25, face="bold"), legend.text = element_text(size=18))
dev.off()	
			
ggplot(combo_tax) + geom_point(aes(x = BEER_TAX, y = GALLONS_ALCOHOL_PER_CAP_21, color = YEAR))			
			