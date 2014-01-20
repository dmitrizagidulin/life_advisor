ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest-spec-context'

# Setup in-memory test server for Riak


#require 'ripple/test_server'



class ActiveSupport::TestCase

#  setup { Ripple::TestServer.setup }


#  teardown { Ripple::TestServer.clear }
end

def test_project
  project = Project.new name: 'Project for Unit Testing'
  project.key = '_test-project'
  project.persist!
  project
end

# :before_suite
project = test_project
project.save!
# clear all project links
project.destroy_links!
