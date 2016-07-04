# Confirmation letters

The repository contains three letters based on `Professional Formal Letter` (source: http://www.LaTeXTemplates.com).

Letters are located in the template folder:

* erum_conference_confirmation.Rnw
* erum_workshop_confirmation.Rnw
* erum_participation_confirmation.Rnw

To compile these documents run `codes/docs_examples.R`. Creation of original documents are based on Google Sheet (Google Form) and require the following packages:

```
library('googlesheets')
library('knitr')
library('dplyr')
library('stringi')
library('lubridate')
```

