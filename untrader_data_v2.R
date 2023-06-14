### bilateral trade in 54 african countries, all available commodities

library(untrader)
library(rjson)
library(stringr)
library(countrycode)
library(dplyr)
set_primary_comtrade_key(key = "bf84f1fccc784033bc9ba4af3c450353")


africa_countries <- countrycode(c("Algeria", "Angola", "Benin", "Botswana", "Burkina Faso", "Burundi",
                                  "Cameroon", "Cape Verde", "Central African Republic", "Chad", "Comoros",
                                  "Republic of the Congo", "Cote d'Ivoire", "Djibouti", "Egypt", "Zambia",
                                  "Equatorial Guinea", "Eritrea", "Ethiopia", "Gabon", "Gambia", "Ghana",
                                  "Guinea", "Guinea-Bissau", "Kenya", "Lesotho", "Liberia", "Libya",
                                  "Madagascar", "Malawi", "Mali", "Mauritania", "Mauritius", "Morocco",
                                  "Mozambique", "Namibia", "Niger", "Nigeria", "Rwanda", "Zimbabwe",
                                  "sao tome & principe", "Senegal", "Seychelles", "Sierra Leone",
                                  "Somalia", "South Africa", "Sudan", "Eswatini", "Tanzania", "Togo",
                                  "Tunisia", "Uganda", "Democratic Republic of the Congo",
                                  "South Sudan"), origin = "country.name", destination = "iso3c")

commodities <- data.frame(
  t(sapply(fromJSON(file="https://comtrade.un.org/Data/cache/classificationHS.json")[["results"]], c)
  )) %>%
  mutate(id = unlist(id),
         text = unlist(text),
         parent = unlist(parent)) %>%
  subset(nchar(id) == 4)

## get bilateral data
bilateral_data_4 <- get_comtrade_data(frequency =  'A',
                             commodity_classification = 'HS',
                             commodity_code = commodities$id[c(1001:1266)],
                             flow_direction = c('export', 'import'),
                             partner = africa_countries,
                             reporter = africa_countries,
                             start_date = "2022",
                             end_date = "2022",
                             verbose = T,
                             process = T) %>%
  select(orgin = reporterDesc, partner = partnerDesc,
         flow = flowDesc, hs_code = aggrLevel, year = refYear,
         commodity = cmdDesc, commodity_code = cmdCode,
         quantity = qty, qtyUnit = qtyUnitAbbr, trade_value = primaryValue)


bilateral_data <- bilateral_data %>%
  rbind.data.frame(bilateral_data_2) %>%
  rbind.data.frame(bilateral_data_3) %>%
  rbind.data.frame(bilateral_data_4)
