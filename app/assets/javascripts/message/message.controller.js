(
    function (){
        'use strict';

        angular.module('message')
                .controller('MessageController', MessageController);

    /** @ngInject */
    function MessageController($scope, MessageService){
        var vm = this;
        var users_messages;
        get_users_messages();
        var current_user;
        function get_users_messages(){
            var promise = MessageService.get_users_messages();
            promise.then(
                function(users_messages){
                    vm.users_messages = users_messages;
                },
                function(error){
                    console.log("Error in fetching user messages")
                }
            )

        }
    }
})();
