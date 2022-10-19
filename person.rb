class Person
  attr_accessor :money
  attr_reader :name, :cards

  def initialize(name, money)
    @name = name
    @money = money
    @cards = []
  end

  def drop_card
    cards.clear
  end

  def show_cards
    cards.join(',')
  end
end
