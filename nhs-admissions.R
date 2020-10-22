# NHS admissions data -----------------------------------------------------
nhs_url <- paste0("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/",
                 lubridate::year(Sys.Date()), "/",
                 ifelse(lubridate::month(Sys.Date())<10,
                         paste0(0,lubridate::month(Sys.Date())),
                         lubridate::month(Sys.Date())),
                 "/COVID-19-daily-admissions-",
                 gsub("-", "", as.character(Sys.Date()-1)),
                 ".xlsx")
                 download.file(nhs_url, destfile = paste0("data/", Sys.Date(), "-nhs-admissions.xlsx"), mode = "wb")

# Lift the below cleaning code for different analyses:

# 1. Total reported admissions to hospital and diagnoses in hospital (includes readmissions)
#   - patients admitted in previous 24 hours where patient known to have COVID-19
#   - patients diagnosed in hospital with COVID-19 in previous 24 hours

# adm_total <- readxl::read_excel(paste0("data/", Sys.Date(), "-nhs-admissions.xlsx"),
#                                    sheet = 1,
#                                    range = readxl::cell_limits(c(13, 2), c(21, NA))) %>%
#   t() %>%
#   tibble::as_tibble() %>%
#   janitor::row_to_names(1) %>%
#   dplyr::mutate(date = seq.Date(from = as.Date("2020-08-01"), by = 1, length.out = nrow(.)))

# 2. Estimated new hospital cases
#   - patients admitted in previous 24 hours for the first time with COVID-19
#   - patients diagnosed in hospital in previous 24 hours

# adm_new <- readxl::read_excel(paste0("data/", Sys.Date(), "-nhs-admissions.xlsx"),
#                                    sheet = 1,
#                                    range = readxl::cell_limits(c(28, 2), c(36, NA))) %>%
#   t() %>%
#   tibble::as_tibble() %>%
#   janitor::row_to_names(1) %>%
#   dplyr::mutate(date = seq.Date(from = as.Date("2020-08-01"), by = 1, length.out = nrow(.)))

# 3. Estimated new admissions to hospital from the community
#   - patients admitted in previous 24 hours for the first time with COVID-19
#   - patients diagnosed in hospital in previous 24 hours where the test was within 7 days of admission

# adm_new_community <- readxl::read_excel(paste0("data/", Sys.Date(), "-nhs-admissions.xlsx"),
#                                    sheet = 1,
#                                    range = readxl::cell_limits(c(43, 2), c(51, NA))) %>%
#   t() %>%
#   tibble::as_tibble() %>%
#   janitor::row_to_names(1) %>%
#   dplyr::mutate(date = seq.Date(from = as.Date("2020-08-01"), by = 1, length.out = nrow(.)))

# 4. Estimated new hospital admissions from the community with 3-7 day lagging
# Shows the number of patients admitted in previous 24 hours for the first time with COVID-19 plus
#   the number of patients diagnosed in hospital in previous 24 hours where the test was within 48 hours of admission plus
#   the number of patients diagnosed in hospital in previous 24 hours where the test was 3-7 days after admission
#   (lagged by 5 days)
# Note that the last 5 days of this time series will always be an underestimate as they do not include diagnosed patients
# where the test was taken within 3-7 days of admission as that data element is not yet available.
# These figures will be revised as the data becomes available.

# adm_new_community_lag <- readxl::read_excel(paste0("data/", Sys.Date(), "-nhs-admissions.xlsx"),
#                                    sheet = 1,
#                                    range = readxl::cell_limits(c(58, 2), c(66, NA))) %>%
#   t() %>%
#   tibble::as_tibble() %>%
#   janitor::row_to_names(1) %>%
#   dplyr::mutate(date = seq.Date(from = as.Date("2020-08-01"), by = 1, length.out = nrow(.)))

# 5. Total reported hospital admissions and diagnoses from a care home
# For NHS acute trusts and independent sector providers.
# This excludes NHS and Independent Sector Mental Health and Learning Disability providers
#   - patients admitted in the previous 24 hours with COVID-19 or
#     diagnosed with COVID-19 in the previous 24 hours where admitted from Care Homes
# adm_carehome <- readxl::read_excel(paste0("data/", Sys.Date(), "-nhs-admissions.xlsx"),
#                                    sheet = 1,
#                                    range = readxl::cell_limits(c(74, 2), c(82, NA))) %>%
#   t() %>%
#   tibble::as_tibble() %>%
#   janitor::row_to_names(1) %>%
#   dplyr::mutate(date = seq.Date(from = as.Date("2020-08-01"), by = 1, length.out = nrow(.))) # Starts 1 Aug
