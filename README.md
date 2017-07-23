# Provider Parser

#### Requirements:

- Process the data in match_file.csv against the data in source_data.json
- Try to match based on the following fields: NPI, Name (Use first and last), Address (using street, street_2, city, state and zip)

#### Assumptions Made: 

- Source data is always a json file, and match data is always a csv file

- NPI is unique in the source data, therefor an NPI level match ends the searching process for that record.

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