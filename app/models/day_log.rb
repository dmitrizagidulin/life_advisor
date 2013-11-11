class DayLog
  include Ripple::Document
  
  property :date, Date, presence: true
  timestamps!
  
  def key
    date.strftime("%Y-%m-%d")
  end
  
  def self.today
    day = DayLog.new date: Time.now.localtime.to_date
  end
end

