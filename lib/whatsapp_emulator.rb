require 'singleton'
require_relative 'selenium_wrapper'
class WhatsAppEmulator
  include Singleton
  def initialize
    @driver = Selenium::WebDriver.for :firefox, listener: SeleniumWrapper.new
    @driver.get("https://web.whatsapp.com")
    @scroll_position = 0
  end

  def authenticate_roots
    puts 'Scan QR Code on admin device'.blue
    ok_button = nil
    while ok_button.nil?
      sleep(0.1)
      begin
        ok_button = @driver.find_element(:css => Constants::Css::BUTTON_AUTHENTICATION)
      rescue Selenium::WebDriver::Error::NoSuchElementError => no_element_error
        puts 'Still loading...'.blue
      end
    end
    ok_button.click
    puts 'Authentication SUCCESS'.green
  end

  def inject_script
    @driver.execute_script(Constants::INJECT_SCRIPT)
  end

  def find_chat_by_user(name)
    users = @driver.find_elements(:css => Constants::Css::ITEM_USER)
    target_user = nil
    users.each do |user|
      if user.text == name
        target_user = user
      end
    end
    byebug
    target_user

  end
  def select_user(name)
    users = @driver.find_elements(:css => Constants::Css::TEXT_USER_NAME)
    target_user = nil
    users.each do |user|
      if user.text == name
        target_user = user
      end
    end
    if target_user.nil?
      puts 'user not found'.red
      return false
    end
    target_user.click
    true
  end


  def search_user(name)
    @driver.find_element(:css => Constants::Css::ITEM_SEARCH).send_keys(name)
  end

  def type_message(message)
    @driver.find_element(:css => Constants::Css::ITEM_INPUT).click
    @driver.find_element(:css => Constants::Css::ITEM_INPUT).send_keys(message)
  end

  def click_send
    @driver.find_element(:css => Constants::Css::BUTTON_SEND).click
  end

  def send_message_to_user(message, name)
    selected = select_user(name)
    confirmed = confirm_selected_user(name)
    if selected and confirmed
      type_message(message)
      click_send
      return true
    end
    nil
  end

  def get_user_last_message(name)
    selected = select_user(name)
    text = ''
    if selected
      text = @driver.find_elements(:css => Constants::Css::TEXT_MESSAGE).last.text
    end
    text
  end

  def broadcast_message(message, list_name)
    send_message_to_user(message, list_name)
  end

  def get_unread_response

  end

  def get_user_chat_history(name)

  end

  def start_conversation_with_user(name)

  end

  def get_user_responses

  end

  def navigate_chats
    search_label = @driver.find_element(:css => Constants::Css::ITEM_LABEL_SEARCH)
    search_label.click
    search_label.send_key(:down)
  end

  def scroll_down_users(position_y)
    while @scroll_position < position_y
      sleep(rand(10)/100.0)
      @driver.execute_script("document.getElementById('#{Constants::ID::ITEM_SCROLL}').scrollTop = #{@scroll_position}")
      increment = 200 + rand(200)
      @scroll_position += increment
    end
  end

  def scroll_up_users(position_y)
    while @scroll_position > position_y
      sleep(rand(10)/100.0)
      increment = 200 + rand(200)
      @scroll_position -= increment
      if @scroll_position < 0
        @scroll_position = 0
      end
      @driver.execute_script("document.getElementById('#{Constants::ID::ITEM_SCROLL}').scrollTop = #{@scroll_position}")
    end
  end

  def confirm_selected_user(name)
    name == @driver.find_element(:css => Constants::Css::TEXT_CHAT_TITLE).text
  end

  def mouse_click_search
    search_label = @driver.find_element(:css => Constants::Css::ITEM_LABEL_SEARCH)
    byebug
    @driver.action.move_to(search_label).click(search_label).perform
    search_label.send_key(:down)
    search_label.send_key(:down)
  end




end