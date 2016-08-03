### examples
library(knitr)

name <- 'xxx'
surname <- 'xxx'
inst <- 'xxxxxx'
city <- 'xxx'
country <- 'xxx'
mail <- 'xxx@xxx.xxx'
pres_title <- 'xxx'
type <- 'a regular talk'

w <- 2
work_fee <- ifelse(w == 1,'200 PLN / 50 EUR', '400 PLN / 100 EUR')
work_names <- c('workshop 1', 'workshop 2')
work_time <- c('morning', 'afternoon')
work_status <- c('a reserve list (30/25)', 'a regular list')

# paper confirmation -------------------------------------------------

knit2pdf(input = 'template/erum_conference_confirmation.Rnw',
         output = 'template/erum_conference_confirmation.tex')

# workshop confirmation ---------------------------------------------------

knit2pdf(input = 'template/erum_workshop_confirmation.Rnw',
         output = 'template/erum_workshop_confirmation.tex')

# conference conf without presentation  -----------------------------------

knit2pdf(input = 'template/erum_participation_confirmation.Rnw',
         output = 'template/erum_participation_confirmation.tex')

junk <- dir(path="template/", pattern="*.(aux|log|out|tex)", full.names = TRUE) 
file.remove(junk)
