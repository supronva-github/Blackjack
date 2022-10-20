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

  def start_game
    print <<~MENU
      Enter the action number:
      1 - Start the game
      2 - View BlackJack game rules
      3 - Exit the game
    MENU
    action = gets.to_i
    case action
    when 1
      shuffle_deck
      2.times { deal_card_dealer }
      2.times { deal_card_player }
      pry.binding
    when 2
      print '.......'
    when 3
      exit
    end
  end

  private 

  def create_player
    player_name = input_player_name
  end

  def deal_card_player
    @dealer.deal_card!(@deck, @player)
  end

  def deal_card_dealer
    @dealer.deal_card!(@deck)
  end

  def shuffle_deck
    @dealer.shuffle!(@deck)
  end


  def input_player_name
    print 'What is your name: '
    gets.strip
  end
end
