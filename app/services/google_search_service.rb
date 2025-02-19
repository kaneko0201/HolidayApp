require 'google/apis/customsearch_v1'

module GoogleSearchService
  API_KEY = ENV["GOOGLE_API_KEY"]
  CX = ENV["GOOGLE_CX"]

  def self.search(query)
    service = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
    service.key = API_KEY

    begin
      response = service.list_cses(q: query, cx: CX)

      if response.items
        response.items.each do |item|
          puts "タイトル: #{item.title}"
          puts "URL: #{item.link}"
          puts "概要: #{item.snippet}"
          puts '-' * 50
        end
      else
        puts "検索結果が見つかりませんでした。"
      end
    rescue Google::Apis::AuthorizationError => e
      puts "認証エラー: #{e.message}"
    rescue Google::Apis::ClientError => e
      puts "クライアントエラー: #{e.message}"
    rescue Google::Apis::ServerError => e
      puts "サーバーエラー: #{e.message}"
    rescue StandardError => e
      puts "その他のエラー: #{e.message}"
    end
  end
end
