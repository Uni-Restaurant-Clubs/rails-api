class Restaurant < ApplicationRecord

  has_one :address, dependent: :destroy

  validates_presence_of [:name, :status]
  validates_uniqueness_of :yelp_id, allow_nil: true

  enum status: { not_contacted: 0, contacted_needs_follow_up: 1, declined: 2,
                 accepted: 3, review_scheduled: 4, reviewed: 5, archived: 6 }
  enum operational_status: { unknown: 0, temporarily_closed: 1,
                             permanently_closed: 2, currently_active: 3 }

  accepts_nested_attributes_for :address, :allow_destroy => true

  scope :franchise, lambda { where(is_franchise: true) }
  scope :not_franchise, lambda { where(is_franchise: false) }

  def self.categorize_as_franchise
    names = self.not_franchise.pluck(:name).uniq
    names.each do |name|
      restaurants = self.where(name: name)
      if restaurants.count > 1
        restaurants.update_all(is_franchise: true)
      end
    end
  end

end
