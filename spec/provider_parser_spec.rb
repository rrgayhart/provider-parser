require './lib/provider_parser'
require 'pry'

describe ProviderParser do
  describe '.initialize' do
    subject { ProviderParser.new('spec/data/short_source_data.json') }
    it 'initializes with a populated source list' do
      expect(subject.source_data.length).to eq(4)
    end
  end

  describe '.match_csv_data' do
    subject { ProviderParser.new('spec/data/medium_source_data.json') }
    let(:action){ subject.match_csv_data('spec/data/short_match_data.csv') }

    it 'documents number of records checked' do
      expect(subject.total_records_checked).to eq(0)
      action
      expect(subject.total_records_checked).to eq(12)
    end

    context 'when record has a match on NPI' do
      before do
        action
      end

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

    context 'when record has a match on secondary data types' do
      before do
        action
      end

      it 'populates all possible matches' do
        expect(subject.possible_matches.length).to eq(1)
      end

      it 'does not populate unmatching records in possible_matches'

      it 'stores source match data'

      it 'stores matching fields'
    end

    context 'when record has no match' do
      before do
        action
      end

      it 'stores the record in the unmatched records' do
      end
    end
  end
end