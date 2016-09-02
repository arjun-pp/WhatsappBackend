module Api
  module V0
    class NotificationApiController < ApplicationController
      skip_before_action :verify_authenticity_token
      def message_received
        results = Api::V0::NotificationHandler.handle_text_notification(params)
      end
    end
  end
end