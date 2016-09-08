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
end
