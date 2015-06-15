require "test_helper"

class HelpLinkTest < ActionDispatch::IntegrationTest

  test "demo help link is rendering, Markdown works" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts")
    assert page.has_content?("Markdown Help")
    visit("/admin/help/markdown-help")
    assert page.has_content?("paragraph"), "Should see Markdown help"
  end

  test "link_to Help links work" do

    sign_in_dummy_administrator!
    original_config = Tolaria.config.help_links

    Tolaria.config.help_links = [{
      title: "Google",
      link_to: "https://www.google.com",
    }]
    Tolaria.reload!
    visit("/admin/blog_posts")
    assert page.has_content?("Google"), "Should see Google link"

    Tolaria.config.help_links = original_config
    Tolaria.reload!

  end

  test "reject invalid HelpLinks" do

    @original_config = Tolaria.config.help_links

    assert_raises RuntimeError do
      Tolaria.config.help_links = [{
        title: "Evon Gnashblade",
      }]
      Tolaria.reload!
    end

    assert_raises RuntimeError do
      Tolaria.config.help_links = [{
        title: "Evon Gnashblade",
        markdown_file: "junk"
      }]
      Tolaria.reload!
    end

    assert_raises RuntimeError do
      Tolaria.config.help_links = [{
        title: "Evon Gnashblade",
        markdown_file: "junk",
        slug: "evon",
        link_to: "evon"
      }]
      Tolaria.reload!
    end

    assert_raises RuntimeError, ArgumentError do
      Tolaria.config.help_links = [{
        link_to: "junk"
      }]
      Tolaria.reload!
    end

    Tolaria.config.help_links = @original_config
    Tolaria.reload!

  end

end

