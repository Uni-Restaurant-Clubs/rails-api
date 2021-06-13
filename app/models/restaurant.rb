class Restaurant < ApplicationRecord

  has_one :address

  validates_presence_of [:name, :address_id, :status]

  enum status: { new: 0, archived: 1, declined: 2, accepted: 3, scheduled: 4,
                 reviewed: 5 }

end
