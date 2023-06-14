# SCITrade & Comtrade data
### Version 2: while loop
### Version 3: while loop and all search for all commodities
### version 4: for loop (reporter country) & while loop (partner countries)

{
  library(dplyr)
  library(comtradr)
  library(rjson)
}
  

### List of Countries
africa_countries <- ct_country_lookup(
  c(
    "Algeria",
    "Angola",
    "Benin",
    "Botswana",
    "Burkina Faso",
    "Burundi",
    "Cameroon",
    "Cabo Verde",
    "Central Africa",
    "Chad",
    "Comoros",
    "Congo",
    "Ivoire",
    "Djibouti",
    "Egypt",
    "Zambia",
    # "Equatorial Guinea",
    "Eritrea",
    "Ethiopia",
    "Gabon",
    "Gambia",
    "Ghana",
    "Guinea",
    # "Guinea-Bissau",
    "Kenya",
    "Lesotho",
    "Liberia",
    "Libya",
    "Madagascar",
    "Malawi",
    "Mali",
    "Mauritania",
    "Mauritius",
    "Morocco",
    "Mozambique",
    "Namibia",
    "Niger",
    "Nigeria",
    "Rwanda",
    "Zimbabwe",
    "sao tome",
    "Senegal",
    "Seychelles",
    "Sierra Leone",
    "Somalia",
    "South Africa",
    "Sudan",
    "Eswatini",
    "Tanzania",
    "Togo",
    "Tunisia",
    # "South Sudan",
    "Uganda"
    # "Democratic Republic of the Congo",
  )
)

africa_countries <- africa_countries[ !africa_countries == 'Papua New Guinea']
### List of all commodities
commodities <- data.frame(
  t(
    sapply(
      fromJSON(file="https://comtrade.un.org/Data/cache/classificationHS.json")[["results"]],
      c
    )
  )
) %>%
    mutate(
    id = unlist(
      id
    ),
    text = unlist(
      text
    ),
    parent = unlist(
      parent
    )
  )

### get data

mydata_ForWhile_allcommodities <- data.frame()

for (k in africa_countries) {

  i <- 1
  while (i < 51) {
    print(
      paste0(
        "reporter: ",
        k,
        " (partner: ",
        africa_countries[i:(i+4)],
        ")"
      )
    )
    
    if(ct_get_remaining_hourly_queries()==0){
      wait_time=as.numeric((ct_get_reset_time()-Sys.time()))*60+10
      profvis::pause(wait_time)
    }
    
    xx <- ct_search(
      start_date = 2022,
      end_date = 2022,
      reporters = k,
      partners = africa_countries[i:(i+4)],
      trade_direction = c(
        "imports", 
        "exports"
      ),
      commod_codes = unlist(commodities$id)[-c(2:6)]
    ) %>% select(
      year,
      HS_level = aggregate_level,
      trade_flow,
      reporter,
      partner,
      commodity_code,
      commodity,
      qty_unit,
      qty,
      trade_value_usd 
    )
    
    mydata_ForWhile_allcommodities <- mydata_ForWhile_allcommodities %>% rbind.data.frame(xx)
    i = i+5
  }
  
}



# for (i in africa_countries) {
#   print(
#     i
#   )
#   xx <- ct_search(
#     start_date = 2022,
#     end_date = 2022,
#     reporters = "Rwanda",
#     partners = i,
#     trade_direction = c(
#       "imports", 
#       "exports"
#     ),
#     commod_codes = "1511"
#   )
#   mydata <- mydata %>% rbind.data.frame(xx)
# }

# data_2022 <- ct_search(
#   start_date = 2022,
#   end_date = 2022,
#   reporters = "Rwanda",
#   partners = africa_countries[5:9],
#   trade_direction = c(
#     "imports", 
#     "exports"
#   ),
#   commod_codes = "0101"
# )
