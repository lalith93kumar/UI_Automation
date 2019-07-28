module Pages
  class Home < Locators::Home
    def initialize(driver)
      super()
      @driver = driver
    end

    def select(locator,value)
      if locator.tag_name.include?('select')
        Selenium::WebDriver::Support::Select.new($focus_driver.find_element(locator)).select_by(:text, value)
        return value
      else
        locator.clear_and_send_keys(value)
        SUGGESTED_STATION(value).click
        return value
      end
    end

    def options_from_select(locator,value="")
      results = []
      if locator.tag_name == 'select'
        results = Selenium::WebDriver::Support::Select.new($focus_driver.find_element(locator)).options.map { |x| x.attribute('text') }
      else
        locator.clear_and_send_keys(value)
        results = SUGGESTED_STATION(value).texts
      end
      return results
    end

    def getOptionsTravelInfo(field_name,value="")
      return options_from_select(@fromOrigin,value) if field_name.include?('From')
      return options_from_select(@toOrigin,value) if field_name.include?('To')
      return options_from_select(TIMETYPE("Out"),value) if field_name.include?('TimeType')
      if field_name.include?('Adults')
        @passangerInfoTab.click
        values = options_from_select(PASSANGER_COUNT('Adults',1),value)
        @passangerDoneButton.scroll_to_locator();
        @passangerDoneButton.click();
      elsif field_name.include?('Child')
        @passangerInfoTab.click
        values = options_from_select(PASSANGER_COUNT('Child',1),value)
        @passangerDoneButton.scroll_to_locator();
        @passangerDoneButton.click();
      elsif field_name.include?('Age of children')
        @passangerInfoTab.click
        select(PASSANGER_COUNT("Child",1),"2");
        values = options_from_select(PASSANGER_COUNT('Age of children',1),value)
        @passangerDoneButton.scroll_to_locator();
        @passangerDoneButton.click();
      end
      return values
    end

    def fill(value)
      select(@fromOrigin,value['From']) if value.keys.include?('From')
      select(@toOrigin,value['To']) if value.keys.include?('To')
      if value.keys.include?('Out')
        if value['Out'].include?('Today')
          @todayButton.click();
        elsif value['Out'].include?('Tomorrow')
          @tomorrowButton.click();
          chooseTime("00","00")
        end
      end
      select(TIMETYPE("Out"),value['TimeType']) if value.keys.include?('TimeType')
      if value.keys.include?('Adults')
        @passangerInfoTab.click
        select(PASSANGER_COUNT('Adults',1),value['Adults'])
        @passangerDoneButton.scroll_to_locator();
        @passangerDoneButton.click();
      elsif value.keys.include?('Child')
        @passangerInfoTab.click
        child = value['Child'].split(',')
        value = optionsFromSelect(PASSANGER_COUNT('Child',1),child.first)
        (1..(child.length-1)).each do |i|
          select(PASSANGER_COUNT("Age of children",i),child[i]);
        end
        @passangerDoneButton.scroll_to_locator();
        @passangerDoneButton.click();
      end
    end

    def search(value)
      fill(value)
      @getTimeTicketsButton.click
      @searchDetails.text
    end

    def chooseTime(hours_value,min)
      select(@hour,hours_value)
      select(@minutes,min)
    end
  end
end
