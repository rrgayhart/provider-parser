require_relative "./lib/provider_parser"

puts "Initializing the source provider data..."
provider_parser = ProviderParser.new()

puts "Reading match data and compiling possible matches..."
provider_parser.match_csv_data()

puts "Your CSV file containted #{provider_parser.total_records_checked} records to try and match"

puts "You have #{provider_parser.matched.length} records that matched on NPI number\n"

puts "You have #{provider_parser.possible_matches.length} records not matching by NPI that may be possible matches"

puts "You have #{provider_parser.unmatched.length} records that do not match."