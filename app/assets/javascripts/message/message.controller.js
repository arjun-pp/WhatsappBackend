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
        vm.sending_messages = false
    
        function get_users_info(){
            var promise = MessageService.get_users_info();
            promise.then(
                function(response){
                    vm.users_info = response.data.info;
                },
                function(error){
                    console.log("Error in fetching user messages");
                }
            )
        }

        $scope.setCurrentUser = function(name) {
            vm.current_user = vm.users_info[name];
            vm.current_user_messages = vm.current_user.messages; 
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

        $scope.addGenericMessage = function(message) {
            var idx = vm.selected_messages.indexOf(message);
            if (idx > -1) {
                  vm.selected_messages.splice(idx, 1);
            }
            else {
                vm.selected_messages.push(message);
            }
        }

        $scope.existsSelectedGenericMessage = function() {
            return vm.selected_messages.length > 0;
        }

        $scope.send = function() {
            var users_messages = {"users": [vm.current_user.name], "messages": vm.selected_messages};
            sendMessages(users_messages);
        }

        $scope.sendToAll = function() {
            var users_messages = {"users": Object.keys(vm.users_info), "messages": vm.selected_messages};
            sendMessages(users_messages);
        }

        function sendMessages(users_messages){
            vm.sending_messages = true;
            var promise = MessageService.send(users_messages);
            promise.then(
                function (response){
                    var outgoing_messages = response.data.info
                    for (var user in outgoing_messages){
                        vm.users_info[user].messages = vm.users_info[user].messages.concat(outgoing_messages[user])
                    }
                    vm.sending_messages = false;
                },
                function (response){
                    vm.sending_messages = false;
                }
            )

        }
        // function get_user_messages(current_user){
        //     console.log(vm.users_info[vm.current_user].messages);
        //     return vm.users_info[vm.current_user].messages;
        // }

        $scope.existsCurrentUser = function() {
            return typeof vm.current_user !== 'undefined'
        }

        $interval(getNewMessages, 10000);
        function getNewMessages(){
            var promise = MessageService.getNewMessages();
            promise.then(
                function(response){
                    setReceivedUserInfo(response.data.info);
                },
                function(error){
                    console.log("Error in fetching user messages");
                }
            )            
        }

        function setReceivedUserInfo(users_info){
            Object.assign(vm.users_info, users_info.new_users);
            for (var name in users_info.received_messages){
                vm.users_info[name].messages = vm.users_info[name].messages.concat(users_info.received_messages[name]);
                vm.users_info[name].unread_message = true; 
            }
        }
    }
})();
