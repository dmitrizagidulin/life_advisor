require 'test_helper'

describe "Elefsis" do
  it "knows about today" do
    day = Elefsis.today()
    day.must_be_kind_of DayLog
    day.date.must_equal Time.now.localtime.to_date
    day.key.must_equal Time.now.localtime.to_date.strftime("%Y-%m-%d")
  end
end