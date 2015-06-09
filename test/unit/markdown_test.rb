require "test_helper"

class MarkdownTest < ActiveSupport::TestCase

  test "generate a paragraph" do
    assert_equal(
      "<p>Ach! Hans, run! It's the Pascagoyf!</p>",
      Tolaria.render_markdown("Ach! Hans, run! It's the Pascagoyf!")
    )
  end

end
