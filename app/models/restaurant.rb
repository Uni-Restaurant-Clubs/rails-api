class Restaurant < ApplicationRecord

  has_one :address

  validates_presence_of [:name, :status]

  enum status: { added: 0, archived: 1, declined: 2, accepted: 3, scheduled: 4,
                 reviewed: 5 }

  accepts_nested_attributes_for :address, :allow_destroy => true
end
