class StoreController < ApplicationController

  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart

  def index
    @products = Product.order(:title)
    @counter = increment_count
  end

end
