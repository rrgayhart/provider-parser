require './lib/parse_json'

describe 'parse_json' do
  it 'returns an array of doctor data' do
    records = parse_json('spec/data/long_source_data.json')
    expect(records.length).to eq(11231)
    all_valid_hash_data = records.all?{ |r| r.class == Hash }
    all_valid_top_level_keys = records.all?{ |r| r.keys.sort == ['doctor', 'practices'] }
    expect(all_valid_top_level_keys).to be(true)
    expect(all_valid_hash_data).to be(true)
  end
end