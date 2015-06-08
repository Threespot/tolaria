require "test_helper"

class ManagedClassesTest < ActionDispatch::IntegrationTest

  test "can manage, check, and unmanage a model" do

    class ::Card < ActiveRecord::Base
      manage_with_tolaria using:{
        icon: "credit-card",
        priority: 5,
        category: "Payments",
        default_order: "id DESC",
        paginated: true,
        allowed_actions: [:index, :show]
      }
    end

    # Re-draw the routes
    Rails.application.routes.draw do
      Tolaria.draw_routes(self)
    end

    # Find that class
    managed_class = Tolaria.managed_classes.select do |managed_class|
      managed_class.klass.eql?(Card)
    end.first

    # Did we find the class we just managed?
    assert managed_class.present?
    assert managed_class.klass.eql?(Card)

    # Can we see the routes?
    assert admin_cards_path
    assert admin_card_path(1)

    # Can we can get our settings back?
    assert_equal managed_class.icon, "credit-card"
    assert_equal managed_class.priority, 5
    assert_equal managed_class.category, "Payments"
    assert_equal managed_class.default_order, "id DESC"
    assert_equal managed_class.paginated, true
    assert_equal managed_class.allowed_actions, [:index, :show]

    # Can we check action allowances?
    assert_equal managed_class.allows?(:index), true
    assert_equal managed_class.allows?(:show), true
    assert_equal managed_class.allows?(:edit), false
    assert_equal managed_class.allows?(:discard), false

    # Are our autogenerated name are correct?
    assert_equal managed_class.controller_name, "CardsController"
    assert_equal managed_class.param_key, :card

    # Can we throw away our work?
    assert Tolaria.discard_managed_class(Card)

  end

end
