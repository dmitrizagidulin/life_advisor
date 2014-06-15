require 'test_helper'

describe "a WebLink" do
  it "has a name, url and description" do
    link = WebLink.new name: 'Test link', url: 'www.test.com'
    link.description = 'Test description for web link'
    link.name.wont_be_empty
    link.url.wont_be_empty
    link.description.wont_be_empty
  end
  
  it "name is optional - uses url as name if missing" do
    test_url = 'http://www.test.com'
    link = WebLink.new url: test_url
    link.name_display.must_equal test_url
  end
  
  it "can be created from an ActionItem" do
    test_name = 'Test Item'
    test_url = 'http://www.test.com'
    item = ActionItem.new name: test_name
    item.links = [item.new_link(test_url)]
    item.parent_type = :project
    item.parent_key = '1234'
    
    link = WebLink.from_action_item item
    link.name.must_equal test_name
    link.url.must_equal test_url
    link.parent_type.to_s.must_equal 'project'
    link.parent_key.must_equal '1234'
  end
  
  it "can be converted to an ActionItem" do
    test_name = 'Test Item'
    test_url = 'http://www.test.com'
    link = WebLink.new name: test_name, url: test_url
    link.parent_type = :project
    link.parent_key = '1234'
    
    item = ActionItem.from_web_link link
    item.name.must_equal test_name
    item.links.first.name.must_be_empty
    item.links.first.url.must_equal test_url
    item.parent_type.to_s.must_equal 'project'
    item.parent_key.must_equal '1234'
  end
end