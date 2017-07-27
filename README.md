# Provider Parser

#### Requirements:

- Process the data in match_file.csv against the data in source_data.json
- Try to match based on the following fields: NPI, Name (Use first and last), Address (using street, street_2, city, state and zip)

![screenshot of running script](https://github.com/rrgayhart/provider-parser/blob/master/docs/demo-output.png)

#### Assumptions Made: 

- Source data is always a json file, and match data is always a csv file

- Data structure of source and csv files does not change

- NPI is unique in the source data, therefor an NPI level match ends the searching process for that record.

#### Next Steps

- Allowing the user to go through and validate possible matches
  - Data on possible matches is stored within the record's match data

## Running the Script

Install dependencies: 

```bash
  bundle install
```

Run program:

```bash
  ruby index.rb
```

Run tests:

```bash
  rspec
```
