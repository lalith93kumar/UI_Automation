require 'spec_helper.rb'
RSpec.describe "All Options in search module fields" do
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
  [{'testId' => 99,'field_name' => 'From', 'starts_with' => 'Acton', 'option_list'=> 'Acton Bridge (Cheshire);Acton Central;Acton Main Line;South Acton'},
   {'testId' => 100,'field_name' => 'To', 'starts_with' => 'Maesteg', 'option_list'=> 'Maesteg;Maesteg, Any;Maesteg (Ewenny Road)'},
   {'testId' => 101,'field_name' => 'Adults', 'option_list'=> '0;1;2;3;4;5;6;7;8;9'},
   {'testId' => 102,'field_name' => 'Child', 'option_list'=> '0;1;2;3;4;5;6;7;8;9'},
   {'testId' => 103,'field_name' => 'TimeType', 'option_list'=> 'Leaving at;Arriving by'},
   {'testId' => 104,'field_name' => 'Age of children', 'option_list'=> '0-2;3-4;5-15'},
  ].each do |x|
    it "Check whether option displayed in field: #{x['field_name']}",:test_id => x['testId'] do
      expect(@home_page.getOptionsTravelInfo(x['field_name'],x['starts_with'])).to match_array(x['option_list'].split(';'))
    end
  end

end
