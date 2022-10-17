class Card
  attr_reader :face, :suite

  def initialize(face, suite)
    @face = face
    @suite = suite
  end
end
