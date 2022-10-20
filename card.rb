class Card
  attr_reader :face, :suite

  def initialize(face, suite)
    @face = face
    @suite = suite
  end

  def cost
    return 10 if %w[J Q K].include?(face)
    return 11 if ace?

    face.to_i
  end

  def ace?
    face == 'A'
  end
end
