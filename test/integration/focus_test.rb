require 'test_helper'

describe "global focus" do
  it "a project can be set as a focus" do
    test_project = Project.new name: 'Sample Project'
    test_project.set_main_focus!
    Elefsis.current_focus.must_equal test_project
  end
end