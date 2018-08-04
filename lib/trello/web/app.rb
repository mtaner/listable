require 'sinatra/base'
require 'sinatra/namespace'
require 'trello/web/list'

module Trello
  module Web
    class Application < Sinatra::Base

      register Sinatra::Namespace

      get '/' do
        'Hello world!'
      end

      namespace '/list' do
        register Trello::Web::List
      end
    end
  end
end

# Lists and Cards.
# A list has a required name and a collection of cards.
# A card has a required title, required description and an optional due date.
