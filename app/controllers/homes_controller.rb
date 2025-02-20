class HomesController < ApplicationController
  require 'openai'
  require_relative '../services/google_search_service'
  require_relative '../services/google_geolocation_service.rb'
  require_relative '../services/google_geocoding_service'

  def index
  end

  def get_location
    @location = get_current_location
    redirect_to homes_ask_path(location: @location)
  end

  def ask
    @user = User.new
    @location = params[:location] 
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
              - あなたは休日の予定を提案する優秀なアシスタントです。
              - ユーザーの質問に対して、日本語で休日の予定の提案書を作成してください。
              - 具体的な行き先を提案してください。
              - 各行き先の名称は「」で囲ってください。
                ※その他の箇所で「」を使用しないでください。
              - タイムスケジュールを組んでください。
              - 休日の日数、人数、予算、現在地、気持ち、備考を考慮してください。
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

        @places = @answer.scan(/「(.+?)」/).flatten.uniq

        @search_results = @places.map do |place|
          { name: place, results: GoogleSearchService.search("#{place} 公式サイト") }
        end
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

  def get_current_location
    result = GoogleGeolocationService.get_location

    if result[:latitude] && result[:longitude]
      GoogleGeocodingService.reverse_geocode(result[:latitude], result[:longitude])
    else
      "位置情報を取得できませんでした"
    end
  end
end
