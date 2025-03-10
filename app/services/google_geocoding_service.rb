require 'net/http'
require 'json'

module GoogleGeocodingService
  API_KEY = ENV["GOOGLE_MAPS_API_KEY"]

  def self.reverse_geocode(latitude, longitude)
    Rails.logger.debug "DEBUG: Google API に送信する緯度: #{latitude}, 経度: #{longitude}"

    uri = URI("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{latitude},#{longitude}&key=#{API_KEY}&language=ja")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    if result["status"] == "OK"
      address = result["results"][0]["formatted_address"]
      cleaned_address = address.sub(/^日本,?\s*/, '')
      cleaned_address = cleaned_address.sub(/〒\d{3}-\d{4}\s*/, '')
      cleaned_address = cleaned_address.gsub('、', '')
      return cleaned_address if cleaned_address.present?
    end
    "住所が取得できませんでした"
  rescue => e
    "エラー: #{e.message}"
  end
end
