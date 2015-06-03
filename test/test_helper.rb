# -----------------------------------------------------------------------------
# TEST SETUP
# -----------------------------------------------------------------------------

# Configure Rails and load libraries
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "tolaria"
require "minitest/unit"
require "minitest/pride"

# Filter out Minitest backtrace while allowing backtrace from
# other libraries to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActiveSupport::TestCase.fixtures :all
end

# -----------------------------------------------------------------------------
# HELPER METHODS
# -----------------------------------------------------------------------------

# A method to create a dummy administrator and return it
def create_dummy_administrator!
  return Administrator.find_or_create_by!({
    name: "宮本 茂",
    organization: "Nintendo",
    email: "someone@example.com",
  })
end
