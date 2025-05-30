class GeocodeService
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def call
    results = Geocoder.search(address)
    return [] if results.empty?
    # return [nil, nil] if results.empty? ## for more clarity

    [ results.first.latitude, results.first.longitude ]
  end
end
