require 'RippleSearch'
require 'Parentable'

class EmailAddressList
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :address, String, presence: true
  property :active, Boolean, default: true
  timestamps!
end
