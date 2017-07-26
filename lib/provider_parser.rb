require_relative './parse_json'
require 'pathname'
require 'csv'

class ProviderParser
  attr_reader :source_data
  attr_accessor :total_records_checked, :matched, :possible_matches, :unmatched

  def initialize(source_path='data/source_data.json')
    @source_data = parse_json(source_path)
    @total_records_checked = 0
    @matched = []
    @possible_matches = []
    @unmatched = []
  end

  def match_csv_data(file_path='data/match_file.csv')
    path = Pathname(__FILE__).dirname.parent + file_path
    CSV.foreach(path, { :headers => true }) do |row|
      self.total_records_checked += 1
      populate_match_instances(row)
    end
  end

  private

  def populate_match_instances(row)
    match_data = {
      'match' => row.to_hash
    }
    source_data.each do |record|
      return process_npi_match(record, row) if npi_match(record, row)
      fields = collect_matching_fields(record, row)
      if (fields.length > 0)
        process_match_by(fields, match_data, record)
      end
    end
    match_data['sources'] ? possible_matches.push(match_data) : unmatched.push(match_data)
  end

  def collect_matching_fields(source, match)
    fields = []
    fields.push('last_name') if source['doctor']['last_name'] == match['last_name']
    fields.push('first_name') if source['doctor']['first_name'] == match['first_name']
    fields
  end

  def process_match_by(fields, match_data, record)
    source_npi = record['doctor']['npi']
    sources_match_data = match_data['sources'] ||= {}
    source_match_data = match_data['sources'][source_npi] ||= {'matching_fields' => fields}
    source_match_data['original'] ||= record
  end

  def process_npi_match(source, match)
    match_data = {
      'source' => source,
      'match' => match.to_hash
    }
    return matched.push(match_data)
  end

  def npi_match(source, match)
    return false if match['npi'].length < 1
    source['doctor']['npi'] == match['npi']
  end
end