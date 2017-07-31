class Product < ApplicationRecord

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :image_url, presence: true, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: "must be a URL ofr GIF, JPG or PNG image."
  }

end
