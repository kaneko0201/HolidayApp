if ENV["OPENAI_ACCESS_TOKEN"].present?
  OpenAI.configure do |config|
    config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
    config.log_errors = false
  end
end
