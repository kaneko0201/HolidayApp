Capybara.register_driver :chrome_with_logs do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:loggingPrefs" => { browser: "ALL" }
  )

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    capabilities: caps,
    options: options
  )
end

Capybara.javascript_driver = :chrome_with_logs
