def calculate_likely_match(match_row, source)
  name_fields = ['first_name', 'last_name'].select do |field|
    match_row[field].strip.downcase === source['doctor'][field].strip.downcase
  end

  return false if name_fields.empty?

  provider_fields = ['street', 'city', 'state', 'zip', 'street_2'].select do |field|
    source['practices'].any?{ |p| match_row[field].strip.downcase === p[field].strip.downcase }
  end

  if (name_fields.length >= 2 || provider_fields.include?('street') || provider_fields.length >= 3)
    all_matching_fields = name_fields + provider_fields
    return { 'fields' => all_matching_fields, 'source' => source }
  end

  false
end