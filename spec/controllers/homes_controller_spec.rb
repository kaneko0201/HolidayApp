require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  render_views

  describe "POST #update" do
    context "緯度・経度が渡された場合" do
      let(:latitude) { 35.6895 }
      let(:longitude) { 139.6917 }
      let(:mock_address) { "東京都 千代田区" }

      before do
        allow(GoogleGeocodingService).to receive(:reverse_geocode).with(latitude.to_s, longitude.to_s).and_return(mock_address)
        post :update, params: { latitude: latitude, longitude: longitude }, format: :json
      end

      it "成功レスポンスを返す" do
        expect(response).to have_http_status(:ok)
      end

      it "適切な住所情報を JSON で返す" do
        json_response = JSON.parse(response.body)
        expect(json_response["address"]).to eq(mock_address)
      end
    end

    context "緯度・経度が渡されない場合" do
      before { post :update, params: {}, format: :json }

      it "エラーを返す" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "エラーメッセージを JSON で返す" do
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("緯度・経度が取得できませんでした")
      end
    end
  end

  describe "GET #ask" do
    before { get :ask }

    it "200 OK を返す" do
      expect(response).to have_http_status(:ok)
    end

    it "@user が新規作成される" do
      expect(controller.instance_variable_get(:@user)).to be_a(User)
    end
  end

  describe "POST #answer" do
    let(:valid_params) do
      {
        start_date: "2025-02-25",
        end_date: "2025-02-27",
        people: "2",
        budget: "30000",
        location: "東京都 渋谷区",
        mood: "リラックスしたい",
        remarks: "温泉に入りたい"
      }
    end

    let(:gpt_response) do
      {
        "choices" => [
          { "message" => { "content" => "おすすめのスポットは「箱根温泉」「草津温泉」です。" } }
        ]
      }
    end

    let(:mock_results) do
      [
        instance_double(Google::Apis::CustomsearchV1::Result,
        link: "https://example.com/hakone",
        snippet: "箱根の温泉情報",
        title: "箱根温泉"),
        instance_double(Google::Apis::CustomsearchV1::Result,
        link: "https://example.com/kusatsu",
        snippet: "草津の温泉情報",
        title: "草津温泉")
      ]
    end

    let(:expected_search_results) do
      [
        { name: "箱根温泉", results: mock_results },
        { name: "草津温泉", results: mock_results }
      ]
    end

    before do
      allow(OpenAI::Client).to receive(:new).and_return(double(chat: gpt_response))
      allow(GoogleSearchService).to receive(:search).and_return(mock_results)
    end

    context "入力が適切な場合" do
      before { post :answer, params: valid_params }

      it "200 OK を返す" do
        expect(response).to have_http_status(:ok)
      end

      it "GPT のレスポンスを取得できる" do
        expect(controller.instance_variable_get(:@answer)).to eq("おすすめのスポットは「箱根温泉」「草津温泉」です。")
      end

      it "@places が適切に抽出される" do
        expect(controller.instance_variable_get(:@places)).to eq(["箱根温泉", "草津温泉"])
      end

      it "@search_results に検索結果が格納される" do
        expect(controller.instance_variable_get(:@search_results)).to eq(expected_search_results)
      end
    end

    context "入力が不適切な場合" do
      before do
        post :answer, params: { start_date: "", end_date: "", people: "", budget: "", location: "", mood: "", remarks: "" }
      end
      it "ask テンプレートがレンダリングされる" do
        expect(response.body).to include("現在地を取得")
      end
    end
  end
end
