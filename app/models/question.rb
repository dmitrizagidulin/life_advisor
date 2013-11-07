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
  
  def answers
    Answer.for_parent(:question, self.key)
  end
  
  def links
    WebLink.for_parent(:question, self.key)
  end
end
