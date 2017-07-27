module RowMatcher
  def calculate_likely_match(match_row, source)
    name_matches = pull_name_matches(source, match_row)
    return false if name_matches.empty?
    provider_matches = pull_provider_matches(source, match_row)
    return false unless is_likely_match(name_matches, provider_matches)
    format_match_data(name_matches, provider_matches, source)
  end

  def format_match_data(name_matches, provider_matches, source)
    { 'fields' => name_matches + provider_matches,
      'source' => source }
  end

  def is_likely_match(name_matches, provider_matches)
    name_matches.length >= 2 || provider_matches.include?('street') || provider_matches.length >= 3
  end

  def pull_name_matches(source, match_row)
    name_headers = ['first_name', 'last_name']
    name_headers.select do |field|
      loose_match(match_row[field], source['doctor'][field])
    end
  end

  def pull_provider_matches(source, match_row)
    provider_headers = ['street', 'city', 'state', 'zip', 'street_2']
    provider_headers.select do |field|
      source['practices'].any?{ |p| loose_match(match_row[field], p[field]) }
    end
  end

  def loose_match(field1, field2)
    return false if field1 === ''
    field1.downcase === field2.downcase
  end

  private :loose_match, :format_match_data, :is_likely_match, :pull_provider_matches, :pull_name_matches
end