require "test_helper"

class FilterPreservationTest < ActionDispatch::IntegrationTest

  def setup
    BlogPost.destroy_all
  end

  def teardown
    BlogPost.destroy_all
  end

  test "after filtering index, should retain filter on edit and back with crumb" do
    sign_in_dummy_administrator!
    visit("/admin/administrators")
    find_link("Organization").click
    find_link("Nintendo").click
    first(".crumb a").click
    assert page.current_url.include?("q%5Bs%5D=organization+asc"), "filter not retained"
  end

  test "after filtering index, should retain filter on edit and back with button" do
    sign_in_dummy_administrator!
    visit("/admin/administrators")
    find_link("Organization").click
    find_link("Nintendo").click
    first(".button.-cancel").click
    assert page.current_url.include?("q%5Bs%5D=organization+asc"), "filter should be retained"
  end

  test "after filtering index, should retain filter on edit and save" do
    sign_in_dummy_administrator!
    visit("/admin/administrators")
    find_link("Organization").click
    find_link("Nintendo").click
    first(".button.-save").click
    assert page.current_url.include?("q%5Bs%5D=organization+asc"), "filter not retained"
  end

  test "after filtering index, should retain filter on edit and failed validation" do
    sign_in_dummy_administrator!
    visit("/admin/administrators")
    find_link("Organization").click
    find_link("Nintendo").click
    fill_in("administrator[email]", with:"")
    first(".button.-save").click
    first(".button.-cancel").click
    assert page.current_url.include?("q%5Bs%5D=organization+asc"), "filter retained"
  end

  test "after filtering index, should NOT retain filter on save and review" do
    sign_in_dummy_administrator!
    visit("/admin/administrators")
    find_link("Organization").click
    find_link("Nintendo").click
    first(".button.-save-and-review").click
    assert page.current_url.exclude?("q%5Bs%5D=organization+asc"), "filter not retained"
  end

end
