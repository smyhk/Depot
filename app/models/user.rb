class User < ApplicationRecord

  validates :name, presense: true, uniqueness: true
  has_secure_password
end
