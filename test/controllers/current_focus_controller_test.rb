require 'test_helper'

class CurrentFocusControllerTest < ActionController::TestCase
  it "should be able to accept bookmarks (projects)" do
    # Set up a project, ensure no links
    project = test_project()
    project.save!
    project.destroy_links!
    
    # Set the project as the Current Focus
    project.current_focus!
    
    project.links.must_be_empty
    
    post :add_bookmark, { :format => :json, :name => 'Test Bookmark', :url => 'http://www.test.com' }
    assert_not_nil assigns(:current_focus)
    assert_not_nil assigns(:web_link)
    assert_response :success
    project.links.wont_be_empty "Current focus project links should not be empty after add_bookmark API call"
    
    # Tear down
    project.destroy_links!
  end
end
