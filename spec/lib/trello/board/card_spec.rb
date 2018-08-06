require 'trello/board/card'

RSpec.describe Trello::Board::Card do
  describe "#to_h" do
    it "returns card attributes - title,description,due_date as hash" do
      card = described_class.new(title: 'test', description: 'description', due_date: '2018-08-09')
      expect(card.to_h).to eq({
        title: 'test',
        description: 'description',
        due_date: '2018-08-09'
      })
    end
  end
end
