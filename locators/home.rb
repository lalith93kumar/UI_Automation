module Locators
  class Home

    def initialize
      @fromOrigin = Locator.new(:id,"from.text")
      @toOrigin = Locator.new(:id,"to.text")
      @passangerInfoTab = Locator.new(:id,"passenger-summary-btn")
      @todayButton = Locator.new(:xpath,"//span[text()='Today']")
      @tomorrowButton = Locator.new(:xpath,"//span[text()='Tomorrow']")
      @passangerDoneButton = Locator.new(:xpath,"//button[@data-test='passenger-summary-btn-done']")
      @getTimeTicketsButton = Locator.new(:xpath,"//button[@data-test='submit-journey-search-button']")
      @searchDetails = Locator.new(:xpath,"//h2[contains(string(),'Your search')]/parent::div")
      @searchTrainSuggestion = Locator.new(:xpath,"//button[@data-test='train-results-earlier']/parent::div//li")
      @intialsearchTrainSuggestion = Locator.new(:xpath,"//h3[@data-test='OUTWARD-travel-date']")
      @nextMonth = Locator.new(:xpath,"//button[@data-test='calendar-next']")
      @previousMonth = Locator.new(:xpath,"//button[@data-test='calendar-previous']")
      @currentMonth = Locator.new(:xpath,"//h3[@data-test='calendar-title']")
      @dateInput = Locator.new(:xpath,"//input[@data-test='date-input-field']")
      @fromError = Locator.new(:xpath,"//div[@data-test='empty-from-station']//span")
      @toError = Locator.new(:xpath,"//div[@data-test='empty-to-station']//span")
      @hour = Locator.new(:name,"hours")
      @minutes = Locator.new(:name,"minutes")
    end

    attr_accessor *Home.new.instance_variables.map { |s| s[1..-1] }

    def TIMETYPE(name)
      Locator.new(:xpath, "//legend[string()='#{name}']/parent::fieldset//select[contains(@data-test,'after-dropdown')]")
    end

    def DAY(name)
      Locator.new(:xpath, "//a[@title='#{name}']")
    end

    def PASSANGER_COUNT(name,index)
      Locator.new(:xpath, "//span[contains(string(),'#{name}')]/parent::h5/following-sibling::div[#{index}]//select")
    end

    def SUGGESTED_STATION(name)
      Locator.new(:xpath, "//ul[@data-test='suggestion-field-list']//div[contains(normalize-space(),'#{name}')]")
    end

    def VIA(value)
      Locator.new(:xpath, "//span[contains(text(),'#{value}')]/preceding-sibling::div/input")
    end
  end
end
