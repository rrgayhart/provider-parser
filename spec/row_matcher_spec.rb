require './lib/row_matcher'


describe 'calculate_likely_match' do
  include RowMatcher
  let(:headers){ ["first_name",
                "last_name",
                "npi",
                "street",
                "street_2",
                "city",
                "state",
                "zip"] }

let(:fields){ ["Ruthe",
               "Laverne",
               "44843147983186317848",
               "569 glenda islands",
               "suite 163",
               "willport",
               "nj",
               "23453"] }

let(:source_record){ { "doctor"=>
                          { "first_name"=>"Quinton",
                            "last_name"=>"Mollie",
                            "npi"=>"36233383542350521233" },
                        "practices"=>
                          [ { "street"=>"8496 Kennedi Inlet",
                              "street_2"=>"Suite 815",
                              "zip"=>"52665-6811",
                              "city"=>"Nealville",
                              "state"=>"OR",
                              "lat"=>"81.37417480720865",
                              "lon"=>"-95.33450729432164" },
                            { "street"=>"29483 Nader Wall",
                              "street_2"=>"Apt. 748",
                              "zip"=>"46006-3437",
                              "city"=>"Rashadborough",
                              "state"=>"UT",
                              "lat"=>"69.84837521604314",
                              "lon"=>"87.36942972635728" },
                            { "street"=>"2122 Wintheiser Valleys",
                              "street_2"=>"Suite 855",
                              "zip"=>"99372",
                              "city"=>"South Daronland",
                              "state"=>"AK",
                              "lat"=>"84.90377842497296",
                              "lon"=>"177.28706015725533" }
                            ]
                      } }

  let(:row){ CSV::Row.new(headers, fields) }
  let(:action){ calculate_likely_match(row, source_record) }

  context 'with no NPI match' do
    context 'with first and last name match' do
      before(:each) do
        fields[0] = source_record['doctor']['first_name']
        fields[1] = source_record['doctor']['last_name'].upcase
      end

      it 'returns correctly formatted data registering as a likely match' do
        expect(action['fields']).to eq(['first_name', 'last_name'])
        expect(action['source']).to eq(source_record)
      end

      context 'with other matching fields' do
        before(:each) do
          fields[3] = source_record['practices'].first['street']
        end

        it 'returns all matching fields and source' do
          expect(action['fields']).to eq(['first_name', 'last_name', 'street'])
          expect(action['source']).to eq(source_record)
        end
      end
    end

    context 'with first or last match' do
      before(:each) do
        fields[0] = source_record['doctor']['first_name']
      end

      context 'with first and any street match' do          
        before(:each) do
          fields[3] = source_record['practices'].first['street']
        end

        it 'returns data indicating a likely match' do
          expect(action['fields']).to eq(['first_name', 'street'])
          expect(action['source']).to eq(source_record)
        end
      end

      context 'with first and three matching address fields' do
        before(:each) do
          fields[5] = source_record['practices'].first['city']
          fields[6] = source_record['practices'].first['state']
          fields[7] = source_record['practices'].first['zip']
        end
        
        it 'returns likely match data' do
          expect(action['fields']).to eq(['first_name', 'city', 'state', 'zip'])
        end
      end

      context 'with 2 matching address fields' do
        before(:each) do
          fields[5] = source_record['practices'].first['city']
          fields[6] = source_record['practices'].first['state']
        end

        it 'returns false' do
          expect(action).to eq(false)
        end
      end

      context 'with no matching address fields' do
        it 'returns false' do
          expect(action).to eq(false)
        end
      end
    end

    context 'with no name matches' do
      context 'with other fields matching' do
        before(:each) do
          fields[3] = source_record['practices'].first['street']
        end

        it 'does not indicate a likely match' do   
          expect(action).to eq(false)
        end
      end

      context 'with no other fields matching' do
        it 'returns false' do
          expect(action).to eq(false)
        end
      end
    end
  end
end