require './person'
require './diller_rights'

class Diller < Person
  include DillerRights
end
