require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #forecast" do
    let(:valid_address) { "New York" }
    let(:lat) { 40.7128 }
    let(:lon) { -74.0060 }
    let(:weather_data) do
      {
        temperature: 25,
        high: 30,
        low: 20,
        description: "clear sky"
      }
    end

    before do
      # Stub GeocodeService call
      allow_any_instance_of(GeocodeService).to receive(:call).and_return([lat, lon])
      # Stub WeatherService call
      allow_any_instance_of(WeatherService).to receive(:call).and_return([weather_data, false])
    end

    context "when address param is blank" do
      it "redirects to root with alert" do
        post :forecast, params: { address: "" }
        expect(flash[:alert]).to eq("Invalid address")
        expect(response).to redirect_to(root_path)
      end
    end

    context "when address cannot be geocoded" do
      before do
        allow_any_instance_of(GeocodeService).to receive(:call).and_return([nil, nil])
      end

      it "redirects to root with alert" do
        post :forecast, params: { address: "Invalid Address" }
        expect(flash[:alert]).to eq("Address not found")
        expect(response).to redirect_to(root_path)
      end
    end

    context "when weather data cannot be fetched" do
      before do
        allow_any_instance_of(WeatherService).to receive(:call).and_return([nil, nil])
      end

      it "redirects to root with alert" do
        post :forecast, params: { address: valid_address }
        expect(flash[:alert]).to eq("Could not fetch weather data.")
        expect(response).to redirect_to(root_path)
      end
    end

    context "when valid address and weather data present" do
      it "renders the forecast template" do
        post :forecast, params: { address: valid_address }, format: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to start_with("text/vnd.turbo-stream.html")
      end
    end
  end
end
