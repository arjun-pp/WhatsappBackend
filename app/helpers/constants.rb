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
  end

  module ID
    ITEM_SCROLL = 'pane-side'
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