module Api
	module V0
		class UsersMessages
			include Singleton
			def initialize
				@received_messages = {}
				@new_users = {}
			end
			def set users_messages
				@users_messages = users_messages
			end
			def get
				@users_messages
			end

			def get_generic
				Constants::DATA::GENERIC_USERS_MESSAGES
			end

			def send users, messages
				outgoing_users_messages = {}
				whatsapp = WhatsAppEmulator.instance
				whatsapp.send_messages_to_users users, messages
				for user in users
					outgoing_user_messages = handle_outgoing_messages user
					outgoing_users_messages[user] = outgoing_user_messages
				end
				outgoing_users_messages
			end

			def handle_outgoing_messages user
				outgoing_message = scrape_new_messages user
				@users_messages[user]["messages"] += outgoing_message
				outgoing_message
			end

			def get_new_messages
				new_messsages = {"received_messages": @received_messages, "new_users": @new_users}
				@received_messages = {}
				@new_users = {}
				new_messsages
			end

			def handle_new_messages name
				if @users_messages[name]
					unread_messages = scrape_new_messages name
					store_new_messages name, unread_messages
				else
					user_info = WhatsAppEmulator.instance.get_user_info name
					store_new_user user_info
				end
			end

			def scrape_new_messages name
				last_read_message_id = (@users_messages[name]["messages"].last)["id"]
				WhatsAppEmulator.instance.get_unread_messages name, last_read_message_id
			end

			def store_new_messages name, messages
				@users_messages[name]["messages"] += messages
				@received_messages[name] ||= []
				@received_messages[name] += messages
				puts "stored #{@received_messages}"
			end

			def store_new_user user_info
				if user_info
					@users_messages[user_info["name"]] = user_info
					@new_users[user_info["name"]] = user_info
					puts "stored #{@new_users}"
				end
			end
		end
	end
end