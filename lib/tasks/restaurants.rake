namespace :restaurants do
  desc "import all restaurant data"
  task import_data: :environment do
    Yelp.import_all_restaurants
  end

end
