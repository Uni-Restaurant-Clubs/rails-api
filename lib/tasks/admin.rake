namespace :admin do
  desc "send morning updates"
  task send_morning_updates: :environment do
    Restaurant.send_daily_update_emails("morning")
  end

  desc "send afternoon updates"
  task send_afternoon_updates: :environment do
    Restaurant.send_daily_update_emails("afternoon")
  end

end
