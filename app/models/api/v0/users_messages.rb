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
				whatsapp = WhatsAppEmulator.instance
				for user in users
					whatsapp.send_to_user user, messages
				end
			end

			def get_new_messages
				new_messsages = {"received_messages": @received_messages, "new_users": @new_users}
				@received_messages = {}
				@new_users = {}
				new_messsages
			end

			def handle_received_message name
				if @user_messages[name].exists?
					last_read_message_time = (@users_messages["name"]["messages"].last)["time"]
					unread_messages = WhatsAppEmulator.instance.get_unread_messages params['user'], last_read_message_time
					@user_messages[name]["messages"] += unread_message
				else
					whatsapp = WhatsAppEmulator.instance
					user_info = whatsapp.get_user_info name
					@users_messages[name] = user_info
					@new_users[user_info["name"]] = user_info
				end
			end
		end
	end
end