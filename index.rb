require_relative "./lib/provider_parser"

puts "Initializing the source provider data..."
provider_parser = ProviderParser.new()

puts "Reading match data and compiling possible matches..."
provider_parser.match_csv_data()

puts "Your CSV file containted #{provider_parser.total_records_checked} records to try and match\n"

puts "\n"

puts "You have #{provider_parser.direct_matches.length} records that directly matched the source file records on NPI number\n"

puts "\n"

puts "You have #{provider_parser.possible_matches.length} records not matching by NPI that may be possible matches\n"

puts "We define a possible match as having:\n"
puts "- Same first and last name\n"
puts "- Matching first or last name and an address that matches on street\n"
puts "- Matching first or last name and that matches on atleast 3 other address fields\n"
puts "  (street, street_2, city, state and zip) \n"

puts "\n"

puts "You have #{provider_parser.unmatched.length} records that did not have a direct or likely match in the source records."

puts "\n"
puts "\n"
puts "\n"