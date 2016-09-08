module Constants
  module Css
    BUTTON_AUTHENTICATION = 'button.btn-plain.btn-default.popup-controls-item'
    ITEM_USER = '.chat-body'
    ITEM_SEARCH = 'input.input.input-search'
    ITEM_INPUT = 'div.input'
    BUTTON_SEND = 'button.icon.btn-icon.icon-send.send-container'
    TEXT_MESSAGE = '.message-text'
    TEXT_USER_NAME = 'div.chat-title'
    TEXT_CHAT_TITLE = 'h2.chat-title'
    ITEM_LABEL_SEARCH = 'label.cont-input-search'
    ITEM_SEARCH_CONTAINER = 'div.search-container'
    USER_INFO_CONTAINER = "div.chat"
    USER_IMAGE = "img.avatar-image"
    QR_CODE = "div.qrcode"
    USER_CHAT_HEADER = ".pane-header"
    # USER_PHONE_NUMBER = "textfield-static"
    AVATAR_IMAGE= ".avatar-image"
    USER_PHONE_NUMBER = ".animate-enter2"
    SUCCESSFULL_CLICK_MESSAGE = "ok"
    OUTER_MESSAGE = ".msg"
    INNER_MESSAGE = ".message"
    MESSAGE_TYPE_CHAT = "message-chat"
    MESSAGE_TYPE_IMAGE = "message-image"
    MESSAGE_DIRECTION_OUT = "message-out"
    MESSAGE_DIRECTION_IN = "message-in"
    MESSAGE_TEXT = ".selectable-text"
    MESSAGE_TIME = ".message-datetime"
    GROUP_MESSAGE = ".msg-group"
  end

  module ID
    ITEM_SCROLL = 'pane-side'
  end

  module DATA
    USERS_MESSAGES = [{"name"=>"Yash", "image_url"=>"https://dyn.web.whatsapp.com/pp?t=s&u=14804343147%40c.us&i=1442567214&ref=0%40saUpL6EFvwWxDQxKDQrOjinQxZGXAYybqiAiWfOWfPQlZL05AMna2lLS&tok=0%405wyPTvJYJ4PqdrAOTAFYopL%2BHefBgOTeJZ03%2FxzROvFE9YHF72GRiUiqV%2B7w%2BEy5V0wqAjiAh%2Bf8ng%3D%3D", "phone_number"=>"+1 (480) 434-3147", "messages"=>[{"type"=>"audio/video", "direction"=>"system"}, {"type"=>"message-chat", "direction"=>"message-out", "text"=>"Aur kutiya", "time"=>"11:47"}]}]
  end

  INJECT_SCRIPT = "var observeDOM = (function(){
    var MutationObserver = window.MutationObserver || window.WebKitMutationObserver,
        eventListenerSupported = window.addEventListener;

    return function(obj, callback){
        // if( MutationObserver ){
        //     // define a new observer
        //     console.log('Mutation')
        //     var obs = new MutationObserver(function(mutations, observer){
        //         if( mutations[0].addedNodes.length || mutations[0].removedNodes.length )
        //             callback();
        //     });
        //     // have the observer observe foo for changes in children
        //     obs.observe( obj, { childList:true, subtree:true });
        // }
        // else
        	if( eventListenerSupported ){
        	console.log('Event')
            obj.addEventListener('DOMNodeInserted', callback, false);
            //obj.addEventListener('DOMNodeRemoved', callback, false);
        }
    }
})();
j = 0
var unread_count = {}
var chats = document.getElementsByClassName('chat-secondary');
Array.from(chats).forEach( function(chat_body, i) {
// Observe a specific DOM element:
    observeDOM( chat_body ,function(){
    //Do this when change is observed

	    console.log('count:' + j + ' ' + chat_body.textContent);
	    j++;
	    if(chat_body.children[1].children[0].children.length > 0 &&
(chat_body.children[1].children[0].children[0].className === 'icon-meta unread-count') &&
(!chat_body.textContent.startsWith('typing...'))){
	    	//Name of Sender
	    	//console.log(chat_body.parentElement.children[0].children[0].textContent);
	    	var xhttp = new XMLHttpRequest();
	    	xhttp.open('POST', 'https://localhost:3000/api/v0/message_notification', true);
			  xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
			  xhttp.send('user=' + chat_body.parentElement.children[0].children[0].textContent);
	    }

	});
});

      "
end