class HomesController < ApplicationController
  require 'openai'

  def index
  end

  def ask
  end

  def answer
    client = OpenAI::Client.new(
      access_token: ENV["OPENAI_API_KEY"],
      request_timeout: 20
      )

    prompt = params[:question]

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "あなたは休日の予定を提案する優秀なアシスタントです。ユーザーの質問に対して、日本語で休日の予定を3つ提供してください。1500字以内で書いてください。" },
          { role: "user", content: prompt }
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
