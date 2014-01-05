require 'test_helper'

describe "a Current Focus" do
  it "can be created on a project" do
    test_project = Project.new name: 'Test Project'
    test_project.key = '123'
    focus = CurrentFocus.on test_project
    focus.key.must_equal Elefsis::DEFAULT_FOCUS_KEY
    focus.focus_type.must_equal 'Project'
    focus.focus_key.must_equal test_project.key
  end
end