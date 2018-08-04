require 'rack/parser'
require 'sinatra/extension'
require 'trello/board/list'

module Trello
  module Web
    module List
      extend Sinatra::Extension

      use Rack::Parser, parsers: { 'application/json' => proc { |data| JSON.parse(data) } }

      get '/' do
        content_type 'application/json'
        Trello::Board::List.json_for(title: 'something').to_json
      end

      post '/new' do
        # Trello::List.new(title: params[:title])
      end
    end
  end
end
