require 'whatsapp_emulator'
namespace :whatsapp do
  desc "Testing whatsapp"
  task :test => :environment do
    whats_app = WhatsAppEmulator.new
    whats_app.authenticate_roots

  end
end