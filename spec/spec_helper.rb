# File will act as a hooks
# requires all gem or package needs for execution
require 'rspec/core'
require 'httpclient'
require 'byebug'
require "json-schema"
require 'allure-rspec'
require 'parallel_tests'
require 'selenium-webdriver'

# loads the endpoint into a hash value
$conf = YAML.load_file('testData/staging.yml')
# loads the testrails credentials into a hash value
$TESTRAILS_DATA = YAML.load_file('testData/testrails_details.yml')
require_relative "../lib/webframe/driver.rb"
require_relative "../lib/webframe/locator.rb"
include WebFrame
require_relative "../lib/testrails_client.rb"
require_relative "../lib/client.rb"
require_relative "../locators/home.rb"
require_relative "../pages/home.rb"
# initialze testrails object
$test_rails_client = TestRailsclient.new($TESTRAILS_DATA['Testrails'])
# allure report configuration
AllureRSpec.configure do |config|
  config.output_dir = "reports/allure"
  config.clean_dir = false
  config.logging_level = Logger::WARN
end
RSpec.configure do |config|
  config.include AllureRSpec::Adaptor
  config.formatter = :documentation
  config.before(:suite) do
    begin
      FileUtils.mkdir_p("#{Pathname.pwd}/reports/allure") unless File.file?("#{Pathname.pwd}/reports/allure/environment.properties")
      File.open("#{Pathname.pwd}/reports/allure/environment.properties", 'w') do |f|
        f.write("Report=Api Testing\n")
        f.write("Url=http://api.dataatwork.org/v1/\n")
      end
    rescue Exception => e
      puts e.message
    end
  end
  # Updating status of testcases in testrails.
  config.after(:each) do |e|
    case_id = e.metadata[:test_id]
    if e.exception.nil?
      $test_rails_client.set_statuses(case_id,{'status_id' => 1,'comment' => 'Passed'})
    else
      $test_rails_client.set_statuses(case_id,{'status_id' => 5,'comment' => e.exception.message})
    end
  end
end
