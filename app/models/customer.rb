class Customer < ActiveRecord::Base

  validates :uuid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

end
