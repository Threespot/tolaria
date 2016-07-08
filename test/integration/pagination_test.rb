require "test_helper"

class PaginationTest < ActionDispatch::IntegrationTest

  def setup
    BlogPost.destroy_all
    50.times do
      BlogPost.create!({
        title: SecureRandom.uuid,
        body: "X",
        summary: "X",
        published_at: Time.current,
      })
    end
  end

  def teardown
    BlogPost.destroy_all
  end

  test "shows pagination and its usable" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts")
    assert page.has_content?("Next")
    assert page.has_content?("Last")
    assert page.has_content?("3")
    visit("/admin/blog_posts?p=3")
    assert page.has_content?("Next")
    assert page.has_content?("Last")
    assert page.has_content?("First")
    assert page.has_content?("Prev")
  end

  test "after paginating index, should retain page on edit and back with crumb" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts?p=3")
    first(".button.-edit").click # Open the editor form for a random blog post
    first(".crumb a").click
    assert page.current_url.include?("p=3"), "page should be retained"
  end

  test "after paginating index, should retain page on edit and back with button" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts?p=3")
    first(".button.-edit").click # Open the editor form for a random blog post
    first(".button.-cancel").click
    assert page.current_url.include?("p=3"), "page should be retained"
  end

  test "after paginating index, should retain page on edit and save" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts?p=3")
    first(".button.-edit").click # Open the editor form for a random blog post
    first(".button.-save").click
    assert page.current_url.include?("p=3"), "page should be retained"
  end

  test "after paginating index, should retain page on edit and failed validation" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts?p=3")
    first(".button.-edit").click # Open the editor form for a random blog post
    fill_in("blog_post[title]", with:"")
    first(".button.-save").click
    first(".button.-cancel").click
    assert page.current_url.include?("p=3"), "page should be retained"
  end

  test "after paginating index, should NOT retain page on save and review" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts?p=3")
    first(".button.-edit").click # Open the editor form for a random blog post
    first(".button.-save-and-review").click
    assert page.current_url.exclude?("p=3"), "page should not have been retained"
  end

end
