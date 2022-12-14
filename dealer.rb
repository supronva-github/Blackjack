# frozen_string_literal: true

require './person'
require './dealer_rights'

class Dealer < Person
  include DealerRights
end
