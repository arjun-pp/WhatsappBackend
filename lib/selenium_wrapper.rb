class SeleniumWrapper < Selenium::WebDriver::Support::AbstractEventListener

  def after_navigate_to(url, driver)
    puts url
    add_javascript(driver)
  end
  private
  def add_javascript(driver)
    driver.execute_script("var observeDOM = (function(){
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
var chats = document.getElementsByClassName('chat-secondary');
Array.from(chats).forEach( function(chat_body, i) {
// Observe a specific DOM element:
    observeDOM( chat_body ,function(){
    //Do this when change is observed

	    console.log('count:' + j + ' ' + chat_body.textContent);
	    j++;
	    if(chat_body.children[1].children[0].children.length > 0 && chat_body.children[1].children[0].children[0].className === 'icon-meta unread-count'){
	    	//Name of Sender
	    	console.log(chat_body.parentElement.children[0].children[0].textContent);
	    	var xhttp = new XMLHttpRequest();
	    	xhttp.open('POST', 'http://localhost:3000/api/v0/message_notification', false);
			xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
			xhttp.send('user=' + chat_body.parentElement.children[0].children[0].textContent);
	    }

	});
});

      ")

  end
  def display_growl(driver, message)
    driver.execute_script("alert('#{message}');")
    sleep 1
    driver.switch_to.alert.accept
  end
end