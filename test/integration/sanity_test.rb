require "test_helper"

class SanityTest < ActionDispatch::IntegrationTest

  test "manage the models in the demo" do
    sign_in_dummy_administrator!
    visit "/admin/blog_posts"
    assert page.has_content? "New Blog Post"
    visit "/admin/categories"
    assert page.has_content? "New Category"
  end

end

