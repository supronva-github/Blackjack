module DealerRights
  MAX_CARDS = 3

  def shuffle!(deck)
    deck.cards.shuffle!
  end

  def deal_card!(deck, who = self)
    raise ArgumentError, 'Deck is empty' if deck.cards.empty?
    raise ArgumentError, "У вас #{who.name} уже 3 карты" if who.cards.count == MAX_CARDS

    who.cards << deck.cards.shift
  end

  def show_cards_hidden
    "#{'*' * cards.count}"
  end
end
