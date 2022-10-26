require './deck'
require './player'
require './dealer'
require 'pry'

class Game
  DEALER_NAME = %w[Dima Roma Petr Andrey]
  BLACKJACK = 21
  MAX_CARDS = 3

  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new(DEALER_NAME.sample)
    @player = Player.new(create_player)
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
    
      # pry.binding
    when 2
      print '.......'
    when 3
      exit
    end
  end

  def start_round
    deal_two_card
    show_cards_players
    skip_round = false
    loop do
      break if max_cards_dealer? && max_cards_player?
      action_user
      action = gets.to_i
      begin
      case action
      when 1
        deal_card_player
        puts "Вы взяли карту #{player.cards.last}"
        puts 'Ход переходит диллеру'
        dealer_move
      when 2
        raise ArgumentError, 'Вы уже пропустили ход' if skip_round == true
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

 
  # def open_up?
  #   max_cards_player? && max_cards_dealer? || max_cards_player?
  # end
  
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
    puts "Player #{player.name} - Win" if player_win?
    puts "Dealer #{dealer.name} - Win" if dealer_win?
    puts "Player cards: #{player.show_cards}, Dealer cards: #{dealer.show_cards}"
    drop_cards_players
  end

  def show_cards_players
    puts "Player cards: #{player.show_cards}, Dealer cards: #{dealer.show_cards_hidden}"
  end

  def action_user
    print <<~MENU
      Enter the action number:
      1 - Взять еще карту
      2 - Пропустить ход
      3 - Всрыть карты
    MENU
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
    gets.strip
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


  def show_exception(exception)
    puts " #{exception.message} "
  end

end
