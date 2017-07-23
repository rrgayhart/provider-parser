require './lib/provider_parser'

describe ProviderParser do
  describe '.initialize' do
    subject { ProviderParser.new('spec/data/short_source_data.json') }
    it 'initializes with a populated source list' do
      expect(subject.source_data.length).to eq(4)
    end
  end

  describe '.match_csv_data' do
    subject { ProviderParser.new('spec/data/medium_source_data.json') }

    before do
      subject.match_csv_data('spec/data/short_match_data.csv')
    end

    context 'with a match on NPI' do
      it 'finds a match on NPI' do
        expect(subject.matched.length).to eq(1)
      end

      it 'stores source and match for matched records' do
        first_match = subject.matched.first
        source_first_name = first_match['source']['doctor']['first_name']
        match_first_name = first_match['match']['first_name']
        expect(source_first_name).to eq(match_first_name)
      end

      xit 'does not search a record against other fields' do
        # Record exists with matching last name
        # Check that no possible match was made with this record
        # When last name check is implemented
      end
    end
  end
end