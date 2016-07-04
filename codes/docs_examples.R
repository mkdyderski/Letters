### examples

name <- 'Adam'
surname <- 'Student'
inst <- 'Poznan University of Economics and Business'
city <- 'Poznan'
country <- 'Poland'
mail <- 'some-mail@domain.com'
pres_title <- 'The title of the presentation'
type <- 'presentation'

w <- 2
work_fee <- ifelse(w == 1,'200 PLN / 50 EUR', '400 PLN / 100 EUR')
work_names <- c('workshop 1', 'workshop 2')
work_time <- c('morning', 'afternoon')
work_status <- c('a reserve list (30/25)', 'a regular list')

# paper confirmation -------------------------------------------------

knit2pdf(input = 'erum_conference_confirmation.rnw',
         output = 'erum_conference_confirmation.tex')

# workshop confirmation ---------------------------------------------------

knit2pdf(input = 'erum_workshop_confirmation.rnw',
         output = 'erum_workshop_confirmation.tex')

# conference conf without presentation  -----------------------------------

knit2pdf(input = 'erum_participation_confirmation.Rnw',
         output = 'erum_participation_confirmation.tex')

junk <- dir(path=getwd(), pattern="*.(aux|log|out|tex)") 
file.remove(junk)
