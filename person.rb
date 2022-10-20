require './bank'

class Person
  BLACKJACK = 21

  attr_reader :name, :cards, :deposit

  def initialize(name)
    @name = name
    @cards = []
    @deposit = Bank.new
  end

  def bet
    @deposit.bet!
  end

  def get_money(amount)
    @deposit.add!(amount)
  end

  def drop_card
    cards.clear
  end

  def show_cards
    cards.join(',')
  end

  def show_sum_points
    value = []
    aces_count = 0
    @cards.each do |card|
      value << card.cost
      aces_count += 1 if card.face == 'A'
    end
    value.sum if value.sum == BLACKJACK
    value.sum - 20 if aces_count = 3
    value.sum - 10 if aces_count = 2
    value.sum
  end
end
