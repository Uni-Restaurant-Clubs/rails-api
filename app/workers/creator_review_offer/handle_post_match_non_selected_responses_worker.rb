class CreatorReviewOffer::HandlePostMatchNonSelectedResponsesWorker
  include Sidekiq::Worker

  def perform(rest_id)
    rest = Restaurant.find_by(id: rest_id)
    rest.creator_review_offers.where(responded_at: nil).destroy_all
    rest.send_non_selected_emails_to_all_non_selected_responded_to_offers
  end
end
