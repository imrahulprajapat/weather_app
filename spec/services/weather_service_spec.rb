require 'rails_helper'

RSpec.describe WeatherService do
  let(:lat)        { 40.7128 }
  let(:lon)        { -74.0060 }
  let(:cache_key)  { 'new-york' }
  let(:api_key)    { 'dummy_api_key' }

  subject { described_class.new(lat, lon, cache_key) }

  before do
    allow(ENV).to receive(:[]).with('OPENWEATHERMAP_API_KEY').and_return(api_key)
  end

  describe '#call' do
    context 'when data is present in the cache' do
      let(:cached_data) do
        {
          temperature: 25.0,
          high: 28.0,
          low: 20.0,
          description: 'clear sky',
          name: 'New York'
        }
      end

      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(cached_data)
      end

      it 'returns the cached data and true' do
        result, from_cache = subject.call
        expect(result).to eq(cached_data)
        expect(from_cache).to be true
      end
    end

    context 'when data is not in the cache' do
      let(:api_response_data) do
        {
          'main' => { 'temp' => 22.0, 'temp_max' => 24.0, 'temp_min' => 20.0 },
          'weather' => [ { 'description' => 'scattered clouds' } ],
          'name' => 'New York'
        }
      end

      let(:api_response) { double('HTTParty::Response', success?: true) }

      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(nil)
        allow(WeatherService).to receive(:get).and_return(api_response)
        allow(api_response).to receive(:[]).with('main').and_return(api_response_data['main'])
        allow(api_response).to receive(:[]).with('weather').and_return(api_response_data['weather'])
        allow(api_response).to receive(:[]).with('name').and_return(api_response_data['name'])
        allow(Rails.cache).to receive(:write)
      end

      it 'calls the API, parses and caches the result' do
        result, from_cache = subject.call

        expect(result).to eq({
          temperature: 22.0,
          high: 24.0,
          low: 20.0,
          description: 'scattered clouds',
          name: 'New York'
        })

        expect(from_cache).to be false
        expect(Rails.cache).to have_received(:write).with(cache_key, result, expires_in: 30.minutes)
      end
    end

    context 'when API call fails' do
      let(:failed_response) { instance_double(HTTParty::Response, success?: false) }

      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(nil)
        allow(WeatherService).to receive(:get).and_return(failed_response)
      end

      it 'returns [nil, nil]' do
        result, from_cache = subject.call
        expect(result).to be_nil
        expect(from_cache).to be_nil
      end
    end
  end
end
