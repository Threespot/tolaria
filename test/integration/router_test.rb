require "test_helper"

class RouterTest < ActionDispatch::IntegrationTest

  test "draws admin routes" do
    assert admin_new_session_path, "route should exist"
    assert admin_destroy_session_path, "route should exist"
    assert admin_root_path, "route should exist"
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

    assert admin_blog_posts_path, "route should exist"
    assert admin_blog_posts_path(1), "route should exist"
    assert edit_admin_blog_post_path(1), "route should exist"
    assert admin_blog_post_path(1), "route should exist"

    assert admin_topics_path, "route should exist"
    assert admin_topic_path(1), "route should exist"
    assert edit_admin_topic_path(1), "route should exist"
    assert admin_topic_path(1), "route should exist"

    # Unseat the Card class so that it doesn't leak out of this test
    assert Tolaria.discard_managed_class(Card), "should discard class"
    Object.send(:remove_const, :Card)

  end

  test "correctly draws uncountable routes" do

    ActiveSupport::Inflector.inflections do |inflect|
      inflect.uncountable << "pokemon"
    end

    class ::Pokemon < ActiveRecord::Base
      manage_with_tolaria using:{
        icon: "gear",
      }
    end

    # Re-draw the routes
    Rails.application.routes.draw do
      Tolaria.draw_routes(self)
    end

    assert_equal "/admin/pokemon", admin_pokemon_index_path
    assert_equal "/admin/pokemon/1", admin_pokemon_path(1)
    assert_equal "/admin/pokemon/1/edit", edit_admin_pokemon_path(1)

    # Unseat the class so that it doesn't leak out of this test
    assert Tolaria.discard_managed_class(Pokemon), "should discard class"
    Object.send(:remove_const, :Pokemon)

  end

end
