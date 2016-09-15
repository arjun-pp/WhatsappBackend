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

  def send_message
    response = {}
    users = [params["users"]].flatten
    messages = [params["messages"]].flatten
    users_messages_instance = Api::V0::UsersMessages.instance
    outgoing_messages = users_messages_instance.send users, messages
    response["status"] = 200
    response["info"] = outgoing_messages
    render :json => response
  end

  def get_new_messages
    response = {}
    response["status"] = 200
    # render :json => {"status":200,"info":{"received_messages":{"R Arjun":[{"type":"message-chat","direction":"message-in","text":"asd","id":"false_919868216583@c.us_3EB000AA3DD32C22E97F","time":"⁠⁠[14:56, 9/10/2016] R Arjun: ⁠⁠⁠"}]},"new_users":{"Gu"=>{"name"=>"Gu", "image_url"=>"https://dyn.web.whatsapp.com/pp?t=s&u=919910738426%40c.us&i=1473440444&ref=0%40k%2Fm9WLev%2B%2FtgDczQhabA0zLOtyNGtzah0HLAd3x03kZ%2F%2BCmsSZY9oFZW&tok=0%40%2FJjMPL0K%2BHu09L6chVlVj%2FkGHqo7QiyXGqfTo5qxLE7OW1S4ooA%2Fm1of0cv0NKlMb4JF0N9gUcMhCg%3D%3D", "unread_count"=>0, "phone_number"=>"+91 99107 38426", "messages"=>[{"type"=>"audio/video", "direction"=>"system"}, {"type"=>"message-chat", "direction"=>"message-in", "text"=>"??", "id"=>"false_919910738426@c.us_08D2C9F91A04F1AF23B133789E84E9", "time"=>"[09:36, 9/10/2016] Gu: "}]}}}}
    response["info"] = Api::V0::UsersMessages.instance.get_new_messages 
    render :json => response
  end

  def handle_received
    response = {}
    user = params["user"]
    Api::V0::UsersMessages.instance.handle_new_messages user
    response["status"] = 200
    response["info"] = "success"
    render :json => response
  end
end
