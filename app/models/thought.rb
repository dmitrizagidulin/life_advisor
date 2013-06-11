require 'RippleSearch'
require 'Parentable'

class Thought
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :name, String, :presence => true
  timestamps!
  
end
