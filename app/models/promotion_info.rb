class PromotionInfo < ApplicationRecord

  belongs_to :restaurant

  validates_presence_of [:restaurant_id]

  enum restaurant_status: {
    sent_promotional_intro_email: 0,
    not_interested: 1,
    interested_and_need_to_talk_details: 2,
    ready_to_be_featured: 3,
    being_featured: 4,
    previously_featured: 5
  }

end
