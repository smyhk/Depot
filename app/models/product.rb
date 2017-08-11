class Product < ApplicationRecord

  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, presence: true, uniqueness: true, length: { minimum: 10 }
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :image_url, presence: true, format: {
    allow_blank: true,
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: "must be a URL for GIF, JPG or PNG image."
  }

  private

    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line items present')
        throw :abort
      end
    end

end
