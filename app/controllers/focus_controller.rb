class FocusController < ApplicationController
  def work
    @projects = Project.focus_on_area(:work)
    
    respond_to do |format|
      format.html # work.html.erb
    end
    
  end
end