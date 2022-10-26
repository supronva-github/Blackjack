# frozen_string_literal: true

require './bank'

class Person
  FORMAT_PERSON_NAME = /[a-z]+/i.freeze
  BLACKJACK = 21

  attr_reader :name, :cards, :deposit

  def initialize(name)
    @name = name
    @cards = []
    @deposit = Bank.new
    validate!
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

  def sum_points
    value = 0
    aces_count = 0
    @cards.each do |card|
      value += card.cost
      aces_count += 1 if card.ace?
    end
    value -= 10 if aces_count == 1 && value > BLACKJACK
    value -= 10 if aces_count == 2
    value -= 20 if aces_count == 3
    value
  end

  def validate!
    raise ArgumentError, "Name #{name} player is not valid" if name !~ FORMAT_PERSON_NAME
  end
end
