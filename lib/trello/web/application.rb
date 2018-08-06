require 'sinatra/base'
require 'trello/board/list'

module Trello
  module Web
    class Application < Sinatra::Base
      set :public_folder, 'public'
      set :method_override, true
      set :static, true

      get '/' do
        redirect '/lists'
      end

      get '/lists' do
        # returns all lists in order of priority
        sorted_lists = all_lists.map(&:to_h).sort_by do |list|
          list[:priority]
        end

        erb :index, locals: {lists: sorted_lists}
      end

      post '/list/new' do
        return if list_title_exists?(params[:title])
        priority =  number_of_lists + 1
        list = Trello::Board::List.new(title: params[:title], priority: priority)
        list.save!
        redirect '/lists'
      end


      post '/list/:title/cards/new' do |title|
        list = load_list_by(title: title)
        list.add_new_card(card_title: params[:card_title], description: params[:description], due_date: params[:due_date])
        list.save!
        redirect '/lists'
      end

      post '/list/:title/cards/:card_title/move' do |title, card_title|
        current_list = load_list_by(title: title)
        current_list_priority = current_list.priority
        card = current_list.delete_card(card_title: card_title)
        current_list.save!

        next_list = all_lists.select do |list|
          list.priority > current_list_priority
        end.sort_by do |list|
          list.priority
        end.first

        next_list = all_lists.select { |list| list.priority == 1 }.first if next_list == nil

        next_list.add_new_card(card_title: card[:title], description: card[:description], due_date: card[:due_date])
        next_list.save!

        redirect '/lists'
      end

      delete '/list/:title' do |title|
        $redis.del("list/#{title}")

        redirect '/lists'
      end

      delete '/list/:title/cards/:card_title' do |title, card_title|
        list = load_list_by(title: title)
        list.delete_card(card_title: card_title)
        list.save!

        redirect '/lists'
      end

      private

      def load_list_by(title:)
        Marshal.load($redis.get("list/#{title}"))
      end

      def all_lists
        $redis.keys('list/*').map do |key|
          Marshal.load($redis.get(key))
        end
      end

      def number_of_lists
        $redis.keys('list/*').length
      end

      def list_title_exists?(title)
        $redis.keys('list/*').any? { |key| key.include?(title) }
      end
    end
  end
end
