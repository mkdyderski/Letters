## script for producing 
# devtools::install_github("jennybc/googlesheets")
library('googlesheets')
library('knitr')
library('dplyr')
library('stringi')
library('lubridate')

# read data ---------------------------------------------------------------

dir.create('template/mails') ## invisible at github
setwd('template/mails')

my_sheets <- gs_ls() 
erum <- gs_title('eRum form (Responses)')
GAP_KEY <- gs_gap_key()
erum <- erum %>% gs_gs()

# paper confirmation -------------------------------------------------

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

register_presentation <- register %>%
  filter(!grepl('without', how)) %>% 
  mutate(how = ifelse(grepl('can be',how),'lightning talk',how),
         how = stri_replace_all_regex(str = how,
                                      pattern  = ' \\[(5|15) min\\]',
                                      replacement = ''))
data_input <- register_presentation
fnames_list <- list()

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
  
  fname <- paste0(gsub('\\s+','_',surname),'_',
                  gsub('\\s+','_',name),'_erum_conference_confirmation.tex')
  fname <- stri_trans_general(fname, "latin-ascii")
  fnames_list[[i]] <- fname
  knit2pdf(input = '../erum_conference_confirmation.rnw',
           output = fname)
  junk <- dir(path=getwd(), pattern="*.(aux|log|out|tex)") 
  file.remove(junk)
}

data.frame(fnames = gsub('\\.tex','\\.pdf',unlist(fnames_list)),
           mails = data_input$email) %>%
  write.table(file = 'mails_conf.csv',
            quote=F,
            row.names = F,
            col.names=FALSE, sep=",")

# workshop confirmation ---------------------------------------------------


workshp <- erum %>% 
  gs_read(ws = 'Workshops_conf', col_names = TRUE) %>%
  mutate(status = ifelse(lp >= 26,
                         paste0('a reserve list (place ',lp,'/25)'),
                         'a regular list'),
         workshp = stri_trim_both(workshp)) %>%
  filter(!grepl('sponsor',name,ignore.case=T)) %>%
  group_by(name,surname,mail) %>%
  do(df = data.frame(.))


data_input <- workshp
fnames_list <- list()

for (i in 1:nrow(data_input)) {
  
  
  name <- stri_trans_totitle(data_input$name[i])
  name <- gsub('[[:punct:]]','',name)
  surname <- stri_trans_totitle(data_input$surname[i])
  inst <- stri_trans_totitle(data_input$df[[i]]$institute)
  #city <- stri_trans_totitle(data_input$df[[i]]$)
  #city <- ifelse(city == 'Poznań','Poznan',city)
  #country <- stri_trans_totitle(data_input$country[i])
  mail <- data_input$mail[i]
  
  w <- nrow(data_input$df[[i]]) 
  work_fee <- ifelse(w == 1,'200 PLN / 50 EUR', '400 PLN / 100 EUR')
  work_names <- gsub('\t','',stri_trans_totitle(data_input$df[[i]]$workshp))
  work_time <- stri_trans_totitle(data_input$df[[i]]$when)
  work_status <- stri_trans_tolower(data_input$df[[i]]$status)
  
  fname <- paste0(gsub('\\s+','_',surname),'_',
                  gsub('\\s+','_',name),'_erum_workshop_confirmation.tex')
  fname <- stri_trans_general(fname, "latin-ascii")
  fnames_list[[i]] <- fname
  knit2pdf(input = '../erum_workshop_confirmation.rnw',
           output = fname)
  
  junk <- dir(path=getwd(), pattern="*.(aux|log|out|tex)") 
  file.remove(junk)
}

data.frame(fnames = gsub('\\.tex','\\.pdf',unlist(fnames_list)),
           mails = data_input$mail) %>%
  write.table(file = 'mails_work.csv',
              quote=F,
              row.names = F,
              col.names=FALSE, sep=",")

# conference conf without presentation  -----------------------------------


register_participation <- register %>%
  filter(grepl('without', how),
         when != 'Participation only in workshop/s (not the conference)')

data_input <- register_participation
fnames_list <- list()

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
  
  fname <- paste0(gsub('\\s+','_',surname),'_',
                  gsub('\\s+','_',name),'_erum_participation_confirmation.tex')
  fname <- stri_trans_general(fname, "latin-ascii")
  fnames_list[[i]] <- fname
  knit2pdf(input = '../erum_participation_confirmation.Rnw',
           output = fname)
  junk <- dir(path=getwd(), pattern="*.(aux|log|out|tex)") 
  file.remove(junk)
}

data.frame(fnames = gsub('\\.tex','\\.pdf',unlist(fnames_list)),
           mails = data_input$email) %>%
  write.table(file = 'mails_part.csv',
              quote=F,
              row.names = F,
              col.names=FALSE, sep=",")

### files with emails and files

#files <- list.files(pattern='*.pdf')
# file.remove(files)
