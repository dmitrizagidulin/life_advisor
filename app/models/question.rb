require 'RippleSearch'
require 'Parentable'

class Question
  include Ripple::Document
  extend RippleSearch
  include Parentable
    
  property :name, String, :presence => true
  property :answered_at, Time
  property :description, String
  timestamps!
end
