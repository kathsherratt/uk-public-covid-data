# Get latest PHE surveillance report data
readurl <- read_html("https://www.gov.uk/government/publications/national-covid-19-surveillance-reports") %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  str_subset(".xlsx") %>%
  str_subset("Weekly_COVID19_report_data_w")

tf <- tempfile(fileext = ".xlsx")
httr::GET(readurl[1], httr::write_disk(tf, overwrite = T))
sheets <- readxl::excel_sheets(tf)

# Test positivity ---------------------------------------------------------

# # Regional pillar 2 test positivity %
raw_pos_region <- readxl::read_excel(path = tf,
                                     sheet = grep("Figure 8. Positivity", sheets),
                                     range = readxl::cell_limits(c(47, 2), c(NA, NA)))
names(raw_pos_region)[names(raw_pos_region)=="...1"] <- "week"
# Read in England positivity %
raw_pos_eng <- readxl::read_excel(path = tf,
                                  sheet = grep("Figure 5", sheets),
                                  range = readxl::cell_limits(c(47, 2), c(NA, NA)))
raw_pos_eng <- raw_pos_eng[,1:2]
names(raw_pos_eng) <- c("week", "England")

# Join
raw_pos_region$week <- as.numeric(raw_pos_region$week)
raw_pos_eng$week <- as.numeric(raw_pos_eng$week)
raw_pos_tests <- cbind(raw_pos_region, raw_pos_eng[,2])

# Clean: set to PHE regions, add dates
pos_tests <- raw_pos_tests %>%
  dplyr::mutate(dplyr::across(.cols = -week, ~ dplyr::na_if(., "-")),
                dplyr::across(.cols = -week, ~ as.numeric(.)),
                Midlands = `East Midlands` + `West Midlands`, # aggregate 9 PHE to 7 NHS regions
                'North East and Yorkshire' = `Yorkshire and Humber` + `North East`) %>%
  week_to_date(.) %>%
  dplyr::rename(date = week_end_date) %>%
  dplyr::select(-week) %>%
  tidyr::pivot_longer(cols = -date, names_to = "region", values_to = "pos_perc")%>%
  dplyr::filter(!is.na(pos_perc) &
                  !region %in% c("West Midlands", "East Midlands",
                                 "Yorkshire and Humber", "North East") &
                  date <= max(summary$date)) # Filter to match Rt time series
