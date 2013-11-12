require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "should not validate newly created (empty) person" do
    person = Person.new
    refute person.valid?, 'Person requires a name for validation'
  end
end