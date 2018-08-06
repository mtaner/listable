require 'trello/board/list'

RSpec.describe Trello::Board::List do
  let(:list_title)       { 'List_1' }
  let(:list_priority)    { 1 }
  let(:subject)          { described_class.new(title: list_title, priority: list_priority) }
  let(:card_title)       { 'Card_1' }
  let(:card_description) { 'Card description' }
  let(:card_due_date)    { '2018-08-09' }

  describe '#to_h' do
    it 'returns the attributes title, priority and cards as hash' do
      expect(subject.to_h).to eq({
        title: list_title,
        priority: list_priority,
        cards: []
      })
    end
  end

  describe '#add_new_card' do
    it 'adds a new card to the list' do
      expect{
        subject.add_new_card(
          card_title: card_title,
          description: card_description,
          due_date: card_due_date
        )
      }.to change{ subject.to_h }.from({
        title: list_title,
        priority: list_priority,
        cards: []
      }).to({
        title: list_title,
        priority: list_priority,
        cards: [[
          card_title, {
            title: card_title,
            description: card_description,
            due_date: card_due_date
          }
        ]]
      })
    end
  end

  describe '#delete_card' do
    it 'deletes a selected card' do
      subject.add_new_card(
        card_title: card_title,
        description: card_description,
        due_date: card_due_date
      )

      expect{
        subject.delete_card(card_title: card_title)
      }.to change { subject.to_h }.from({
        title: list_title,
        priority: list_priority,
        cards: [[
          card_title, {
            title: card_title,
            description: card_description,
            due_date: card_due_date
          }
        ]]
      }).to({
        title: list_title,
        priority: list_priority,
        cards: []
      })
    end
  end
end
