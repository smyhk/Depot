require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest

  include ActiveJob::TestHelper
  fixtures :products

  test "buying a product" do
    start_order_count = Order.count
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_select 'h1', "Your Pragmatic Calalog"

    post '/line_items', params: { product_id: ruby_book.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_select 'legend', "Please Enter Your Details"

    perform_enqueued_jobs do
      post "/orders", params: {
        order: {
          name:     "Steve King",
          address:  "123 Some Street",
          email:    "steve@example.com",
          pay_type: "Check"
        }
      }

      follow_redirect!

      assert_response :success
      assert_select 'h1', "Your Pragmatic Calalog"
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size

      assert_equal start_order_count + 1, Order.count
      order = Order.last

      assert_equal "Steve King",        order.name
      assert_equal "123 Some Street",   order.address
      assert_equal "steve@example.com", order.email
      assert_equal "Check",             order.pay_type

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal ruby_book, line_item.product

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["steve@example.com"],                mail.to
      assert_equal "Steve <depot@example.com>",          mail[:from].value
      assert_equal "Pragmatic Store Order Confirmation", mail.subject
    end
  end

end
