class DayItem
  include Comparable
  
  attr_accessor :item
  
  def initialize(item)
    @item = item
  end
  
  def done
    self.item.done
  end
  
  def history_timestamp
    self.item.day_sort_key
  end
  
  def name
    self.item.name
  end
  
  def <=>(anOther)
    self.item.day_sort_key <=> anOther.item.day_sort_key
  end
end