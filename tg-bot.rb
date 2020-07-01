# frozen_string_literal: true

require 'telegram_bot'
require 'json'
require 'dotenv'
require 'faraday'

Dotenv.load('.bot_key.env')
url = 'https://programming-quotes-api.herokuapp.com/quotes/random'

response = Faraday.get(url)
data_hash = JSON.parse(response.body)
quote = data_hash['en']
author = data_hash['author']


bot = TelegramBot.new(token: ENV['BOT_KEY'])
bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    reply.text = case command
                when /start/i
                "This bot will give you random quotes from famous programmers and computer scientists"
                
                 when /quotes/i
                   "#{quote} from #{author}!"
                 else
                   "#{message.from.first_name}, have no idea what #{command.inspect} means."
                 end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
