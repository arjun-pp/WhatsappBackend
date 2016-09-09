module Api
  module V0
    class NotificationHandler
      def self.handle_text_notification(params)
        puts "#{params['user']} received a message".to_s.green
        # x = rand(40);
        # arr = ["So What's up"]
        # arr = ["So What's up", "Welcome to roots.", "How may I help you"]

        Api::V0::UsersMessages.instance.handle_received_message params['user']
        
      end
    end
  end
end
