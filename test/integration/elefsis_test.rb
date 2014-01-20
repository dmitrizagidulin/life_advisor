require 'test_helper'

describe 'Elefsis' do
  it "can load and save the current focus" do
    project = Project.new
    project.key = 'WukHgNDH0FQxdmjGNGBgZHgaoJm' # LA proj
    
    # creates a CurrentFocus instance and saves it to db
    Elefsis.focus_on project
    
    # Verify that the current focus is now this project
    focus = Elefsis.current_focus
    focus.must_be_kind_of Project
    focus.key.must_equal project.key
    
    assert Elefsis.non_default_focus_exists?
  end
  
  it "should default to the current day as the default focus" do
    Elefsis.reset_focus!
    Elefsis.current_focus.must_equal Elefsis.today
    refute Elefsis.non_default_focus_exists?, "Resetting focus results in a 'default focus' state"
  end
end