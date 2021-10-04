namespace :restaurants do
  desc "import all restaurant data"
  task import_data: :environment do
    Yelp.import_all_locations
  end

  desc "Start confirming that reviews happened"
  task confirm_reviews_happened: :environment do
    Restaurant.start_confirming_if_reviews_happened_process
  end

end
