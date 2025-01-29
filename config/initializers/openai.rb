OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.log_errors = true # OpenAI がどのようなエラーを返しているかを見ることができます。プライベートなデータがログに漏れる可能性があるので、本番環境では推奨しません。
end
