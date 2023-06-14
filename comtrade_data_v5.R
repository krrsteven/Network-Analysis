# SCITrade & Comtrade data
### Version 2: while loop
### Version 3: while loop and all search for all commodities
### version 4: for loop (reporter country) & while loop (partner countries)
### version 5: use "All" for partner and select african countries later

{
  library(dplyr)
  library(comtradr)
  library(rjson)
  library(writexl)
  library(profvis)
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
  ) %>%
  subset(
    nchar(id) == 4
  )

### get data

inter_trade_data <- data.frame()

# for (k in commodities$id) {
k <- 1
while(k < 1246) {
  i <- 1
  while (i < 51) {
    print(paste0("remaining hourly queries: ", ct_get_remaining_hourly_queries()))    
    print(paste("commodityies: ", commodities$id[k:(k+19)]))
    # print(africa_countries[i:(i+4)])
    print(paste("Reporters: ", africa_countries[i:(i+4)], collapse = ","))
    
    if(ct_get_remaining_hourly_queries()==0){
      write_xlsx(inter_trade_data, "tradedata.xlsx")
      wait_time=as.numeric((ct_get_reset_time()-Sys.time()))*60
      while(wait_time > 5) {
        # Sleep for 0.1 seconds
        Sys.sleep(10)
        wait_time <- as.numeric((ct_get_reset_time()-Sys.time()))*60+10
        # Print progress
        print(paste("Waiting time:", round(wait_time), "Secs"))
      }      # profvis::pause(wait_time)
    }
    
    xx <- ct_search(
      start_date = 2022,
      end_date = 2022,
      reporters = africa_countries[i:(i+4)],
      partners = "All",
      trade_direction = c(
        "imports", 
        "exports"
      ),
      commod_codes = commodities$id[k:(k+19)]
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
    ) %>%
      subset(
        partner %in%
          africa_countries
      )
    
    inter_trade_data <- inter_trade_data %>% 
      rbind.data.frame(
        xx
      )
    i = i+5
  }
  k = k+20
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


rda_mine <- data.frame()

for (i in africa_countries) {
  xx = ct_search(reporters = "Rwanda",
                 partners = i,
                 start_date = 2022,
                 end_date = 2022,
                 commod_codes = unlist(commodities$id)[2])
  
  rda_mine <- rda_mine %>%
    rbind.data.frame(xx)
}
