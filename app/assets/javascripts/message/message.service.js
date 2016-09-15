(function ()
{
    'use strict';

    angular
        .module('message')
        .factory('MessageService', MessageService);

    /** @ngInject */
    function MessageService($http)
    {

        var get_users_info = function ()
        {
            return $http({
              method: 'GET',
              url: '/get_users_info'
            });
        }

        var getGenericMessages = function()
        {
            return $http({
              method: 'GET',
              url: '/get_generic_messages'
            });
        }

        var send = function(users_messages)
        {
            return $http({
              method: 'POST',
              url: '/send',
              data: users_messages
            });
        }        

        var getNewMessages = function(){
            return $http({
              method: 'GET',
              url: '/get_new_messages'
            });
        }

        return {
            get_users_info: get_users_info,
            getGenericMessages: getGenericMessages,
            send: send,
            getNewMessages: getNewMessages
            // postUsersMessages: postUsersMessages
        };
    }
})();