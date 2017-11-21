# harvest-overtime

Script for tracking overtime in Harvest

## Requirements

* Ruby
* Bundler
* Personal Access Token for Harvest API (can be generated on https://id.getharvest.com/developers)

## Configuration

Install dependencies with `bundler install`.

Set `HARVEST_ACCOUNT_ID` and `HARVEST_TOKEN` environment variables to values generated in Harvest.

## Sample usage

```
$ HARVEST_ACCOUNT_ID=xxx HARVEST_TOKEN=zzz bundle exec ruby overtime.rb

Retrieving data ...........

Month	Business hours	Billed hours	Overtime
2017-06	176	172.5	-3.5
2017-07	168	168.5	0.5
2017-08	184	207.4	23.4
2017-09	168	197.2	29.2
2017-10	176	167.3	-8.7
2017-11	120	117.2	-2.8

Total overtime: 38.1 hour(s) -> 4 day(s)
```
