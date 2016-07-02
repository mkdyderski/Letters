# Letters

Confirmation letters. Repository contains three letters based on `Professional Formal Letter` (source: http://www.LaTeXTemplates.com).

Letters are in folder template

* erum_conference_confirmation.Rnw
* erum_workshop_confirmation.Rnw
* erum_participation_confirmation.Rnw

To compile documents run `codes/docs_examples.R`. Generation of original documents are based on Google Sheet (Google Form) and require the following packages

```
library(googlesheets)
library(knitr)
library(dplyr)
library(stringi)
library(lubridate)
```

