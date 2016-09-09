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
  	handle_qr_code
  	handle_privacy_policy_popup
    puts 'Authentication SUCCESS'.green
  end

  def handle_qr_code
    qr_code_element = @driver.find_element(:css => Constants::Css::QR_CODE) rescue nil
    while true
      if qr_code_element
        begin
          while @driver.find_element(:css => Constants::Css::QR_CODE)
            puts 'Scan QR Code on admin device'.red
            sleep(5)
          end
        rescue Selenium::WebDriver::Error::NoSuchElementError 
          break
        end
      end
	    qr_code_element = @driver.find_element(:css => Constants::Css::QR_CODE) rescue nil
    end
    puts 'Successfully authenticated qr code'.green
  end

  def handle_privacy_policy_popup
  	sleep 5
    chats = @driver.find_element(:css => Constants::Css::USER_INFO_CONTAINER) rescue nil
    if chats.nil?
      ok_button = nil
      while ok_button.nil?
        sleep 5
        ok_button = @driver.find_element(:css => Constants::Css::BUTTON_AUTHENTICATION) rescue nil
      end
      ok_button.click
    end
  end

  def inject_script
    @driver.execute_script(Constants::INJECT_SCRIPT)
  end

  def find_chat name
    search_user name
    users = @driver.find_elements(:css => Constants::Css::ITEM_USER)
    target_user = nil
    users.each do |user|
      if user.text == name
        target_user = user
      end
    end
    target_user
  end

  def select_user(name)
    target_user = find_chat name
    target_user.click
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

  def send_messages_to_users users, messages
    for user in users
      message_sent = send_messages_to_user user, messages
      if message_sent
        puts "#'{messages}' sent to #{user}".green
      else
        puts "'#{messages}' not sent to #{user}".red
      end
    end
  end

  def send_messages_to_user(user, messages)
    name = user["name"]
    is_user_existing = false
    selected = select_user name
    if selected
      is_user_existing = true
      for message in messages
        type_message message
        click_send
        sleep 1
    end
    is_user_existing
  end

  def get_unread_messages name, last_read_message_time
    user = select_user name 
    messages = get_selected_user_messages
    new_messages = messages
    messages.each_with_index do |index, message|
      if message["time"] == last_read_message_time
        new_messages = messages[index + 1..-1]
        break
    end
    new_messages
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

  def get_all_users_messages
  	sleep 5
  	users = {}
    users_info_containers = @driver.find_elements(:css => Constants::Css::USER_INFO_CONTAINER)
    for user_info_container in users_info_containers
        begin
          user = get_selected_user_info_messages user_info_container
          puts user
        rescue Exception => e
        end
        users[user["name"]] = user
    end
    users
  end

  def get_user_info name
      search_user name
      users_info_container = @driver.find_elements(:css => Constants::Css::USER_INFO_CONTAINER).first
      get_selected_user_info_messages user_info_container
  end

  def get_selected_user_info_messages user_info_container
  		puts "getting user info ".yellow
    	user = {}
    	click_element user_info_container
    	user_info_header = @driver.find_elements(:css => Constants::Css::USER_CHAT_HEADER)[1]

    	user["name"] = Nokogiri::HTML(user_info_container.attribute("innerHTML")).at_css(Constants::Css::TEXT_USER_NAME).text
    	user["image_url"] = Nokogiri::HTML(user_info_container.attribute("innerHTML")).at_css(Constants::Css::AVATAR_IMAGE).attr("src") rescue nil
      user["unread_count"] = Nokogiri::HTML(user_info_container.attribute("innerHTML")).at_css(Constants::Css::UNREAD_COUNT).text rescue 0 
    	click_element user_info_header

    	user["phone_number"] = @driver.find_elements(:css => Constants::Css::USER_PHONE_NUMBER)[0].text.split("\n")[1]

  		puts "Getting messages for #{user["name"]}".yellow
    	user["messages"] = get_selected_user_messages
    	user
  end

  def get_selected_user_messages 
		puts "getting user messages ".yellow
  	messages = []
  	group_messages_elements = @driver.find_elements(:css => Constants::Css::GROUP_MESSAGE)
  	if group_messages_elements.length > 0
  		messages = get_group_messages
  	else 
  		messages = get_user_to_user_messages 
  	end
  	messages
  end

  def get_group_messages
    group_messages_elements = @driver.find_elements(:css => Constants::Css::OUTER_MESSAGE)
    puts "getting group messages".yellow
    []
  end

  def get_user_to_user_messages  
  	puts "getting user to user messages".yellow
  	messages = []
  	messages_elements = @driver.find_elements(:css => Constants::Css::OUTER_MESSAGE)
		for message_element in messages_elements
  		message = {}
  		
  		message_html = Nokogiri::HTML(message_element.attribute("innerHTML"))
  		message["type"] = get_message_type message_html
  		message["direction"] = get_message_direction message_html
      if message["type"] == Constants::Css::MESSAGE_TYPE_CHAT 
        message["time"] = message_html.at_css(Constants::Css::MESSAGE_TIME).text rescue ""
    		message["text"] = message_html.at_css(Constants::Css::MESSAGE_TEXT).text rescue ""
    		message["id"] = message_html.at_css(Constants::Css::MESSAGE_ID).attr["data-id"] rescue ""
    	end
    	messages.append(message)
		end
		messages
  end

  def get_message_type message_html
  	messages_elements_classes = message_html.at_css(Constants::Css::INNER_MESSAGE)["class"] 
  	if messages_elements_classes.include? Constants::Css::MESSAGE_TYPE_CHAT
  		message_type = Constants::Css::MESSAGE_TYPE_CHAT
  	elsif messages_elements_classes.include? Constants::Css::MESSAGE_TYPE_IMAGE
  		message_type = Constants::Css::MESSAGE_TYPE_IMAGE
  	else
  		message_type = "audio/video"
  	end
  	message_type
  end

  def get_message_direction message_html
  	messages_elements_classes = message_html.at_css(Constants::Css::INNER_MESSAGE)["class"] 
  	if messages_elements_classes.include? Constants::Css::MESSAGE_DIRECTION_OUT
  		message_direction = Constants::Css::MESSAGE_DIRECTION_OUT
  	elsif messages_elements_classes.include? Constants::Css::MESSAGE_DIRECTION_IN
  		message_direction = Constants::Css::MESSAGE_DIRECTION_IN
  	else
  		message_direction = "system"
  	end
  	message_direction
  end

  def click_element element
		sleep 1
  	while not element.click == Constants::Css::SUCCESSFULL_CLICK_MESSAGE
  		sleep 1
  	end
  	sleep 1
  end
end