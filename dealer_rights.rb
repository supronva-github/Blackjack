module DealerRights
  def shuffle!(deck)
    deck.cards.shuffle
  end

  def deal_card!(deck, who = self)
    raise ArgumentError, 'Deck is empty' if deck.cards.empty?

    who.cards << deck.cards.shift
  end

  def show_cards_hidden
    "Dealer cards: #{'*' * cards.count}"
  end
end
