# frozen_string_literal: true

require 'telegram_bot'
require 'json'
require 'dotenv'
require 'faraday'

Dotenv.load('.bot_key.env')
url = 'https://programming-quotes-api.herokuapp.com/quotes'

bot = TelegramBot.new(token: ENV['BOT_KEY'])

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    reply.text = case command
                 when /start/i
                   'This bot will give you random quotes from famous programmers and computer scientists'
                 when /quotes/i
                   url = 'https://programming-quotes-api.herokuapp.com/quotes'
                   response = Faraday.get(url)
                   data_hash = JSON.parse(response.body)
                   random_quotes = data_hash.sample
                   quote = random_quotes['en']
                   author = random_quotes['author']
                   "#{quote} from #{author}!"
                 else
                   "#{message.from.first_name}, have no idea what #{command.inspect} means."
        end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
