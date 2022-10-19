class Bank
  attr_reader :money

  def initialize
    @money = 0
  end

  def bet(bet_amount, *players)
    players.each do |player|
      if player.money.zero?
        raise ArgumentError,
              "Betting is not possible - the player #{player.name} has run out of money"
      end

      player.money -= bet_amount
      self.money += bet_amount
    end
  end

  def give_money(player)
    player.money += self.money
    self.money = 0
  end

  private

  attr_writer :money
end
