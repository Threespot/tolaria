require "test_helper"

class DemoTest < ActionDispatch::IntegrationTest

  test "managing the models in the demo" do

    sign_in_dummy_administrator!

    visit "/admin/blog_posts"
    assert page.has_content?("New Blog Post"), "create button is there"
    assert page.has_content?("Blog Posts"), "menu is there"
    assert page.has_content?("Categories"), "menu is there"

    visit "/admin/categories"
    assert page.has_content?("New Category")

  end

end

