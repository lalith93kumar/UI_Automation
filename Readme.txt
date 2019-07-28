URL : https://www.thetrainline.com/
Instruction:
Open the terminal & follow the below instruction
	Download the repo - https://github.com/lalith93kumar/UI_Automation.git
	Download chromedriver Latest version 3.14
	Move chromedriver into bin folder
	Move to the directory - cd Selenium
	Install homebrew from http://brew.sh/
	Install Rvm  - brew install Rvm
	Install Rvm  - rvm install ruby
	Install Bunbler - brew install bunbler3
	Bundle install

Run :
    parallel_rspec spec

Allure Report:
    allure generate reports/allure/
    allure report open