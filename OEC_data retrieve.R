
## set Working directory

setwd("C:\\Users\\CcHUB\\Desktop\\SCI&Trade")


{# packages
  library(jsonlite)
  library(dplyr)
  library(tidyr)
  library(countrycode)
  library(readr)
  library(WDI)
  library(writexl)
  library(lubridate)
  library(rio)
}
## Get data
#################################################################################################################################################
#################################################################################################################################################
### total imports and exports

# countries <- tolower(countrycode(c("Algeria", "Angola", "Benin", "Botswana", "Burkina Faso", "Burundi", "Cameroon", "Cape Verde", 
#                                               "Central African Republic", "Chad", "Comoros", "Congo - Brazzaville", "Cote d'Ivoire", "Djibouti", 
#                                               "Egypt", "Equatorial Guinea", "Eritrea", "Ethiopia", "Gabon", "Gambia", "Ghana", "Guinea", "Guinea-Bissau", 
#                                               "Kenya", "Lesotho", "Liberia", "Libya", "Madagascar", "Malawi", "Mali", "Mauritania", "Mauritius", "Morocco", 
#                                               "Mozambique", "Namibia", "Niger", "Nigeria", "Rwanda", "sao tome & principe", "Senegal", "Seychelles", "Sierra Leone", 
#                                               "Somalia", "South Africa", "Sudan", "Eswatini", "Tanzania", "Togo", "Tunisia", "Uganda", "Zambia", "Zimbabwe", "Congo - Kinshasa", 
#                                               "South Sudan"), origin = "country.name", destination = "iso3c"))  
# 
# link_raw_imp <- "https://oec.world/olap-proxy/data?cube=trade_i_baci_a_92&drilldowns=Year,HS4&measures=Trade%20Value&parents=true&Year=2021&Importer%20Country=afcountry"
# link_raw_exp <- "https://oec.world/olap-proxy/data?cube=trade_i_baci_a_92&drilldowns=Year,HS4&measures=Trade%20Value&parents=true&Year=2021&Exporter%20Country=afcountry"
# 
# commodities_imports <- data.frame()
# commodities_exports <- data.frame()
# 
# for (i in countries) {
# 
#     link_final_imp= gsub("country", i, link_raw_imp)
#     mydata_imp <- fromJSON(link_final_imp)
#     
#     if (nrow(as.data.frame(mydata_imp[[1]])) != 0) {
#     json_file_imp <- lapply(mydata_imp$data, function(x) {
#       x[sapply(x, is.null)] <- NA
#       unlist(x)
#     })
#     df_imp<-as.data.frame(do.call("cbind", json_file_imp)) %>% select(year=Year, commodities_code=`HS4 ID`, commodities=HS4, imports_value=`Trade Value`)
#     df_imp <- df_imp %>% mutate(importing_country_iso = i, imports_value=as.numeric(imports_value))
#     commodities_imports <- rbind.data.frame(commodities_imports, df_imp)
#     }
#     
# #################################################################################################################################################
#     
#     link_final_exp= gsub("country", i, link_raw_exp)
#     mydata_exp <- fromJSON(link_final_exp)
#     if (nrow(as.data.frame(mydata_exp[[1]])) != 0) {
#     json_file_exp <- lapply(mydata_exp$data, function(x) {
#       x[sapply(x, is.null)] <- NA
#       unlist(x)
#     })
#     df_exp<-as.data.frame(do.call("cbind", json_file_exp)) %>% select(year=Year, commodities_code=`HS4 ID`, commodities=HS4, exports_value=`Trade Value`)
#     df_exp <- df_exp %>% mutate(exporting_country_iso = i, exports_value=as.numeric(exports_value))
#     commodities_exports <- rbind.data.frame(commodities_exports, df_exp)
#     }
#     
#     print(i)
# }
# 
# #################################################################################################################################################
# #################################################################################################################################################
# 
# ## create dataset for possible trade 
# countries <- unique(commodities_exports$exporting_country_iso)
# commodities_intersection <- data.frame()
# 
# for (i in countries) { # exporting country
#   
#   for (j in countries) { # importing country
#     
#     if (i!=j){ # find intersections if exporting and importing countries are different
#       
#       comodities_exp <- commodities_exports %>% filter(exporting_country_iso == i) %>% select(exporting_country_iso, commodities, commodities_code, supply=exports_value)
#       comodities_exp <- comodities_exp %>% filter(commodities !="NA")
#       comodities_exp <- comodities_exp %>% filter(!duplicated(commodities))
# 
#       comodities_imp <- commodities_imports %>% filter(importing_country_iso == j) %>% select(importing_country_iso, commodities, commodities_code, demand=imports_value)
#       comodities_imp <- comodities_imp %>% filter(commodities !="NA")
#       comodities_imp <- comodities_imp %>% filter(!duplicated(commodities))
#       
#       df_long = inner_join(comodities_exp, comodities_imp)
#       df_long=distinct(df_long) # removes commodities duplicate
#       
#       df_long <- df_long %>% select(exporting_country_iso,importing_country_iso, commodities, commodities_code, supply,demand) # re-arrange columns
#       df_long$commodities_count <- nrow(df_long) # calculate commodities intersections
#       commodities_intersection <- rbind(commodities_intersection, df_long)  #add new rows into existing dataframe
#     }
#   }
# }
# 
# #################################################################################################################################################
# #################################################################################################################################################
# ### country - country current trading
# 
# link <- "https://oec.world/olap-proxy/data?cube=trade_i_baci_a_92&drilldowns=Year,HS4&measures=Trade%20Value&parents=true&Year=2021&Exporter%20Country=afexit&Importer%20Country=afentry"
# 
# commodities_flow <- data.frame()
# 
# xx <- countries
# 
# for (i in xx) { # exporting country
# 
#   for (j in countries) { # importing country
#     
#     if (i!=j){
#       
#       link_exit= gsub("exit", i, link)
#       modified_link= gsub("entry", j, link_exit)
#       
#       
#       mydata <- fromJSON(modified_link)
#       
#       json_file <- lapply(mydata$data, function(x) {
#         x[sapply(x, is.null)] <- NA
#         unlist(x)
#       })
#       if (length(json_file)!=0) {
#         df<-as.data.frame(do.call("cbind", json_file)) %>% select(commodities = HS4, commodities_code = `HS4 ID`, export_value=`Trade Value`)
#         
#         df$export = i
#         df$import = j
#         df$export_value = as.numeric(df$export_value)
#         
#         commodities_flow <- rbind.data.frame(commodities_flow, df)
#       }
#       print(paste0(i, " & ", j))    
#       
#     }
#   }
# }
# 
# 
#   # a = which(grepl(i, countries))-1
#   # xx=countries[-c(1:a)]
#   # commodities_flow <- commodities_flow %>% filter(export != i)
#   
# 
# commodities_flow <- commodities_flow %>% rename(importing_country_iso=import, exporting_country_iso=export)
# 
# commodities_data <- full_join(commodities_intersection, commodities_flow) %>%
#   subset(!is.na(supply))
# 
# 
# trade_value_data <- commodities_flow %>% 
#   group_by(exporting_country_iso,importing_country_iso) %>% 
#   summarise(trade_value=sum(export_value))

### Load save data (2021)
load("C:/Users/CcHUB/Desktop/SCI&Trade/2021_Trade_Data.RData")


### SCI Data
SCI_Index <- import(file = "https://data.humdata.org/dataset/e9988552-74e4-4ff4-943f-c782ac8bca87/resource/35ca6ade-a5bd-4782-b266-797169dca74b/download/countries-countries-fb-social-connectedness-index-october-2021.tsv") %>% 
  mutate(user_loc=ifelse(is.na(user_loc), "NA",user_loc),
         fr_loc=ifelse(is.na(fr_loc), "NA",fr_loc)) 

SCI_Index <- SCI_Index %>% 
  mutate(exporting_country_iso = tolower(countrycode(user_loc, origin = 'iso2c', destination = 'iso3c')), 
         importing_country_iso = tolower(countrycode(fr_loc, origin = 'iso2c', destination = 'iso3c'))) %>% 
  subset(exporting_country_iso %in% countries & importing_country_iso %in% countries & exporting_country_iso!=importing_country_iso) %>%
  select(exporting_country_iso, importing_country_iso, scaled_sci)

total_import <- commodities_imports %>% group_by(importing_country_iso) %>% summarise(importing_total_import=n())



### GDP Data
country=countrycode(countries, origin = 'iso3c', destination = 'iso2c')


GDP_data = WDI(indicator=c('NY.GDP.MKTP.CD', 'NY.GDP.PCAP.CD'), country=country, start=2021, end=2021)
GDP_data <- GDP_data %>% 
  mutate(country = countrycode(country, origin = 'country.name', destination = 'country.name'), iso2c = NULL, year = NULL) %>% 
  rename(gdp =NY.GDP.MKTP.CD, gdp_per_capita=NY.GDP.PCAP.CD)


### Region Data

ECOWAS_countries= c("Benin","Burkina Faso", "Republic of Cabo Verde", "Gambia","Ghana", "Guinea","Guinea-Bissau","Cote d'Ivoire", "Liberia", "Mali", "Niger", "Nigeria", "Senegal", "Sierra Leone", "Togo")
ECOWAS <-cbind.data.frame(country=ECOWAS_countries, REC= rep("ECOWAS", length(ECOWAS_countries)))

EAC_countries <- c("Burundi", "Kenya", "Uganda", "Rwanda", "Tanzania", "South Sudan")
EAC <- cbind.data.frame(country=EAC_countries, REC=rep("EAC", length(EAC_countries)))

ECCAS_countries <- c("Angola", "Burundi", "Cameroon", "Central African Republic", "Congo Republic", "DRC", "Gabon", "Equatorial Guinea", "Sao Tome & Prencipe", "Chad", "Rwanda")
ECCAS <- cbind.data.frame(country=ECCAS_countries, REC=rep("ECCAS", length(ECCAS_countries)))


SADC_countries <- c("Angola", "Botswana", "Comoros", "Lesotho", "Madagascar", "Malawi", "Mauritius", "Mozambique", "Namibia", "DRC", "Seychelles", "South Africa", "Swaziland", "Tanzania", "Zambia", "Zimbabwe")
SADC <- cbind.data.frame(country=SADC_countries, REC=rep("SADC", length(SADC_countries)))

IGAD_countries <- c("Djibouti","Eritrea", "Ethiopia", "Kenya", "Uganda", "Somalia","South Sudan", "Sudan")
IGAD <- cbind.data.frame(country=IGAD_countries, REC=rep("IGAD", length(IGAD_countries)))


CENSAD_countries <- c("Benin", "Burkina Faso", "Central African Republic", "Comoros", "Djibouti", "Egypt", "Eritrea", "Gambia", "Ghana", "Guinea-Bissau", "Cote d'Ivoire", "Kenya", "Liberia", "Libya", "Mali",  "Morocco", "Mauritania", "Niger", "Nigeria",  "Senegal", "Sierra Leone", "Somalia", "Sudan", "Chad", "Togo", "Tunisia", "Sao Tome & Prencipe", "Republic of Cabo Verde")
CENSAD <- cbind.data.frame(country=CENSAD_countries, REC=rep("CENSAD", length(CENSAD_countries)))


COMESA_countries <- c("Burundi", "Comoros", "Djibouti", "Egypt", "Eritrea", "Ethiopia", "Kenya", "Madagascar", "Malawi", "Mauritius", "Uganda", "DRC", "Rwanda", "Seychelles", "Sudan", "Swaziland", "Zambia", "Zimbabwe", "Tunisia", "Libya", "Somalia")
COMESA <- cbind.data.frame(country=COMESA_countries, REC=rep("COMESA", length(COMESA_countries)))

AMU_countries <- c("Algeria", "Libya", "Morocco", "Mauritania", "Tunisia")
AMU <- cbind.data.frame(country=AMU_countries, REC=rep("AMU", length(AMU_countries)))

RECs_Data<- rbind.data.frame(AMU, CENSAD, COMESA, EAC, ECCAS, ECOWAS, IGAD, SADC)

RECs_Data<- RECs_Data %>% group_by(country) %>% summarise(recs=paste(unlist(REC), collapse='; '))

RECs_Data <- RECs_Data %>% mutate(country = countrycode(country, origin = 'country.name', destination = 'country.name'))


N_Africa=countrycode(c("Algeria","Egypt","Libya","Mauritania", "Morocco", "Tunisia"), origin = 'country.name', destination = 'country.name') 
#
E_Africa= countrycode(c("Comoros", "Djibouti", "Eritrea", "Ethiopia", "Kenya", "Madagascar", "Mauritius", "Rwanda", "Seychelles", "Somalia", "South Sudan", "Sudan", "Tanzania", "Uganda"), origin = 'country.name', destination = 'country.name')
#
C_Africa = countrycode(c("Burundi", "Cameroon", "Central African Republic", "Chad", "Democratic Republic of the Congo", "Republic of the Congo", "Equatorial Guinea", "Gabon", "Sao Tome & Prencipe"), origin = 'country.name', destination = 'country.name')
#
W_Africa = countrycode(c("Benin", "Burkina Faso", "Cape Verde", "Ivory Coast", "Gambia", "Ghana", "Guinea", "Guinea-Bissau", "Liberia", "Mali", "Niger", "Nigeria", "Senegal", "Sierra Leone", "Togo"), origin = 'country.name', destination = 'country.name')
#
S_Africa = countrycode(c("Angola", "Botswana", "Eswatini (Swaziland)", "Lesotho","Malawi", "Mozambique", "Namibia", "South Africa", "Zambia", "Zimbabwe"), origin = 'country.name', destination = 'country.name')

RECs_Data <- RECs_Data %>% mutate(region= ifelse(country %in% N_Africa, "Northern Africa",         
                                                 ifelse(country %in% E_Africa, "Eastern Africa", ifelse(country %in% C_Africa, "Central Africa", ifelse(country %in% W_Africa, "Western Africa", ifelse(country %in% S_Africa, "Southern Africa", NA))))))


country_info <- GDP_data %>% full_join(RECs_Data) %>% 
  mutate(country_iso = tolower(countrycode(country, origin = 'country.name', destination = 'iso3c'))) %>%
  subset(country_iso %in% countries)

export_country_info <- country_info
import_country_info <- country_info

colnames(export_country_info) <- paste("exporting", colnames(export_country_info), sep = "_")
colnames(import_country_info) <- paste("importing", colnames(import_country_info), sep = "_")

### Distance & Language data
distance_language <- read_csv("distance_language.csv")

distance_language <- distance_language %>% subset(iso_o %in% toupper(countries) & iso_d %in% toupper(countries))

distance_language <- distance_language %>% subset(iso_o!=iso_d) %>% rename(importing_country_iso=iso_d, exporting_country_iso=iso_o) %>%
  mutate(exporting_country_iso=tolower(exporting_country_iso), importing_country_iso=tolower(importing_country_iso))


### Data merge
country_to_country_data <- trade_value_data %>% full_join(distance_language, by=c("exporting_country_iso", "importing_country_iso"))

country_to_country_data <- country_to_country_data %>% full_join(SCI_Index, by=c("exporting_country_iso", "importing_country_iso"))

country_to_country_data <- country_to_country_data %>% full_join(total_import, by=c("importing_country_iso"))

comprehensive_dataset <- country_to_country_data %>% full_join(commodities_data) %>% 
  full_join(export_country_info, by=c("exporting_country_iso")) %>% 
  full_join(import_country_info, by=c("importing_country_iso"))

#################################################################################################################################################
#################################################################################################################################################

### Index estimation
### POPI

mydata <- comprehensive_dataset %>% mutate(pp=log(demand)/log(supply),
                                           l_sci=log(scaled_sci)) %>% 
  group_by(exporting_country_iso, commodities)  %>%
  summarise(importing_country_iso=importing_country_iso,
            pp1=ifelse(pp >= 1, 1, ifelse(pp < 1, pp,0)),
            k_sci=l_sci/max(l_sci, na.rm = T),
            commodity_index=((pp1+k_sci)/2)*100) %>% drop_na() %>% arrange(-commodity_index)

comprehensive_dataset_long <- full_join(mydata, comprehensive_dataset) %>% mutate(year=2021) %>%
  select(-c(pp1,k_sci, Origin,Destination))


comprehensive_dataset_wide <- comprehensive_dataset_long %>% 
  group_by(exporting_country_iso, exporting_country, importing_country_iso, importing_country, exporting_gdp, importing_gdp,
           exporting_gdp_per_capita, importing_gdp_per_capita, exporting_recs, importing_recs, exporting_region, importing_region,
           dist, distcap, contig, comcol, comlang_off, scaled_sci,trade_value, importing_total_import, year) %>% arrange(export_value) %>%
  
  summarise(commodities=paste(unlist(commodities), collapse=';'),
            commodities_code=paste(unlist(commodities_code), collapse=';'),
            demand=paste(unlist(demand), collapse=';'),
            export_value=paste(unlist(export_value), collapse=';'), 
            supply=paste(unlist(supply), collapse=';'),
            commodity_index=paste(unlist(commodity_index), collapse=';'),
            commodities_count=max(commodities_count, na.rm = TRUE)) %>%
  ungroup()


# write.csv(comprehensive_dataset_wide, file = "comprehensive_dataset_wide.csv", row.names = FALSE)
# write.csv(comprehensive_dataset_long, file = "comprehensive_dataset_long.csv", row.names = FALSE)
##################################################################################################################################################

## Country Index
sci_coeff <- 0.157
imports_coeff <- 0.627

mydata <- comprehensive_dataset_wide %>% group_by(exporting_country_iso) %>%
  mutate(k_sci=(scaled_sci/max(scaled_sci, na.rm = T))*(exp(sci_coeff)-1), 
         k_product=(commodities_count/importing_total_import)*(exp(imports_coeff)-1)) %>% ungroup()


mydata <- mydata %>% group_by(exporting_country_iso, importing_country_iso, 
                              commodities, commodities_code, export_value, commodities_count, importing_total_import, trade_value, 
                              dist, distcap, comcol, contig, comlang_off, scaled_sci) %>% 
  summarise(Opportunity_Index=(100*(sum(c(k_sci,k_product), na.rm = TRUE)))/1.04) %>% ungroup() %>% arrange(-Opportunity_Index) 

mydata <- mydata %>%
  mutate(Opportunity_Index = Opportunity_Index/max(Opportunity_Index, na.rm = T))


Country_opp_index <- mydata %>% group_by(exporting_country_iso) %>% summarise(Country_Index= mean(Opportunity_Index)) %>% ungroup()

mydata <- mydata %>% full_join(Country_opp_index, by=c("exporting_country_iso")) %>% 
  # rename(Exporting_country=Origin, Importing_country=Destination) %>%
  mutate(exporting_country_iso=toupper(exporting_country_iso), importing_country_iso=toupper(importing_country_iso))

