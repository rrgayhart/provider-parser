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
    let(:match_path){ 'spec/data/medium_match_data.csv' }
    let(:action){ subject.match_csv_data(match_path) }

    before do
      action
    end

    it 'documents number of records checked' do
      expect(subject.total_records_checked).to eq(36)
    end

    context 'when record has a match on NPI' do
      it 'populates direct_matches' do
        expect(subject.direct_matches.length).to eq(3)
      end

      it 'stores source, match and field for the match' do
        first_match = subject.direct_matches.first
        expect(first_match.keys).to eq(["match_row", "direct_match", "likely_matches"])
      end

      it 'sets the direct match per record' do
        all_matching = subject.direct_matches.all? do |m| 
          m['direct_match'].class == Hash
        end
        expect(all_matching).to be(true)
      end

      it 'it disregards any other likely field matches' do
        only_npi_fields = subject.direct_matches.all? do |m| 
          m['likely_matches'].length === 0
        end
        expect(only_npi_fields).to be(true)
      end
    end

    context 'when record has likely matches' do
      it 'populates the possible_matches' do
        expect(subject.possible_matches.length).to eq(3)
      end

      it 'sets the likely matches per record' do
        all_matching = subject.possible_matches.all? do |m| 
          m['likely_matches'].length > 0
        end
        expect(all_matching).to be(true)
      end
    end

    context 'when record has no likely match' do
      it 'populates unmatched' do
        expect(subject.unmatched.length).to eq(30)
      end

      it 'stores only CSV row data per unmatched record' do
        all_csv_data = subject.unmatched.all? do |m|
          m.class == CSV::Row
        end
        expect(all_csv_data).to be(true)
      end
    end
  end
end