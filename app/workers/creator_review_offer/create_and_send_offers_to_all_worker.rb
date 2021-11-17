class CreatorReviewOffer::CreateAndSendOffersToAllWorker
  include Sidekiq::Worker

  def perform(rest_id)
    CreatorMatching.send_offers_to_everyone_if_havent_yet(rest_id)
  end
end
