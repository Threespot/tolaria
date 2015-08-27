require "test_helper"

class CreateCardsMigration < ActiveRecord::Migration
  def change
    create_table :cards, force:true do |t|
      t.timestamps null:false
      t.string :title
    end
  end
end

class ForbiddenRoutesTest < ActionDispatch::IntegrationTest

  def setup
    ActiveRecord::Migration.verbose = false
    CreateCardsMigration.new.exec_migration(ActiveRecord::Base.connection, :up)
  end

  def teardown
    CreateCardsMigration.new.exec_migration(ActiveRecord::Base.connection, :down)
    ActiveRecord::Migration.verbose = true
  end

  test "handles classes with only the index action" do

    class ::Card < ActiveRecord::Base
      manage_with_tolaria using:{
        allowed_actions: [:index]
      }
      def to_param
        "card-#{id}"
      end
    end

    # Re-draw the routes and reload Tolaria
    Rails.application.routes.draw do
      Tolaria.draw_routes(self)
    end

    sign_in_dummy_administrator!
    visit admin_cards_path
    assert page.has_content?("Cards")
    refute page.has_content?("Create Card")

    # Unseat the Card class so that it doesn't leak out of this test
    assert Tolaria.discard_managed_class(Card), "should discard class"
    Object.send(:remove_const, :Card)

  end

  test "handles classes with only the show action" do

    class ::Card < ActiveRecord::Base
      manage_with_tolaria using:{
        allowed_actions: [:show]
      }
    end

    # Re-draw the routes and reload Tolaria
    Rails.application.routes.draw do
      Tolaria.draw_routes(self)
    end

    Card.create(title:"Urza")

    sign_in_dummy_administrator!
    visit admin_card_path(Card.first.id)
    assert page.has_content?("Urza")
    refute page.has_content?("Delete")

    # Unseat the Card class so that it doesn't leak out of this test
    assert Tolaria.discard_managed_class(Card), "should discard class"
    Object.send(:remove_const, :Card)

  end

  test "handles avoiding the index" do

    class ::Card < ActiveRecord::Base
      manage_with_tolaria using:{
        allowed_actions: [:show, :update, :edit, :destroy, :create, :new]
      }
    end

    # Re-draw the routes and reload Tolaria
    Rails.application.routes.draw do
      Tolaria.draw_routes(self)
    end

    Card.create(title:"Urza")

    sign_in_dummy_administrator!
    visit admin_card_path(Card.first.id)
    assert page.has_content?("Urza")
    assert page.has_content?("Delete")
    assert page.has_content?("Edit")

    assert_raises ActionView::Template::Error do
      visit new_admin_card_path
    end

    # Unseat the Card class so that it doesn't leak out of this test
    assert Tolaria.discard_managed_class(Card), "should discard class"
    Object.send(:remove_const, :Card)

  end

end
