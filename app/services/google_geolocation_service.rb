require 'net/http'
require 'json'

module GoogleGeolocationService
  API_KEY = ENV["GOOGLE_MAP_KEY"]

  def self.get_location
    uri = URI("https://www.googleapis.com/geolocation/v1/geolocate?key=#{API_KEY}")

    body = {
      considerIp: true,
      wifiAccessPoints: []
    }.to_json

    response = Net::HTTP.post(uri, body, { "Content-Type" => "application/json" })
    result = JSON.parse(response.body)

    if result["location"]
      latitude = result["location"]["lat"]
      longitude = result["location"]["lng"]
      address = GoogleGeocodingService.reverse_geocode(latitude, longitude)
      { latitude: latitude, longitude: longitude, address: address }
    else
      { error: "位置情報の取得に失敗しました" }
    end
  rescue => e
    { error: "エラー: #{e.message}" }
  end
end
