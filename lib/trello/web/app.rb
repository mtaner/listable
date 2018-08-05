require 'sinatra/base'
require 'rack/parser'
require 'trello/board/list'

module Trello
  module Web
    class Application < Sinatra::Base
      set :method_override, true
      use Rack::Parser, parsers: { 'application/json' => proc { |data| JSON.parse(data) } }

      get '/' do
        redirect '/lists'
      end

      get '/lists' do
        # returns all lists in order of priority
        content_type 'application/json'
        $redis.keys('list/*').map do |key|
          list = Marshal.load($redis.get(key)).to_h
          priority = list.delete(:priority)
          [priority, list]
        end.to_h.to_json
      end

      post '/list/new/:title' do |title|
        return if $redis.keys('list/*').any? { |key| key.include?(title) }
        priority = $redis.keys('list/*').length + 1
        list = Trello::Board::List.new(title: title, priority: priority)
        list.save!
      end

      post '/list/:title/cards/:card_title/move_to/:new_list_title' do |title, card_title, new_list_title|
        list = load_list_by(title: title)
        card = list.delete_card(card_title: card_title)
        list.save!
        next_list = load_list_by(title: new_list_title)
        next_list.add_new_card(card_title: card[:title], description: card[:description], due_date: card[:due_date])
        next_list.save!
      end

      post '/list/:title/cards/new/:card_title' do |title, card_title|
        list = load_list_by(title: title)
        list.add_new_card(card_title: card_title, description: 'xyz', due_date: 'Monday')
        list.save!
      end

      delete '/list/:title' do |title|
        $redis.del("list/#{title}")
      end

      delete '/list/:title/cards/:card_title' do |title, card_title|
        list = load_list_by(title: title)
        list.delete_card(card_title: card_title)
        list.save!
      end

      def load_list_by(title:)
        Marshal.load($redis.get("list/#{title}"))
      end
    end
  end
end

# Lists and Cards.
# A list has a required name and a collection of cards.
# A card has a required title, required description and an optional due date.
