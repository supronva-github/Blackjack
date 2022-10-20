require './bank'

class Person
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
    value = 0
    @cards.each do |card|
      value += card.cost
    end
    value
  end
end
