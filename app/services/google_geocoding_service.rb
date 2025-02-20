require 'net/http'
require 'json'

module GoogleGeocodingService
  API_KEY = ENV["GOOGLE_MAP_KEY"]

  def self.reverse_geocode(latitude, longitude)
    uri = URI("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{latitude},#{longitude}&key=#{API_KEY}&language=ja")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    if result["status"] == "OK"
      address_components = result["results"][0]["address_components"]
      prefecture = address_components.find { |c| c["types"].include?("administrative_area_level_1") }&.dig("long_name")
      city = address_components.find { |c| c["types"].include?("locality") }&.dig("long_name")

      return "#{prefecture} #{city}" if prefecture && city
      return prefecture if prefecture
    end
    "住所が取得できませんでした"
  rescue => e
    "エラー: #{e.message}"
  end
end
