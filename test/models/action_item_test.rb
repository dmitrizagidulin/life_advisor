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
  
  test "New action item should have a Bump count of 0" do
    action_item = ActionItem.new
    action_item.bump_count.must_equal 0
  end
  
  test "Bumping a new action item should result in a bump count of 1" do
    action_item = ActionItem.new
    action_item.bump
    action_item.bump_count.must_equal 1
  end
  
  test "Action item areas should be ordered" do
    a = ActionItem.new area: :work
    a.area_order.must_equal 0
    
    a = ActionItem.new area: :soul
    a.area_order.must_equal 1

    a = ActionItem.new area: :admin
    a.area_order.must_equal 2
  end
  
  test "Action items should be sorted first by bump count, descending" do
    a0 = ActionItem.new key: '0 bumps'
    
    a1 = ActionItem.new key: '1 bumps'
    a1.bump
    
    a2 = ActionItem.new key: '2 bumps'
    2.times { a2.bump }
    
    items_list = []
    items_list << a1
    items_list << a0
    items_list << a2
    
    items_list.sort!
    items_list[0].key.must_equal '2 bumps'
  end
  
  test "Action items should be sorted by Area priority (work > soul > admin > assistant)" do
    a0 = ActionItem.new key: 'task_work'
    a0.area = :work
    
    a1 = ActionItem.new key: 'task_admin'
    a1.area = :admin
    
    a2 = ActionItem.new key: 'task_soul'
    a2.area = :soul
    
    items_list = []
    items_list << a1
    items_list << a0
    items_list << a2
    
    items_list.sort!
    items_list[0].key.must_equal 'task_work', "Sort order 1: task_work"
    items_list[1].key.must_equal 'task_soul', "Sort order 2: task_soul"
    items_list[2].key.must_equal 'task_admin', "Sort order 3: task_admin"
  end

end
