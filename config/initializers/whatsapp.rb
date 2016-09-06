require 'whatsapp_emulator'
require 'users_messages'
@whats_app = WhatsAppEmulator.instance
sleep(2)
@whats_app.authenticate_roots
@whats_app.scroll_down_users(4000)
sleep(2)
@whats_app.scroll_up_users(0)
@whats_app.inject_script
users_messages = @whats_app.get_all_users_messages
users_messages_instance = UserService.instance
users_messages_instance.set users_messages 