class Card
  attr_reader :face, :suite

  def initialize(face, suite)
    @face = face
    @suite = suite
  end

  def cost
    return 10 if %w[J Q K].include?(face)
    return [1, 11] if face == 'A'

    face.to_i
  end
end
