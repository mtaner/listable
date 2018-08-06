module Trello
  module Board
    class Card
      attr_reader :title, :description, :due_date

      def initialize(title:, description:, due_date:)
        @title = title
        @description = description
        @due_date = due_date
      end

      def to_h
        {
          title: title,
          description: description,
          due_date: due_date
        }
      end
    end
  end
end
