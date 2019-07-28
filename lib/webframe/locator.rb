module WebFrame
  class Locator

    attr_accessor :how # How do you want to identify the element?
    attr_accessor :what # With what information do you want to locate element(s)
    def initialize(how,what,options = {})
      @how = how
      @what = what
      @options = options
    end

    ##################################################
    # Methods inherited and overriden from WebDriver #
    ##################################################

    ################# click
    # It is a wrapper method for selenium click
    #
    # ==== returns String value
    def click(driver = $focus_driver)
      driver.find_element(self).click
    end

    ################# text
    # It is a wrapper method for selenium text
    #
    # ==== returns String value
    def text(driver = $focus_driver)
      return driver.find_element(self).text
    end

    def texts(driver = $focus_driver)
      elements_text = []
      driver.find_elements(self).each do |element|
        elements_text.push(element.text)
      end
      return elements_text
    end

    ################# attribute
    # It is a wrapper method for selenium attribute
    #
    # ==== Attributes
    # * +name+ - name as string of attribute like 'class'
    def attribute(name, driver = $focus_driver)
      driver.find_element(self).attribute(name)
    end

    ################# text
    # It is a wrapper method for selenium displayed?
    #
    # ==== returns bool value
    def displayed?(driver = $focus_driver)
      driver.find_element(self).displayed?
    end

    ################# text
    # It is a wrapper method for selenium tag_name
    #
    # ==== returns string value
    def tag_name(driver = $focus_driver)
      driver.find_element(self).tag_name
    end

    ################# text
    # It is a wrapper method for selenium clear
    # It clears value of input tag or text element
    def clear(driver = $focus_driver)
      driver.find_element(self).clear
    end

    def scroll_to_locator(driver = $focus_driver)
      driver.scroll_to_locator(self)
    end

    def clear_and_send_keys(*args)
      clear($focus_driver)
      send_keys(*args)
    end

    ################# text
    # It is a wrapper method for selenium send_keys
    # ==== Attributes
    # * +args+ - args as string of attribute like 'bfwebw'
    def send_keys(args)
      $focus_driver.find_element(self).send_keys(args)
    end
  end
end
