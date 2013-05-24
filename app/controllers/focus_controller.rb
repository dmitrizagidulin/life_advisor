class FocusController < ApplicationController
  def work
    focus_area = :work
    @projects = Project.focus_on_area(focus_area)
    @critical_items = ActionItem.all_todo(:critical, focus_area)
    @opportunity_items = ActionItem.all_todo(:opportunity, focus_area)
    @horizon_items = ActionItem.all_todo(:horizon, focus_area)
    @someday_items = ActionItem.all_todo(:someday, focus_area, include_projects=false)
    @tomorrow_items = ActionItem.all_todo(:tomorrow, focus_area)

    respond_to do |format|
      format.html # work.html.erb
    end
    
  end
end