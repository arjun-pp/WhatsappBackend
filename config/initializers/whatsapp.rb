require 'whatsapp_emulator'
require 'api/v0/users_messages'
@whats_app = WhatsAppEmulator.instance
sleep(2)
@whats_app.authenticate_roots
# @whats_app.scroll_down_users(4000)
sleep(2)
# @whats_app.scroll_up_users(0)
@whats_app.inject_script
# users_messages = @whats_app.get_all_users_messages
users_messages = Constants::DATA::USERS_MESSAGES
users_messages_instance = Api::V0::UsersMessages.instance
users_messages_instance.set users_messages 