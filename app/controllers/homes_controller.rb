class HomesController < ApplicationController
  require 'openai'

  def index
  end

  def ask
    @user = User.new
  end

  def answer
    @user = User.new(user_params)

    if @user.valid?

      client = OpenAI::Client.new(
        access_token: ENV["OPENAI_API_KEY"],
        )

      start_date = params[:start_date]
      end_date = params[:end_date]
      people = params[:people]
      budget = params[:budget]
      location = params[:location]
      mood = params[:mood]
      remarks = params[:remarks]

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",#本番環境での使用には日付ありの GPT モデルが推奨
          messages: [
            { role: "system", content: <<~TEXT
              あなたは休日の予定を提案する優秀なアシスタントです。
              ユーザーの質問に対して、日本語で休日の予定の提案書を作成してください。
              具体的な行き先を提案してください。
              タイムスケジュールを組んでください。
              休日の日数、人数、予算、現在地、気持ち、備考を考慮してください。
              TEXT
            },
            { role: "system", content: <<~TEXT
              **以下の信頼できる情報源から各行き先に関連するURLを取得してください。**
              - 公式サイト（例: .go.jp, .lg.jp, .or.jp,.gr.jp, .co.jp など）
              - 大手旅行サイト（例: jalan.net, rakuten.co.jp, knt.co.jpなど）

              **出力フォーマット**
              - 取得したURLの前にリンク先の公式名称を記載してください。
              - 取得したURLを、以下の HTML の形式で出力してください。

              <a href="取得したURLを入力" target="_blank" rel="noopener noreferrer">リンク名</a>

              **注意**
              1. **アクセスできないURLを含めないでください。**
              2. **HTTP ステータスコードが `200 OK` のページのみ使用してください。**
              3. **`404 Not Found`, `403 Forbidden`, `NXDOMAIN`, `500 Internal Server Error` などのページは絶対に含めないでください。**
              4. **URL を生成するのではなく、正確なURLを参照してください。**

              TEXT
            },
            { role: "user", content: <<~PROMPT
              休日の開始日: #{start_date}日
              休日の終了日: #{end_date}日
              人数: #{people}人
              一人当たりの予算: #{budget}円
              現在地: #{location}
              気持ち: #{mood}
              備考: #{remarks}
              PROMPT
            }
          ],
          max_tokens: 2000,
          temperature: 0.7
        }
      )

      if response["choices"] && response["choices"][0] && response["choices"][0]["message"]
        @answer = response["choices"][0]["message"]["content"]
        puts @answer

      else
        @answer = "回答が見つかりませんでした"
      end

    else
      render :ask
    end
  end

  private

  def user_params
    params.permit(:start_date, :end_date, :people, :budget, :location, :mood,:remarks)
  end
end
