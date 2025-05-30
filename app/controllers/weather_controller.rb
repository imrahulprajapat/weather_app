class WeatherController < ApplicationController
  def index;end # for displaying the address input

  def forecast
    search_term = params[:address]
    handle_invalid_address('Invalid address') and return if search_term.blank?

    lat, lon = GeocodeService.new(search_term).call
    handle_invalid_address('Address not found') and return if lat.nil? && lon.nil?

    @weather, @from_cache = WeatherService.new(lat, lon, search_term.parameterize).call
    handle_invalid_address('Could not fetch weather data.') and return if @weather.nil? && @from_cache.nil?

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  private

  def handle_invalid_address(message)
    flash[:alert] = message
    redirect_to root_path
  end
end
