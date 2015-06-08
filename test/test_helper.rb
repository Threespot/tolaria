# -----------------------------------------------------------------------------
# TEST SETUP
# -----------------------------------------------------------------------------

# Configure Rails and load libraries
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../test/demo/config/environment.rb",  __FILE__)
require "rails/test_help"
require "tolaria"
require "capybara/rails"
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

class ActionDispatch::IntegrationTest

  # Include the Rails route helpers
  include Rails.application.routes.url_helpers

  # Include support for the Capybara DSL
  include Capybara::DSL
  Capybara.javascript_driver = :webkit

  # A method to create a dummy administrator and return it
  def create_dummy_administrator!
    return Administrator.find_or_create_by!({
      name: "宮本 茂",
      organization: "Nintendo",
      email: "someone@example.com",
    })
  end

  def sign_in_dummy_administrator!
    @administrator = create_dummy_administrator!
    passcode = @administrator.set_passcode!
    visit "/admin/signin"
    fill_in "session-form-email", with: @administrator.email
    find("#session-form-passcode", visible:false).set(passcode)
    click_button "session-form-submit"
  end

end
