require "test_helper"

class NavigationLabelTest < ActionDispatch::IntegrationTest

  def setup
    Video.destroy_all
  end

  def teardown
    Video.destroy_all
  end

  test "navigation label is overidden" do

    sign_in_dummy_administrator!

    # index view is overridden
    visit("/admin/videos")
    assert page.has_content?("YouTube Videos")
    assert page.has_content?("New YouTube Video")
    assert page.has_content?("No YouTube Videos live here")

    # new/edit view is overriden
    first(".button.-primary").click
    assert page.has_content?("New YouTube Video")
    fill_in("video[title]", with:"Neko Atsume")
    fill_in("video[youtube_id]", with:"xxxxxxxxxxx")
    first(".button[name=save]").click

    # created flash message is overridden
    assert page.has_content?("created the YouTube Video"), "should see flash message"

    # show view is overriden
    find_link("Inspect").click
    assert page.has_content?("YouTube Videos")
    assert page.has_content?("Edit This YouTube Video")

    # updated flash message is overriden
    first(".button.-primary").click
    first(".button[name=save]").click
    assert page.has_content?("updated the youtube video"), "should see flash message"

  end

end
