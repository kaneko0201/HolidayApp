require 'rails_helper'

RSpec.describe "Homes API", type: :request do

  describe "POST /homes/update" do
    let(:latitude) { "35.6895" }
    let(:longitude) { "139.6917" }

    context "有効な緯度・経度を送信した場合" do
      before do
        allow(GoogleGeocodingService).to receive(:reverse_geocode).and_return("東京都新宿区")
        post "/homes/update", params: { latitude: latitude, longitude: longitude }
      end

      it "200 OK を返す" do
        expect(response).to have_http_status(:ok)
      end

      it "JSON 形式の住所を返す" do
        json = JSON.parse(response.body)
        expect(json["address"]).to eq("東京都新宿区")
      end
    end

    context "緯度・経度がない場合" do
      before { post "/homes/update", params: {} }

      it "422 Unprocessable Entity を返す" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "エラーメッセージを返す" do
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("緯度・経度が取得できませんでした")
      end
    end
  end

  describe "POST /homes/answer" do
    let(:valid_params) do
      {
        start_date: "2025-04-01",
        end_date: "2025-04-03",
        people: "2",
        budget: "50000",
        location: "東京",
        mood: "リラックス",
        remarks: "温泉に行きたい"
      }
    end

    context "有効なリクエストの場合" do
      before do
        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(
          {
            "choices" => [
              {
                "message" => { "content" => "おすすめの旅行プラン:\n1日目: 「箱根温泉」へ移動\n2日目: 「富士山」観光" }
              }
            ]
          }
        )

        search_results_1 = [
          Struct.new(:title, :link, :snippet).new("箱根温泉 公式サイト", "https://hakoneonsen.com", "箱根温泉の公式情報")
        ]
        search_results_2 = [
          Struct.new(:title, :link, :snippet).new("富士山観光情報", "https://fuji.jp", "富士山の観光情報")
        ]

        allow(GoogleSearchService).to receive(:search).with("箱根温泉 公式サイト").and_return(search_results_1)
        allow(GoogleSearchService).to receive(:search).with("富士山 公式サイト").and_return(search_results_2)

        post "/homes/answer", params: valid_params
      end

      it "200 OK を返す" do
        expect(response).to have_http_status(:ok)
      end

      it "AI の回答が含まれる" do
        expect(response.body).to include("おすすめの旅行プラン")
      end

      it "GoogleSearchService が呼び出される" do
        expect(GoogleSearchService).to have_received(:search).with("箱根温泉 公式サイト")
        expect(GoogleSearchService).to have_received(:search).with("富士山 公式サイト")
      end

      it "検索結果がレスポンスに含まれる" do
        expect(response.body).to include("箱根温泉 公式サイト")
        expect(response.body).to include("富士山観光情報")
      end
    end

    context "パラメータが不足している場合" do
      before { post "/homes/answer", params: { start_date: "", end_date: "", people: "", budget: "", location: "", mood: "", remarks: "" } }

      it "askページにリダイレクトされる" do
        expect(response).to redirect_to(homes_ask_path)
      end
    end
  end
end
