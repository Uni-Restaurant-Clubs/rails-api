class Restaurant < ApplicationRecord

  has_one :address

  validates_presence_of [:name, :status]

  enum status: { added: 0, contacted_needs_follow_up: 1, declined: 2,
                 accepted: 3, review_scheduled: 4, reviewed: 5, archived: 6 }

  accepts_nested_attributes_for :address, :allow_destroy => true
end
