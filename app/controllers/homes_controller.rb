class HomesController < ApplicationController
  require 'openai'

  def show
  end

  def index
  end

  def suggest
    client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])

    begin
      response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [
            { role: "system", content: "You are a helpful holiday planning assistant." },
            { role: "user", content: suggestion_prompt(params) }
          ]
        }
      )

      if response["choices"] && response["choices"][0]["message"]["content"]
        render json: { suggestion: response["choices"][0]["message"]["content"] }
      else
        render json: { error: 'Invalid response from the API' }, status: :bad_gateway
      end
    rescue OpenAI::Error => e
      render json: { error: "API error: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def suggestion_prompt(params)
    "Plan a holiday for #{params[:days]} days with #{params[:people]} people. Budget is #{params[:budget]}, location is #{params[:location]}, and the mood is '#{params[:mood]}'."
  end

  def validate_suggestion_params
    required_keys = %i[days people budget location mood]
    missing_keys = required_keys.reject { |key| params[key].present? }
    unless missing_keys.empty?
      render json: { error: "Missing parameters: #{missing_keys.join(', ')}" }, status: :unprocessable_entity
    end
  end

end
