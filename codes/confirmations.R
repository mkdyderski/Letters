### platnosci and other things
library(dplyr)
library(tidyr)

platnosci <- readxl::read_excel(path = '../Opłaty/erum_platnosci.xlsx',
                                sheet = 1) %>% 
        .[,c(1:5,9,11,16,18,22,24)] 
        

names(platnosci) <- 
        c('timestamp','first_name','last_name','email','institution',
          'workshop_morning','part_in','part_with',
          'social_events','workshop_afternoon','social_events2')

platnosci_doc <- platnosci %>%
        filter(!is.na(timestamp)) %>%
        mutate(
                workshop_morning = 
                        gsub('\\(13:30 - 17:00\\)|\\(9:00 - 12:30\\)| - Matthias Templ|none| - Artur Suchwałko| - Paweł Łabaj| - Adam Zagdański| - Adam Dąbrowski',
                             '',workshop_morning) ,
                workshop_morning = stringi::stri_trim_both(workshop_morning),
                workshop_morning = ifelse(workshop_morning=='',NA,workshop_morning),
                workshop_morning = gsub('Afternoon workshop|Morning workshop|Morning workshop , Afternoon workshop','not_specified',workshop_morning),
                workshop_afternoon = 
                        gsub(' - Rebecca Killick| - Rasmus Bååth| - Emilio L.|- Virgilio Gómez-Rubio|  - Robin Lovelace|none',
                             '',workshop_afternoon),
                workshop_afternoon = stringi::stri_trim_both(workshop_afternoon),
                workshop_afternoon = ifelse(workshop_afternoon=='',
                                            NA,workshop_afternoon),
                workshop_only = grepl(pattern = 'only in',
                                      x = part_with),
                conference = grepl('First|Second',part_with),
                workshop_only = ifelse(conference & workshop_only,
                                       TRUE,workshop_only)
        ) %>%
        arrange(workshop_morning,timestamp) %>%
        group_by(workshop_morning) %>%
        mutate(workshop_morning_pos = row_number()) %>%
        arrange(workshop_afternoon,timestamp) %>%
        group_by(workshop_afternoon) %>%
        mutate(workshop_afternoon_pos = row_number())  %>%
        ungroup() %>% 
        mutate(workshop_morning_pos = 
                            ifelse(is.na(workshop_morning),NA,workshop_morning_pos),
                    workshop_afternoon_pos = 
                            ifelse(is.na(workshop_afternoon),NA,workshop_afternoon_pos)) %>%
        mutate(workshop_payment = 
                       ifelse(workshop_morning_pos <= 25,200,0) + 
                       ifelse(workshop_afternoon_pos <= 25,200,0),
               workshop_payment = ifelse(is.na(workshop_payment),0,workshop_payment),
               conference_payment = ifelse(!workshop_only,100,0),
               total_payment = workshop_payment + conference_payment)


platnosci_doc %>%
        select(first_name:institution,total_payment) %>%
        arrange(last_name,first_name)

rio::export(x = platnosci_doc, file = '../Opłaty/platnosci_przetworzone.xlsx')
