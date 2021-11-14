namespace :admin do
  desc "send morning updates"
  task send_morning_updates: :environment do
    Restaurant.send_daily_update_emails("morning")
  end

end
