class Invoice < ActiveRecord::Base
  belongs_to :customer

  delegate :uuid, to: :customer

  validates :customer_id, presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 2015 }
  validates :month, presence: true, inclusion: { in: (1..12) }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

end
