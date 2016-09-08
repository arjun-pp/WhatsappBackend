module Api
	module V0
		class UsersMessages
			include Singleton
			def set users_messages
				@users_messages = users_messages
			end
			def get
				@users_messages
			end
		end
	end
end