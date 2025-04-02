OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_ACCESS_TOKEN"] || "dummy"
  config.log_errors = false
end
