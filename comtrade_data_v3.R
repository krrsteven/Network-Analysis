# SCITrade & Comtrade data
### Version 2: while loop
### Version 3: while loop and all search for all commodities

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

### Get Data
# mydata <- data.frame()
# for (i in africa_countries[5:8]) {
  # for (c in unlist(commodities$id)[c(1, 7:100)]) {
  #   print(
  #     paste0(
  #       i,
  #       ": ",
  #       commodities$text[commodities$id==c] 
  #     )
  #   )
  #   
  #   xx <- ct_search(
  #     start_date = 2022,
  #     end_date = 2022,
  #     reporters = "Rwanda",
  #     partners = i,
  #     trade_direction = c(
  #       "imports", 
  #       "exports"
  #     ),
  #     commod_codes = c
  #   ) %>% select(
  #     year,
  #     HS_level = aggregate_level,
  #     trade_flow,
  #     reporter,
  #     partner,
  #     commodity_code,
  #     commodity,
  #     qty_unit,
  #     qty,
  #     trade_value_usd 
  #   )
  #   
  #   mydata <- mydata %>% rbind.data.frame(xx)
  # }
# }

# mydata_while <- data.frame()
# i <- 1
# while (i < 47) {
#   for (c in unlist(commodities$id)[c(1, 7:100)]) {
#     print(
#       paste0(
#         africa_countries[i:(i+10)],
#         " (",
#         commodities$text[commodities$id==c],
#         ")"
#       )
#     )
#     
#     if(ct_get_remaining_hourly_queries()==0){
#       wait_time=as.numeric((ct_get_reset_time()-Sys.time()))*60+10
#       pause(wait_time)
#     }
#     
#     xx <- ct_search(
#       start_date = 2022,
#       end_date = 2022,
#       reporters = "Rwanda",
#       partners = africa_countries[i:(i+4)],
#       trade_direction = c(
#         "imports", 
#         "exports"
#       ),
#       commod_codes = unlist(commodities$id)[-c(2:6)]
#     ) %>% select(
#       year,
#       HS_level = aggregate_level,
#       trade_flow,
#       reporter,
#       partner,
#       commodity_code,
#       commodity,
#       qty_unit,
#       qty,
#       trade_value_usd 
#     )
#     
#     mydata_while <- mydata_while %>% rbind.data.frame(xx)
#   }
#   i = i+5
# }

### all commodities at the same time

mydata_while_allcommodities <- data.frame()
i <- 1
while (i < 51) {
    print(
      paste0(
        africa_countries[i:(i+4)]
      )
    )
    
    if(ct_get_remaining_hourly_queries()==0){
      wait_time=as.numeric((ct_get_reset_time()-Sys.time()))*60+10
      pause(wait_time)
    }
    
    xx <- ct_search(
      start_date = 2022,
      end_date = 2022,
      reporters = "Rwanda",
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
    
    mydata_while_allcommodities <- mydata_while_allcommodities %>% rbind.data.frame(xx)
  i = i+5
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
