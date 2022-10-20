class Bank
  BET_AMOUNT = 10
  DEPOSIT = 100

  attr_reader :deposit

  def initialize
    @deposit = DEPOSIT
  end

  def bet!
    @deposit -= BET_AMOUNT
    BET_AMOUNT
  end

  def add!(amount)
    @deposit += amount
  end

  # def bet(bet_amount, *players)
  #   players.each do |player|
  #     if player.money.zero?
  #       raise ArgumentError,
  #             "Betting is not possible - the player #{player.name} has run out of money"
  #     end

  #     player.money -= bet_amount
  #     self.money += bet_amount
  #   end
  # end

  # def give_money(player)
  #   player.money += self.money
  #   self.money = 0
  # end

  # private

  # attr_writer :money
end

# так у тебя должен в инициализаторе игрока сразу инициализироваться класс Bank
#  с методами ставки и зачесления на счет, а у игрока уже будут методы проксирующие запросы
#  к банку что он добавил бабос(выграл) или снял бобос(ставку сделал)
