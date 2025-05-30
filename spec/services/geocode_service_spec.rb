# spec/services/geocode_service_spec.rb
require 'rails_helper'

RSpec.describe GeocodeService do
  describe '#call' do
    let(:address) { 'New York, NY' }

    context 'when Geocoder returns results' do
      let(:mock_result) do
        double('GeocoderResult', latitude: 40.7128, longitude: -74.0060)
      end

      before do
        allow(Geocoder).to receive(:search).with(address).and_return([ mock_result ])
      end

      it 'returns latitude and longitude' do
        result = described_class.new(address).call
        expect(result).to eq([ 40.7128, -74.0060 ])
      end
    end

    context 'when Geocoder returns no results' do
      before do
        allow(Geocoder).to receive(:search).with(address).and_return([])
      end

      it 'returns blank' do
        result = described_class.new(address).call
        expect(result).to be_blank
      end
    end
  end
end
