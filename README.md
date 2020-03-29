
# COVID 19 Project

Personal project to get some insight in reported COVID-19 data.

Two datasets are availabe, ECDC and RIVM.
These are analysed in two static reports tailored to the Dutch situation.

A shiny app is also in (slow) development and available at https://jjongbloets.shinyapps.io/covid19/.

## Tools

### Reproduction number (R)

I use the package "EpiEstim" to estimate the instantaneous reproduction number `R`.
The reproduction number is the average number of people infected by each infected person and indicates the growth rate of the number of infected people at that timepoint.
This number is estimated on sliding (overlapping) windows of 7 days and can be interpreted as the average daily change in cases over the previous 7 days.

As a reference most figures on `R` will have a red line indicating when `R = 1`. Above this line the number of cases grows exponentially, while under this line the number of cases decays exponentially.
