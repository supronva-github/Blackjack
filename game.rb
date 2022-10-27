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
      puts 'You left the game'
    when 2
      print '.......'
    when 3
      puts 'You left the game'
      exit
    end
  end

  def start_round
    deal_two_card
    bet = players_bet
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
          puts "You took the card #{player.cards.last}"
          show_card_player
          puts 'Move passed to the dealer'
          dealer_move
          skip_round = true
        when 2
          raise ArgumentError, 'Have already skipped a turn or drawn a card' if skip_round == true

          puts 'You missed a move'
          skip_round = true
          puts 'Move passed to the dealer'
          dealer_move
        when 3
          skip_round = false
          break
        end
      rescue ArgumentError => e
        show_exception(e)
      end
    end
    winner_gets_money(bet)
    show_winner
  end

  private

  def players_bet
    if player.deposit.deposit.zero? || dealer.deposit.deposit.zero?
      raise ArgumentError,
            'One of the players has no balance'
    end

    player.bet + dealer.bet
  end

  def balance_refund(bet_amount)
    player.get_money(bet_amount / 2)
    dealer.get_money(bet_amount / 2)
  end

  def draw?
    player.sum_points == dealer.sum_points && player.sum_points <= BLACKJACK
  end

  def winner_gets_money(bet_amount)
    if player_win?
      player.get_money(bet_amount)
    elsif dealer_win?
      dealer.get_money(bet_amount)
    elsif draw?
      balance_refund(bet_amount)
    end
  end

  def show_balance_player
    puts "Your balance: #{player.deposit.deposit}"
  end

  def dealer_move
    puts "Dealer #{dealer.name} thinks"
    sleep 2
    if dealer.sum_points < 17
      deal_card_dealer
      puts "Dealer #{dealer.name} took the card"
    else
      puts "Dealer #{dealer.name} skips a turn"
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
    puts "Player #{player.name} Balance: #{player.deposit.deposit} - Win!" if player_win?
    puts "Dealer #{dealer.name} - Win!" if dealer_win?
    puts 'The dealer and the player have the same amount of money - a Draw!' if draw?
    puts "Player cards: #{player.show_cards}, Dealer cards: #{dealer.show_cards}"
    show_player_points
    show_dealer_points
    drop_cards_players
  end

  def show_cards_players
    puts "Player cards: #{player.show_cards}, Dealer cards: #{dealer.show_cards_hidden}"
    show_player_points
  end

  def show_card_player
    puts "Player cards: #{player.show_cards}"
    show_player_points
  end

  def show_player_points
    puts "You points: #{player.sum_points}"
  end

  def show_dealer_points
    puts "Dealer points: #{dealer.sum_points}"
  end

  def continue?
    puts 'Play again 1.Yes 2.No'
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
      1 - Take card
      2 - Skip a turn
      3 - Open cards
    MENU
  end

  def show_exception(exception)
    puts " #{exception.message} "
  end
end
