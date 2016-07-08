require "test_helper"

class PaginationTest < ActionDispatch::IntegrationTest

  test "shows pagination and its usable" do

    50.times do
      BlogPost.create!({
        title: SecureRandom.uuid,
        body: "X",
        summary: "X",
        published_at: Time.current,
      })
    end

    sign_in_dummy_administrator!
    visit("/admin/blog_posts")
    assert page.has_content?("Next")
    assert page.has_content?("Last")
    assert page.has_content?("3")
    visit("/admin/blog_posts?page=3")
    assert page.has_content?("Next")
    assert page.has_content?("Last")
    assert page.has_content?("First")
    assert page.has_content?("Prev")

    BlogPost.destroy_all

  end

end
