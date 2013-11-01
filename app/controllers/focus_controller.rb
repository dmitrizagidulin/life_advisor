class FocusController < ApplicationController
  def focus_area
    @focus_area = params[:area]
    @active_projects = Project.focus_on_area(@focus_area, :active)
    @someday_projects = Project.focus_on_area(@focus_area, :someday)
    @critical_items = ActionItem.all_todo(:critical)
    @opportunity_items = ActionItem.all_todo(:opportunity, @focus_area)
    @horizon_items = ActionItem.all_todo(:horizon, @focus_area)
    @someday_items = ActionItem.all_todo(:someday, @focus_area, include_projects=false)
    @tomorrow_items = ActionItem.all_todo(:tomorrow, @focus_area)

    respond_to do |format|
      format.html # work.html.erb
    end
  end
end