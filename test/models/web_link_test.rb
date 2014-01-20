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
end