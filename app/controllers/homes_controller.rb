require 'openai'
require 'net/http'
require 'json'
require_relative '../services/google_search_service'
require_relative '../services/google_geocoding_service'

class HomesController < ApplicationController
  def update
    latitude = params[:latitude]
    longitude = params[:longitude]

    if latitude.present? && longitude.present?
      address = GoogleGeocodingService.reverse_geocode(latitude, longitude)
      render json: { address: address }
      Rails.logger.debug "DEBUG: 取得した住所: #{address}"
    else
      render json: { error: "緯度・経度が取得できませんでした" }, status: :unprocessable_entity
    end
  end

  def ask
    @user = User.new
    if flash[:errors].present?
      flash[:errors].each { |error| @user.errors.add(:base, error) }
    end
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
              - 必ず実在する行き先を提案してください。
              - 各行き先の名称は正式名称で表記し必ず「」で囲ってください。ただし、行き先が駅の場合は「」で囲わないでください。
                ※その他の箇所で「」を使用しないでください。
              - タイムスケジュールを組んでください。
              - 休日の日数、人数、予算、現在地、気持ち、備考を考慮してください。
              TEXT
            },
            { role: "user", content: <<~TEXT
              休日の開始日: #{start_date}日
              休日の終了日: #{end_date}日
              人数: #{people}人
              一人当たりの予算: #{budget}円
              現在地: #{location}
              気持ち: #{mood}
              備考: #{remarks}
              TEXT
            }
          ],
          max_tokens: 2000,
          temperature: 0.9
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
      render :answer
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to homes_ask_path
    end
  end

  private

  def user_params
    params.permit(:start_date, :end_date, :people, :budget, :location, :mood,:remarks)
  end
end
