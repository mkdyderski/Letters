## script for producing 
library(readxl)
library(knitr)
library(dplyr)
library(stringi)

## pass arguments to knitr document while compilation

dir.create('template/mails')
setwd('template/mails')


# paper confirmation -------------------------------------------------

name <- stri_trans_totitle('name')
surname <- stri_trans_totitle('surname')
inst <- stri_trans_totitle('inst')
city <- stri_trans_totitle('city')
mail <- 'mail@mail.com'
pres_title <- stri_trans_toupper('pres title pres title ')
type <- stri_trans_toupper('type')


knit2pdf(input = '../erum_conference_confirmation.rnw',
         output = paste0(surname,'_',name,'_erum_conference_confirmation.tex'))



# workshop confirmation ---------------------------------------------------

knit2pdf(input = '../erum_workshop_confirmation.rnw',
         output = paste0(surname,'_workshop_confirmation.tex'))


# conference conf without presentation  -----------------------------------


knit2pdf(input = '../erum_workshop_confirmation.rnw',
         output = paste0(surname,'_workshop_confirmation.tex'))
