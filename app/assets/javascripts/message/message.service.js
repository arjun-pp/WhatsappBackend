(function ()
{
    'use strict';

    angular
        .module('message')
        .factory('MessageService', MessageService);

    /** @ngInject */
    function MessageService($http)
    {

        var get_users_messages = function ()
        {
            return $http({
              method: 'GET',
              url: '/get_users_messages'
            });
        }

        return {
            get_users_messages: get_users_messages
            // postUsersMessages: postUsersMessages
        };
    }
})();