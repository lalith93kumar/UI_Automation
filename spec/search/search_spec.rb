require 'spec_helper.rb'
RSpec.describe "Search Module Train Availablity" do
  before(:each) do
    @driver = Driver.new();
    @driver.get($conf['base_url'])
    @home_page = Pages::Home.new(@driver)
  end

  after(:each) do |e|
    unless e.exception.nil?
      begin
        e.attach_file('screenshot', $focus_driver.save_screenshot)
        @driver.refresh
      rescue Exception => e
        puts e.message
        puts e.backtrace
      end
    end
  end

  after(:each) do
    @driver.quit_all
  end

  it "Search for train Availablity for todays date",:test_id => '97' do
    data  = {
      'From' => 'Bare Lane',
      'To' => 'Maesteg',
      'Via' => 'One Way',
      'Out' => 'Today',
      'TimeType' => 'Leaving at',
      'Adults' => '3'
    }
    expect(@home_page.search(data)).to include('Your search: Bare Lane to MaestegSingle journey3 adults')
  end

  it "Search for train Availablity for tomorrow date",:test_id => '98' do
    data  = {
      'From' => 'Bare Lane',
      'To' => 'Maesteg',
      'Via' => 'One Way',
      'Out' => 'Tomorrow',
      'TimeType' => 'Arriving by',
      'Adults' => '5'
    }
    expect(@home_page.search(data)).to include('Your search: Bare Lane to MaestegSingle journey5 adults')
  end

end
