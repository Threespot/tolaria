require "test_helper"

class CongfigurationTest < ActiveSupport::TestCase

  test "can't assign unknown config" do
    assert_raises NoMethodError do
      Tolaria.configure do |config|
        config.bullshit = "ಠ_ಠ"
      end
    end
  end

  test "can't pass a block to Tolaria.config" do
    assert_raises ArgumentError do
      Tolaria.config do |config|
        config.bullshit = "ಠ_ಠ"
      end
    end
  end

end
