require 'rails_helper'

RSpec.describe "Homes", type: :system do
  before do
    driven_by(:selenium, using: :headless_chrome)
  end

  describe "質問フォームの動作" do
    before { visit homes_ask_path }

    context "正常な入力で質問を送信した場合" do
      before do
        click_button "現在地を取得"
        fill_in "location-input", with: "東京都渋谷区"
        fill_in "mood", with: "リラックス"
        fill_in "start_date", with: Date.today
        fill_in "end_date", with: Date.today + 2
        select "2", from: "people"
        select "50,000", from: "budget"
        fill_in "remarks", with: "温泉に行きたい"

        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(
          {
            "choices" => [
              {
                "message" => { "content" => "おすすめの旅行プラン:\n1日目: 「箱根温泉」へ移動\n2日目: 「富士山」観光" }
              }
            ]
          }
        )

        allow(GoogleSearchService).to receive(:search).with("箱根温泉 公式サイト").and_return([
          Struct.new(:title, :link, :snippet).new("箱根温泉 公式サイト", "https://hakoneonsen.com", "箱根温泉の公式情報")
        ])
        allow(GoogleSearchService).to receive(:search).with("富士山 公式サイト").and_return([
          Struct.new(:title, :link, :snippet).new("富士山観光情報", "https://fuji.jp", "富士山の観光情報")
        ])

        click_button "質問する"
      end

      it "AIの回答が表示される" do
        expect(page).to have_content("おすすめの旅行プラン")
        expect(page).to have_content("箱根温泉")
        expect(page).to have_content("富士山")
      end

      it "関連する公式サイトが表示される" do
        expect(page).to have_link("箱根温泉 公式サイト", href: "https://hakoneonsen.com")
        expect(page).to have_link("富士山観光情報", href: "https://fuji.jp")
      end

      it "質問フォームに戻る", js: true do
        click_link "別の質問をする"
        expect(page).to have_current_path(homes_ask_path, ignore_query: true)
        expect(page).to have_button("質問する")
      end
    end

    context "入力が不足している場合" do
      it "エラーメッセージが表示される", js: true do
        click_button "質問する"
        expect(page).to have_current_path(homes_ask_path, ignore_query: true)
        expect(page).to have_css(":invalid")
      end
    end
  end
end
