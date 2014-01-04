require 'test_helper'

describe "Elefsis" do
  context "has a document instance to handle persistence" do
    
  end
  
  context "keeps track of current obsession" do
    it "should default to the current day as the default focus" do
      Elefsis.reset_focus
      Elefsis.current_focus.must_equal Elefsis.today
    end
  end
  
  it "knows about today" do
    day = Elefsis.today()
    day.must_be_kind_of DayLog
    day.date.must_equal Time.now.localtime.to_date
  end
end