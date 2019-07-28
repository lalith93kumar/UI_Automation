module WebFrame
  class Driver
    $focus_driver = nil
    attr_accessor :driver
    @driver = nil
    @click_exception_count = nil
    @@drivers = []
    def initialize(browser = $conf['browser'], opts = {})
      start(browser, opts)
      @wait = Selenium::WebDriver::Wait.new(:timeout => $conf['implicit_wait'])
    end

    ##############################
    # Custom methods of webframe #
    ##############################

    ################# start
    # Method to initiate start brower based on bowser & option hash values
    # This method need to improve to support firefox, IE, Remote
    # ==== Attributes
    # * +browser+ - Browser name as string eg: 'Chrome'
    # * +opts+ - opts is a hash value eg: please refer staging.yml file under testData folder
    def start(browser, opts = {})
      dimensions = $conf['dimensions']
      if (!dimensions['horizontal'] or !dimensions['vertical'])
        dimensions = {'horizontal' => 1366, 'vertical' => 768}
      end
      if (!$conf['implicit_wait'])
        $conf['implicit_wait'] = 20
      end
      prefs = {}
      if opts.empty?
        switches = $conf['switches']
        prefs = $conf['prefs'] if $conf.key?('prefs')
      elsif opts.key?(:switches)
        switches = opts[:switches]
      elsif opts.key?(:prefs)
        prefs = opts[:prefs]
      end

      case browser
      when 'chrome'
        options = Selenium::WebDriver::Chrome::Options.new
        # options.add_preference(:download, prefs["download"]) if prefs["download"]
        if prefs
          prefs.each do |key, value|
            options.add_preference(key, value)
          end
        end

        if opts.key?(:extension)
          options.add_extension(opts[:extension])
        end
        switches.map { |k| options.add_argument(k) }
        @driver = Selenium::WebDriver.for(:chrome, options: options)
      else
        raise ArgumentError, "unknown browser: #{browser.inspect}"
      end
      target_size = Selenium::WebDriver::Dimension.new(dimensions["horizontal"], dimensions["vertical"])
      @driver.manage.window.size = target_size
      @click_exception_count=0
      @@drivers.push(self)
      $focus_driver = self
      return self
    end

    ################# get
    # Method to load the url in browser
    #
    # ==== Attributes
    # * +url+ - url as string eg: 'www.google.com'
    def get(url)
      $focus_driver = self
      @driver.get(url)
    end

    ################# find_element
    # It is a wrapper method for selenium find element
    #
    # ==== Attributes
    # * +locator+ - locator as object of loactor class
    def find_element(locator)
      $focus_driver = self
      @wait.until{
        element = @driver.find_element(locator.how,locator.what)
        element if element.displayed?
      }
      return @driver.find_element(locator.how,locator.what)
    end

    ################# find_element
    # It is a wrapper method for selenium find elements
    #
    # ==== Attributes
    # * +locator+ - locator as object of loactor class
    def find_elements(locator)
      $focus_driver = self
      @wait.until{
        element = @driver.find_element(locator.how,locator.what)
        element if element.displayed?
      }
      return @driver.find_elements(locator.how,locator.what)
    end

    ################# current_url
    # It is a wrapper method for selenium current_url
    #
    # ==== returns String value
    def current_url
      $focus_driver = self
      @driver.current_url
    end

    ################# execute_script
    # It is a wrapper method for selenium execute_script
    #
    # ==== Attributes
    # * +script+ - string value
    def execute_script(script)
      $focus_driver = self
      @driver.execute_script(script)
    end

    ################# save_screenshot
    # It is a used to save screenshot of current browser screent and stored in file path
    #
    # ==== Attributes
    # * +file_name+ - string value
    def save_screenshot(file_name = nil)
      $focus_driver = self
      file_name = "#{Pathname.pwd}/#{$conf['screenshot_location']}/#{Time.new.strftime("%Y-%m-%d-%H-%M-%S")}.png" if file_name.nil?
      @driver.save_screenshot(file_name)
    end

    ################# scroll_to_locator
    # It is a is used to move brower view to a element as center of browser
    #
    # ==== Attributes
    # * +locator+ - locator as object of loactor class
    def scroll_to_locator(locator)
      $focus_driver = self
      element = find_element(locator)
      @driver.execute_script("arguments[0].scrollIntoView({behavior: 'smooth', block: 'center', inline: 'nearest'});",element)
      sleep 1
    end

    ################# quit
    # It is a wrapper method for selenium quit
    #
    def quit
      @driver.quit
      @@drivers.delete(self)
      $focus_driver = @@drivers[0]
    end

    def quit_all
      begin
        @@drivers.each do |driver|
          driver.quit if driver != self
        end
        self.quit
      rescue Exception => e
      end
    end
  end
end
