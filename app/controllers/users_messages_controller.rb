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

  # def send
  #   response = {}
  #   users = params["users"]
  #   messages = params["messages"]
  #   users_messages_instance = Api::V0::UsersMessages.instance
  #   users_messages_instance.send users, messages
  #   response["status"] = 200
  #   response["status"] = "success"
  #   render :json => response
  # end

  def get_new_messages
    response = {}
    response["status"] = 200
    response["info"] = Api::V0::UsersMessages.instance.get_new_messages 
    render :json => response
  end
end
