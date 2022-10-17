require './card'

class Deck
  attr_reader :cards

  SUITE = %w[♠ ♥ ♦ ♣].freeze
  FACE = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize
    @cards = []
    create_deck
  end

  def create_deck
    SUITE.each do |suite|
      FACE.each do |face|
        @cards << Card.new(face, suite)
      end
    end
  end
end
