class UsersMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end

  def get
    response = {}
    response["status"] = 200
    response["info"] = Api::V0::UsersMessages.instance.get
    render :json => response
  end

  def get_generic
   	response = {}
    response["status"] = 200
    response["info"] = Constants::DATA::GENERIC_USERS_MESSAGES
    render :json => response
  end

  def send
    users = params["users"]
    messages = params["messages"]
    Api::V0::UsersMessages.instance.send_messages_to_users users, messages
  end

  def get_new_messages
    response = {}
    response["status"] = 200
    response["info"] = Api::V0::UsersMessages.instance.get_new_messages 
  end
end
