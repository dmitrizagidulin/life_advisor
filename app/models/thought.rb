require 'RippleSearch'
require 'Parentable'

class Thought
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :name, String, :presence => true
  timestamps!
  before_create :enforce_default_day_parent
  before_update :enforce_default_day_parent
end
