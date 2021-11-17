class CreatorReviewOffer::CreateAndSendOffersToAllWorker
  include Sidekiq::Worker

  def perform(offer_id, reason)
    CreatorMatching.send_offers_to_everyone_if_havent_yet(offer_id, reason)
  end
end
