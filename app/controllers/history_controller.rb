class HistoryController < ApplicationController
  def index
    @start_date = 60.day.ago
    @end_date = Date.today
    @created_items, @completed_items = ActionItem.hash_by_date(ActionItem.all)
  end
end