class DayLog
  include Ripple::Document
  
  property :date, Date, presence: true
  timestamps!
  
  def ==(other)
    if other.kind_of? Time
      return other.to_date == self.date
    end
    self.date == other.date
  end
  
  def key
    self.date.strftime("%Y-%m-%d")
  end
  
  def self.today
    day = DayLog.new date: Time.now.localtime.to_date
  end
end

