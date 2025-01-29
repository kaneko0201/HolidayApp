class HomesController < ApplicationController
  require 'openai'

  def index
  end

  def ask
  end

  def answer
    client = OpenAI::Client.new(
      access_token: ENV["OPENAI_API_KEY"],
      )

    prompt = params[:question]
    days = params[:days]
    people = params[:people]
    budget = params[:budget]
    location = params[:location]
    mood = params[:mood]
    remarks = params[:remarks]

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",#本番環境での使用には日付ありの GPT モデルが推奨
        messages: [
          { role: "system", content: "あなたは休日の予定を提案する優秀なアシスタントです。ユーザーの質問に対して、日本語で休日の予定の提案書を作成してください。タイムスケジュールを組んでください。休日の日数、人数、予算、現在地、気持ち、備考を考慮してください。" },
          {
            role: "user",
            content: <<~PROMPT
            休日の日数: #{days}日
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
    else
      @answer = "回答が見つかりませんでした"
    end
  end
end
