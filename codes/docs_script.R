## script for producing 
# devtools::install_github("jennybc/googlesheets")
library(googlesheets)
#library(readxl)
library(knitr)
library(dplyr)
library(stringi)
library(lubridate)

# read data ---------------------------------------------------------------

my_sheets <- gs_ls() 
erum <- gs_title('eRum form (Responses)')
GAP_KEY <- gs_gap_key()
erum <- erum %>% gs_gs()

register <- erum %>% gs_read(ws = 1, col_names = FALSE) %>%
  select(X1:X7,X11,X13,X16) %>%
  rename( how = X11,
         title = X13,
        timestamp = X1 ,
        name = X2 ,
        surname = X3 ,
        email = X4 ,
        institute = X5 ,
        city = X6 ,
        country = X7,
        when = X16) %>%
  filter(timestamp != 'Timestamp') %>%
  mutate(timestamp = dmy_hms(timestamp))
  

## pass arguments to knitr document while compilation

dir.create('template/mails')
setwd('template/mails')


# paper confirmation -------------------------------------------------

register_presentation <- register %>%
  filter(!grepl('without', how)) %>% 
  mutate(how = ifelse(grepl('can be',how),'lightning talk',how),
         how = stri_replace_all_regex(str = how,
                                      pattern  = ' \\[(5|15) min\\]',
                                      replacement = ''))
data_input <- register_presentation

for (i in 1:nrow(register_presentation)) {
  
  name <- stri_trans_totitle(data_input$name[i])
  name <- gsub('[[:punct:]]','',name)
  surname <- stri_trans_totitle(data_input$surname[i])
  inst <- stri_trans_totitle(data_input$institute[i])
  city <- stri_trans_totitle(data_input$city[i])
  city <- ifelse(city == 'Poznań','Poznan',city)
  country <- stri_trans_totitle(data_input$country[i])
  mail <- data_input$email[i]
  pres_title <- stri_trans_toupper(data_input$title[i])
  type <- stri_trans_toupper(data_input$how[i])
  
  
  knit2pdf(input = '../erum_conference_confirmation.rnw',
           output = paste0(gsub('\\s+','_',surname),'_',
                           gsub('\\s+','_',name),'_erum_conference_confirmation.tex'))
}


# workshop confirmation ---------------------------------------------------


knit2pdf(input = '../erum_workshop_confirmation.rnw',
         output = paste0(surname,'_workshop_confirmation.tex'))


# conference conf without presentation  -----------------------------------


register_participation <- register %>%
  filter(grepl('without', how),
         when != 'Participation only in workshop/s (not the conference)')

data_input <- register_participation

for (i in 1:nrow(data_input)) {
  
  name <- stri_trans_totitle(data_input$name[i])
  name <- gsub('[[:punct:]]','',name)
  surname <- stri_trans_totitle(data_input$surname[i])
  inst <- stri_trans_totitle(data_input$institute[i])
  city <- stri_trans_totitle(data_input$city[i])
  city <- ifelse(city == 'Poznań','Poznan',city)
  country <- stri_trans_totitle(data_input$country[i])
  mail <- data_input$email[i]
  pres_title <- stri_trans_toupper(data_input$title[i])
  type <- stri_trans_toupper(data_input$how[i])
  
  knit2pdf(input = '../erum_participation_confirmation.Rnw',
           output = paste0(gsub('\\s+','_',surname),'_',
                           gsub('\\s+','_',name),'_erum_participation_confirmation.tex'))
}

junk <- dir(path=getwd(), pattern="*.(aux|log|out|tex)") 
file.remove(junk)


