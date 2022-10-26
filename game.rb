# frozen_string_literal: true

require './deck'
require './player'
require './dealer'

class Game
  DEALER_NAME = %w[Dima Roma Petr Andrey].freeze
  BLACKJACK = 21
  MAX_CARDS = 3

  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new(DEALER_NAME.sample)
    create_player
  end

  def start
    loop
    main_menu
    action = gets.to_i
    case action
    when 1
      shuffle_deck
      loop do
        start_round
        break unless continue?
      end
      puts 'Вы вышли из игры'
    when 2
      print '.......'
    when 3
      puts 'Вы вышли из игры'
      exit
    end
  end

  def start_round
    deal_two_card
    players_bet
    show_balance_player
    show_cards_players
    skip_round = false
    loop do
      break if max_cards_dealer? && max_cards_player?

      menu_action_user
      action = gets.to_i
      begin
        case action
        when 1
          deal_card_player
          puts "Вы взяли карту #{player.cards.last}"
          puts 'Ход переходит диллеру'
          dealer_move
          skip_round = true
        when 2
          raise ArgumentError, 'Вы уже пропустили ход или взяли карту' if skip_round == true

          puts 'Вы пропустили ход'
          skip_round = true
          puts 'Ход переходит диллеру'
          dealer_move
        when 3
          skip_round = false
          break
        end
      rescue ArgumentError => e
        show_exception(e)
      end
    end
    show_winner
  end

  def players_bet
    if player.deposit.deposit.zero? || dealer.deposit.deposit.zero?
      raise ArgumentError,
            'Нет баланса у одного из игроков'
    end

    player.bet + dealer.bet
  end

  def winner_gets_money
    player.get_money(players_bet) if player_win?
    dealer.get_money(players_bet) if dealer_win?
  end

  def show_balance_player
    puts "Ваш баланс: #{player.deposit.deposit}"
  end

  def dealer_move
    puts "Dealer #{dealer.name} думает"
    sleep 2
    if dealer.sum_points < 17
      deal_card_dealer
      puts "Dealer #{dealer.name} взял карту"
    else
      puts "Dealer #{dealer.name} пропускает ход"
    end
  end

  def max_cards_player?
    player.cards.count == MAX_CARDS
  end

  def max_cards_dealer?
    dealer.cards.count == MAX_CARDS
  end

  def player_win?
    player.sum_points == BLACKJACK || dealer.sum_points < player.sum_points && player.sum_points < BLACKJACK || dealer.sum_points > BLACKJACK
  end

  def dealer_win?
    dealer.sum_points == BLACKJACK || dealer.sum_points > player.sum_points && dealer.sum_points < BLACKJACK || player.sum_points > BLACKJACK
  end

  def show_winner
    winner_gets_money
    puts "Player #{player.name} - Win" if player_win?
    puts "Dealer #{dealer.name} - Win" if dealer_win?
    puts "Player cards: #{player.show_cards}, Dealer cards: #{dealer.show_cards}"
    show_player_points
    show_dealer_points
    drop_cards_players
  end

  def show_cards_players
    puts "Player cards: #{player.show_cards}, Dealer cards: #{dealer.show_cards_hidden}"
    show_player_points
  end

  def show_player_points
    puts "Ваши очки: #{player.sum_points}"
  end

  def show_dealer_points
    puts "Очки Диллера: #{dealer.sum_points}"
  end

  def continue?
    puts 'Сыграть еще раз? 1.Да 2. Нет'
    gets.chomp.to_i == 1
  end

  def deal_two_card
    2.times { deal_card_dealer }
    2.times { deal_card_player }
  end

  def create_player
    print 'What is your name: '
    name =  gets.strip
    @player = Player.new(name)
  rescue ArgumentError => e
    show_exception(e)
    retry
  end

  def drop_cards_players
    dealer.drop_card
    player.drop_card
  end

  def deal_card_player
    dealer.deal_card!(deck, player)
  end

  def deal_card_dealer
    dealer.deal_card!(deck)
  end

  def shuffle_deck
    dealer.shuffle!(deck)
  end

  def main_menu
    print <<~MENU
      Enter the action number:
      1 - Start the game
      2 - View BlackJack game rules
      3 - Exit the game
    MENU
  end

  def menu_action_user
    print <<~MENU
      Enter the action number:
      1 - Взять еще карту
      2 - Пропустить ход
      3 - Всрыть карты
    MENU
  end

  def show_exception(exception)
    puts " #{exception.message} "
  end
end
