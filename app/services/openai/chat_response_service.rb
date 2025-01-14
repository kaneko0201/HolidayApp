module Openai
  class ChatResponseService < BaseService
    def call(input)
      body = build_body(input)
      response = post_request(url: '/v1/chat/completions', body: body)
      extract_message_content(response)
    end

    private

    def build_body(input)
      {
        model: @model,
        messages: [{ role: "user", content: input }]
      }.to_json
    end

    def extract_message_content(response)
      response_hash = JSON.parse(response.body)
      content = response_hash.dig("choices", 0, "message", "content")
      raise StandardError, 'チャットの返信が取得できませんでした。' unless content.present?

      content
    rescue JSON::ParserError
      raise StandardError, 'チャットの返信が取得できませんでした。'
    end
  end
end
