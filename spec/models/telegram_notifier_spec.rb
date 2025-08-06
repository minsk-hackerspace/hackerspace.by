# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramNotifier, type: :model do
  describe '#initialize' do
    context 'when token and chat IDs are present' do
      before do
        allow(Setting).to receive(:[]).with('tgToken').and_return('fake_token')
        allow(Setting).to receive(:[]).with('tgChatIds').and_return('12345 67890')
      end

      it 'initializes without errors' do
        expect { described_class.new }.not_to raise_error
      end

      it 'initializes the bot with the correct token' do
        expect(Telegram::Bot::Client).to receive(:new).with('fake_token', logger: Rails.logger)
        described_class.new
      end

      it 'assigns chat IDs correctly' do
        notifier = described_class.new
        expect(notifier.instance_variable_get(:@chats)).to eq([12345, 67890])
      end
    end

    context 'when token is missing' do
      before do
        allow(Setting).to receive(:[]).with('tgToken').and_return(nil)
        allow(Setting).to receive(:[]).with('tgChatIds').and_return('12345')
      end

      it 'raises an error' do
        expect { described_class.new }.to raise_error('No token for telegram bot in the settings')
      end
    end

    context 'when chat IDs are missing' do
      before do
        allow(Setting).to receive(:[]).with('tgToken').and_return('fake_token')
        allow(Setting).to receive(:[]).with('tgChatIds').and_return(nil)
      end

      it 'raises an error' do
        expect { described_class.new }.to raise_error('No chat IDs for telegram bot set')
      end
    end
  end

  describe '#send_message_to_all' do
    let(:bot_client) { Telegram::Bot::Client.new('tgToken', logger: Rails.logger) }
    let(:bot_api) { bot_client.api }

    before do
      allow(Setting).to receive(:[]).with('tgToken').and_return('fake_token')
      allow(Setting).to receive(:[]).with('tgChatIds').and_return('12345 67890')
      allow(Telegram::Bot::Client).to receive(:new).and_return(bot_client)
    end

    it 'sends a message to all chat IDs' do
      notifier = described_class.new
      message = 'Hello everyone!'
      expect(bot_api).to receive(:send_message).with(chat_id: 12345, text: message, parse_mode: 'HTML')
      expect(bot_api).to receive(:send_message).with(chat_id: 67890, text: message, parse_mode: 'HTML')
      notifier.send_message_to_all(message)
    end
  end

  describe '#send_message_to' do
    let(:bot_client) { Telegram::Bot::Client.new('tgToken', logger: Rails.logger) }
    let(:bot_api) { bot_client.api }

    before do
      allow(Setting).to receive(:[]).with('tgToken').and_return('fake_token')
      allow(Setting).to receive(:[]).with('tgChatIds').and_return('12345')
      allow(Telegram::Bot::Client).to receive(:new).and_return(bot_client)
    end

    it 'sends a message to the specified chat ID' do
      notifier = described_class.new
      message = 'Hello single user!'
      chat_id = 12345
      expect(bot_api).to receive(:send_message).with(chat_id: chat_id, text: message, parse_mode: 'HTML')
      notifier.send_message_to(chat_id, message)
    end
  end
end
