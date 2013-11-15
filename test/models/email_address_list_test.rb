require 'test_helper'

class EmailAddressListTest < ActiveSupport::TestCase
  describe "A newly created Email Address List" do
    it "should not validate" do
      e = EmailAddressList.new
      e.wont_be :valid?, 'EmailAddress requires an address for validation'
    end
    
    it "Should be marked as active by default" do
      e = EmailAddressList.new
      e.must_be :active
    end
  end
  
  test "An Email Address List created for a person should have the same key as the person" do
    person_key = 'AABB123'
    p = Person.new key: person_key
    
  end
end
