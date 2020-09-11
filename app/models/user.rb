class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  validates_presence_of :password, require: true
  validates :email, uniqueness: true, presence: true

  enum role: %w(user merchant admin)

  def update_user_info(params)
    if User.find_by(email: params[:email]) && params[:email] != self.email
      return false
    else
      update_attribute(:name, params[:name])
      update_attribute(:address, params[:address])
      update_attribute(:city, params[:city])
      update_attribute(:state, params[:state])
      update_attribute(:zip, params[:zip])
      update_attribute(:email, params[:email])
      return true
    end
  end
end
