require 'RippleSearch'
require 'Parentable'

class Question
  include Ripple::Document
  extend RippleSearch
  include Parentable
    
  property :name, String, :presence => true
  property :answered, Boolean, default: false
  property :answered_at, Time
  property :description, String
  property :bump_count, Integer, default: 0  # Question's relative priority / number of times I've thought about it
  timestamps!
  
  def <=>(anOther)
    # Sort on Bump Count first, descending
    bump_cmp = anOther.bump_count <=> self.bump_count
    return bump_cmp unless bump_cmp == 0
    
    # Lastly, sort on Created At time, asc
    self.created_at <=> anOther.created_at
  end
  
  def answers
    Answer.for_parent(:question, self.key)
  end
  
  def bump
    self.bump_count += 1
  end
  
  def bump!
    self.bump
    self.save
  end
  
  def links
    WebLink.for_parent(:question, self.key)
  end
end
