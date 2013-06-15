class DayHistory
  attr_accessor :created_items, :completed_items,
    :created_not_completed,
    :num_created_items, :num_completed_same_day,
    :num_completed_items


  def initialize(day, created_items_by_day, completed_items_by_day)
    @day = day

    # Determine if any action items were created during the day
    if created_items_by_day.include? day
      @created_items = created_items_by_day[day]
      @num_created_items = @created_items.count
    else
      @created_items = []
      @num_created_items = 0
    end
    # Determine how many of the items created were completed that same day
    @created_not_completed = []
    @created_items.each do |item|
      unless item.completed_same_day?
        @created_not_completed.append(item)
      end
    end
    @num_completed_same_day = @num_created_items - @created_not_completed.count
    
    if completed_items_by_day.include? day
      @completed_items = completed_items_by_day[day]
    else
      @completed_items = []
    end
    @num_completed_items = @completed_items.count
  end
  
  def has_activity?
    self.created_items.present? or self.completed_items.present?
  end
  
  def items
    items = self.completed_items + self.created_not_completed
    items = items.collect { |i| DayItem.new(i) }
    items.sort!
  end
end