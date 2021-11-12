namespace :restaurants do
  desc "import all restaurant data"
  task import_data: :environment do
    Yelp.import_all_locations
  end

  desc "Start confirming that reviews happened"
  task confirm_reviews_happened: :environment do
    Restaurant.start_confirming_if_reviews_happened_process
  end

  desc "Check for no responses on offers sent out and send to everyone if it's been more than 24 hours."
  task check_offers_for_no_responses: :environment do
    CreatorMatching.check_for_no_answers
  end

end
