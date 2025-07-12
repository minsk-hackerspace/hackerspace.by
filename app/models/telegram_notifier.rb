# frozen_string_literal: true

require 'telegram/bot'

class TelegramNotifier
  def initialize
    raise 'No token for telegram bot in the settings' if Setting['tgToken'].nil?
    raise 'No chat IDs for telegram bot set' if Setting['tgChatIds'].nil?

    @bot = Telegram::Bot::Client.new(Setting['tgToken'], logger: Rails.logger)
    @chats = Setting['tgChatIds'].split.map(&:to_i)
  end

  def send_message_to(chat_id, message)
    @bot.api.send_message(chat_id: chat_id, text: message, parse_mode: 'HTML')
  end

  def send_message_to_all(message)
    @chats.each do |chat|
      send_message_to(chat, message)
    end
  end
end
