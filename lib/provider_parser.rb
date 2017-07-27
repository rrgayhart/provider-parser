require_relative './parse_json'
require_relative './row_matcher'
require 'pathname'
require 'csv'

class ProviderParser
  include RowMatcher
  attr_reader :source_data
  attr_accessor :total_records_checked, :direct_matches, :possible_matches, :unmatched

  def initialize(source_path='data/source_data.json')
    @source_data = parse_json(source_path)
    @total_records_checked = 0
    @direct_matches = []
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
    match_data = base_match_data(row)
    source_data.each do |record|
      npi_match_data = calculate_direct_match(row, record)
      return store_direct_match(row, npi_match_data) if npi_match_data
      update_likely_matches(match_data, row, record)
    end
    store_row(match_data, row)
  end

  def base_match_data(row)
    {
      'match_row' => row.to_hash,
      'direct_match' => nil,
      'likely_matches' => []
    }
  end

  def store_direct_match(row, data)
    match_record = base_match_data(row)
    match_record['direct_match'] = data
    direct_matches.push(match_record)
  end

  def store_row(match_data, row)
    if match_data['likely_matches'].empty? 
      unmatched.push(row)
    else
      possible_matches.push(match_data)
    end
  end

  def update_likely_matches(match_data, row, record)
    new_data = calculate_likely_match(row, record)
    match_data['likely_matches'].push(new_data) if new_data
  end
end