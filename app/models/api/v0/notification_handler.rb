module Api
  module V0
    class NotificationHandler
      def self.handle_text_notification(params)
        puts params['user'].to_s.green
        x = rand(40);
        arr = ["So What's up"]
        # arr = ["So What's up", "Welcome to roots.", "How may I help you"]
        last_message = WhatsAppEmulator.instance.get_user_last_message(params['user'])
        if not arr.include? last_message
          WhatsAppEmulator.instance.send_message_to_user(arr[x%3], params['user'])
        end
      end
    end
  end
end
