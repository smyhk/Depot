class StoreController < ApplicationController

  def index
    @products = Product.order(:title)
    @counter = increment_count
  end

end
