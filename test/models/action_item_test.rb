require 'test_helper'

class ActionItemTest < ActiveSupport::TestCase
#  let(:action_item) { ActionItem.new name: 'Take out the trash' }
  
  describe "when a new item is created" do
    it "must not validate" do
      action_item = ActionItem.new
      action_item.wont_be :valid?
    end
    
    it "must not be done" do
      action_item = ActionItem.new
      action_item.wont_be :done
    end
  end
  
end
