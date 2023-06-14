# SCITrade & Comtrade data

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
    "Cape Verde",
    "Central African Republic",
    "Chad",
    "Comoros",
    "Republic of the Congo",
    "Cote d'Ivoire",
    "Djibouti",
    "Egypt",
    "Zambia",
    "Equatorial Guinea",
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
    "sao tome & principe",
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
    "Uganda",
    "Democratic Republic of the Congo",
    "South Sudan"
  )
)

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
mydata <- data.frame()
for (i in africa_countries[5:8]) {
  for (c in unlist(commodities$id)[c(1, 7:100)]) {
    print(
      paste0(
        i,
        ": ",
        commodities$text[commodities$id==c] 
      )
    )
    
    xx <- ct_search(
      start_date = 2022,
      end_date = 2022,
      reporters = "Rwanda",
      partners = i,
      trade_direction = c(
        "imports", 
        "exports"
      ),
      commod_codes = c
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
    
    mydata <- mydata %>% rbind.data.frame(xx)
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
