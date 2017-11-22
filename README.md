[![Build Status](https://travis-ci.org/mmateja/harvest_overtime.svg?branch=master)](https://travis-ci.org/mmateja/harvest_overtime)

# harvest_overtime

Simple command-line tool for tracking overtime in Harvest

## Requirements

* Ruby (version 2.3 or higher)

## Installation

`>> gem install harvest_overtime`

## Configuration

1. Create Personal Access Token for Harvest API on https://id.getharvest.com/developers.
2. Set `HARVEST_ACCOUNT_ID` and `HARVEST_TOKEN` environment variables to values generated in Harvest.

## Usage

`>> overtime [number_of_months]`

Sample output:

```
Month               Business hours      Billed hours        Overtime
2017-09             168                 197.2               29.2
2017-10             176                 167.3               -8.7
2017-11             144                 125.0               -19.0

Total overtime: 1.5 hour(s) -> 0 day(s)
```
