require 'RippleSearch'
require 'Parentable'

class Goal
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :name, String
  property :description, String
  timestamps!
end
