require 'parse_json'
require 'pathname'
require 'csv'

class ProviderParser
  attr_reader :source_data
  attr_accessor :matched

  def initialize(source_path='data/source_data.json')
    @source_data = parse_json(source_path)
    @matched = []
  end

  def match_csv_data(file_path='data/match_file.csv')
    path = Pathname(__FILE__).dirname.parent + file_path
    CSV.foreach(path, { :headers => true }) do |row|
      populate_match_instances(row)
    end
  end

  private

  def populate_match_instances(row)
    source_data.each do |record|
      return process_npi_match(record, row) if npi_match(record, row)
    end
    # check for last name - first name - street, street_2, city, state and zip
  end

  def process_npi_match(source, match)
    match_data = {
      'source' => source,
      'match' => match.to_hash
    }
    return matched.push(match_data)
  end

  def npi_match(source, match)
    source['doctor']['npi'] == match['npi']
  end
end