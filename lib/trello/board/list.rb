require_relative 'card'

module Trello
  module Board
    class List
      attr_reader :title, :priority

      def initialize(title:, priority:)
        @title = title
        @priority = priority
        @cards = {}
      end

      def update_title(new_title:)
        @title = new_title
      end

      def add_new_card(card_title:, description:, due_date:)
        card = Card.new(title: card_title, description: description, due_date: due_date)
        @cards[card_title] = card.to_h
      end

      def delete_card(card_title:)
        @cards.delete(card_title)
      end

      def cards_in_priority
        @cards.sort_by { |name, info| info[:due_date] }
      end

      def to_h
        {
          title: title,
          priority: priority,
          cards: cards_in_priority
        }
      end

      def save!
        $redis.set("list/#{title}", Marshal.dump(self))
      end
    end
  end
end
