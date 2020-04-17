require 'selenium-webdriver'
require './.env.rb'

@driver = Selenium::WebDriver.for :chrome
# @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
@driver.manage.timeouts.implicit_wait = 0

def runner
  login
  import_files
end

def import_files
  i = 26
  (158 - i).times do 
    @driver.get "https://abrafast.store/wp-admin/edit.php?post_type=product&page=product_importer"
    click_element(@driver, :class, 'woocommerce-importer-toggle-advanced-options')
    input_field = get_element(@driver, :id, 'woocommerce-importer-file-url')
    input_field.send_keys("/wp-content/uploads/import/split#{i}.csv") #file name here
    click_element(@driver, :css, '[type="submit"]')
    click_element(@driver, :css, '[value="Run the importer"]')
    puts "File # #{i} importing"
    start = Time.now
    wait_for(7200000) {@driver.find_element(css: ".woocommerce-importer-done").displayed?}
    # expect (@driver.find_element(css: ".woocommerce-importer-done"))
    # get_element(@driver, :class, 'woocommerce-importer-done')
    puts "Import Successful"
    finish = Time.now
    dif = finish - start
    puts "Time to run: #{dif} seconds"
    puts "******"
    i += 1
  end
end

def login 
  @driver.get "https://abrafast.store/wp-admin"
  add_input(@driver, :id, "user_login", USER_NAME)
  add_input(@driver, :id, "user_pass", PASSWORD)
  click_element(@driver, :id, 'wp-submit')
end

def wait_for (seconds)
  Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
end

def get_element (instance, selector, selector_name)
  wait_for(10) {
    element = instance.find_element(selector, selector_name)
    element if element.displayed?
  }
end

def add_input (instance, selector, selector_name, input)
  element = wait_for(10) {
    element = instance.find_element(selector, selector_name)
    element if element.displayed?
  }
  element.send_keys(input)
end 

def click_element (instance, selector, selector_name)
  element = wait_for(10) {
    element = instance.find_element(selector, selector_name)
    element if element.displayed?
  }
  element.click
end 

runner
