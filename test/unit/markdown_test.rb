require "test_helper"

class MarkdownTest < ActiveSupport::TestCase

  test "generate a paragraph" do
    assert_equal(
      "<p>Ach! Hans, run! Its the Pascagoyf!</p>".squish,
      Tolaria.render_markdown("Ach! Hans, run! Its the Pascagoyf!").squish
    )
  end

end
