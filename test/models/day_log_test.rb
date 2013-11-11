require 'test_helper'

class DayLogTest < ActiveSupport::TestCase
  it "should not validate a new DayLog (without date)" do
    day = DayLog.new
    day.wont_be :valid?, "A day without a date set should not be valid"
  end
  
  it "can be created via today factory method" do
    day = DayLog.today
    date_now = Time.now.localtime.to_date
    day.date.must_equal date_now
    day.key.must_equal date_now.strftime("%Y-%m-%d"), "Day should have a key based on its date"
  end
  
#  it "should not have any DayStats initially" do
#    day = DayLog.new
##    day.daystats.must_be_empty
#  end
end