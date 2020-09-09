class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  validates_presence_of :password, require: true
  validates :email, uniqueness: true, presence: true
end
