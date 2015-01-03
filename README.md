---
title: "Crimes per Zip Code in Dallas 2014"
author: "Justin Nafe"
date: "Saturday, January 03, 2015"
output: html_document
---

Introduction
------------

This analysis shows the number of crimes per zip code for 2014 in Dallas County. 

This analysis uses Dallas Open Data (<a href="https://www.dallasopendata.com/" target="_blank">https://www.dallasopendata.com/</a>) to calculate the number of crimes per zip code in Dallas County. As pointed out on Dallas Police Public Data website (<a href="http://www.dallaspolice.net/publicdata/" target="_blank">http://www.dallaspolice.net/publicdata/</a>), the data that the police supply to the public is sample data, so the data cannot be used to supply official statistics.

To get a list of Dallas County zip codes, I used <a href="http://www.unitedstateszipcodes.org/" target="_blank">http://www.unitedstateszipcodes.org/</a> and used just the zip codes needed for this example analysis.

Analysis
--------

###Requirements
Required packages:
```
library(lubridate)
library(dplyr)
```
###Disclaimer

The data supplied by Dallas Police Department is sampled and should not be used for statistical purposes, but we should be able to extract enough informaation to get a general idea of where crime is concentrated.

The Dallas Police Department implemented a new Records Management System (RMS) on June 1, 2014. To get crime data for 2014, two datasets are needed.


