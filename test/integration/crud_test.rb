require "test_helper"

class CRUDTest < ActionDispatch::IntegrationTest

  test "get the blog index and see empty slate" do
    BlogPost.destroy_all
    sign_in_dummy_administrator!
    visit "/admin/blog_posts"
    assert page.has_content? "New Blog Post"
    assert page.has_content? "Blog Posts"
    assert page.has_content? "live here"
  end

  test "create a blog post and see it on the index" do
    BlogPost.destroy_all
    sign_in_dummy_administrator!
    visit "/admin/blog_posts"
  end

end

