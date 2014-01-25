require 'test_helper'

class CurrentFocusControllerTest < ActionController::TestCase
  it "should set focus" do
    Elefsis.reset_focus!
    
    project = test_project()
    
    post :edit, { :focus_type => 'Project', :focus_key => project.key }
    assert_not_nil assigns(:new_focus)
    
    assert_redirected_to project
    
    # Make sure that the new focus has been set
    Elefsis.current_focus.key.must_equal project.key
  end

end
