require 'whatsapp_emulator'
@whats_app = WhatsAppEmulator.instance
sleep(2)
@whats_app.authenticate_roots
@whats_app.scroll_down_users(4000)
sleep(2)
@whats_app.scroll_up_users(0)
@whats_app.inject_script