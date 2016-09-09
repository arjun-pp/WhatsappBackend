(
    function (){
        'use strict';

        angular.module('message')
                .controller('MessageController', MessageController);

    /** @ngInject */
    function MessageController($scope, MessageService, $interval){
        var vm = this;
        vm.selected_messages = []
        get_users_info();
        getGenericMessages();
        getNewMessages();
        function get_users_info(){
            var promise = MessageService.get_users_info();
            promise.then(
                function(response){
                    vm.users_info = response.data.info;
                    vm.current_user_messages = vm.users_info[2].messages;
                },
                function(error){
                    console.log("Error in fetching user messages");
                }
            )
        }

        function setCurrentUser(current_user_index){
            vm.current_user = vm.users_info[current_user_index];
            vm.current_user_messages = vm.current_user.messages; 
            console.log("CurrentUser Selected");
        }

        function getGenericMessages(){
            var promise = MessageService.getGenericMessages();
            promise.then(
                function(response){
                    vm.generic_messages = response.data.info;
                },
                function(error){
                    console.log("Error in fetching user messages");
                }
            )            
        }

        function addGenericMessage(message){
            var idx = vm.selected_messages.indexOf(message);
            if (idx > -1) {
                  list.splice(idx, 1);
            }
            else {
                list.push(item);
            }
        }

        function existsSelectedGenericMessage(){
            return vm.selected_messages.length > 0;
        }

        function send(){
            users_messages = {"users": [vm.current_user], "messages": vm.selected_messages},
            MessageService.send(users_messages)
        }

        function sendToAll(){
            var users = [];
            for(var user in vm.users_info) users.push(user);
            users_messages = {"users": users, "messages": vm.selected_messages},
            MessageService.send(users_messages)
        }
        // function get_user_messages(current_user){
        //     console.log(vm.users_info[vm.current_user].messages);
        //     return vm.users_info[vm.current_user].messages;
        // }

        function getNewMessages(){
            var promise = $interval(MessageService.getNewMessages, 5000);
            promise.then(
                function(response){
                    vm.setReceivedUserInfo(response.data.info);
                },
                function(error){
                    console.log("Error in fetching user messages");
                }
            )            
        }

        function setReceivedUserInfo(users_info){
            for (name, messages) in users_messages.received_messages{
                vm.users_info.name.messages.concat(messages);
                vm.users_info.name.unread_message = true; 
            }
            Object.assign(vm.users_info, users_info.new_users);
        }
    }
})();
