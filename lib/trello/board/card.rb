module Trello
  module Board
    class Card
      attr_reader :title, :description, :due_date, :priority

      def initialize(title:, description:, due_date:, priority:)
        @title = title
        @description = description
        @due_date = due_date
        @priority = priority
      end

      def to_h
        {
          title: title,
          description: description,
          due_date: due_date,
          priority: priority
        }
      end
    end
  end
end
