class HistoryController < ApplicationController
  def index
    @start_date = 60.day.ago
    @end_date = Date.today
    @created_items_by_day, @completed_items_by_day = ActionItem.hash_by_date(ActionItem.all)
    
    @history_by_day = {}
    
    @end_date.to_date.downto(@start_date.to_date) do |day|
      day_history = DayHistory.new(day, @created_items_by_day, @completed_items_by_day)

      @history_by_day[day] = day_history
    end
  end
end