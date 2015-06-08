require "test_helper"

class RouterTest < ActionDispatch::IntegrationTest

  test "draws admin routes" do
    assert admin_new_session_path
    assert admin_destroy_session_path
    assert admin_root_path
  end

  test "draws automatic model routes" do

    class ::Card < ActiveRecord::Base
      manage_with_tolaria using:{
        allowed_actions: [:index, :show]
      }
    end

    # Re-draw the routes
    Rails.application.routes.draw do
      Tolaria.draw_routes(self)
    end

    # Test all of the routes Tolaria should have drawn
    # from here and from the demo application

    assert_equal admin_cards_path, "/admin/cards"
    assert_equal admin_card_path(1), "/admin/cards/1"

    assert admin_blog_posts_path
    assert admin_blog_posts_path(1)
    assert edit_admin_blog_post_path(1)
    assert admin_blog_post_path(1)

    assert admin_categories_path
    assert admin_category_path(1)
    assert edit_admin_category_path(1)
    assert admin_category_path(1)

    # Unseat the Card class so that it doesn't leak out of this test
    assert Tolaria.discard_managed_class(Card)
    Object.send(:remove_const, :Card)

  end

end
