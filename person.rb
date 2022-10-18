class Person
  attr_reader :name, :money, :cards

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
