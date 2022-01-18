ActiveAdmin.register_page "Accepted Unscheduled Reviews" do
  menu priority: 2, label: "Accepted Unscheduled Reviews"
  content title: "Accepted Unscheduled Reviews" do
    columns do
      column do
        panel "(ACTIVE) Accepted with 3 options and needing confirmed review time" do
          table_for Restaurant.brooklyn.active_review_dates
                              .has_date_options_and_not_reviewed_or_scheduled do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Accepted at") { |rest| rest.accepted_at }
            column("Initial Offer Sent to Creators?") do |rest|
              rest.initial_offer_sent_to_creators
            end
            column("Writer Confirmed?") { |rest| rest.writer_confirmed }
            column("Photographer Confirmed?") { |rest| rest.photographer_confirmed }
            column("Final datetime confirmed with restaurant") do |rest|
              rest.scheduled_review_date_and_time.present?
            end
          end
        end
      end
    end
    columns do
      column do
        panel "(ACTIVE) Accepted and needing 3 date options" do
          table_for Restaurant.brooklyn.three_options_nil.accepted.active_review_dates do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Accepted at") { |rest| rest.accepted_at }
            column("Initial Offer Sent to Creators?") do |rest|
              rest.initial_offer_sent_to_creators
            end
            column("Writer Confirmed?") { |rest| rest.writer_confirmed }
            column("Photographer Confirmed?") { |rest| rest.photographer_confirmed }
            column("Final datetime confirmed with restaurant") do |rest|
              rest.scheduled_review_date_and_time.present?
            end
          end
        end
      end
    end
    columns do
      column do
        panel "(INACTIVE) Accepted with 3 options and needing confirmed review time" do
          table_for Restaurant.brooklyn.inactive_review_dates
                              .has_date_options_and_not_reviewed_or_scheduled do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Accepted at") { |rest| rest.accepted_at }
            column("Initial Offer Sent to Creators?") do |rest|
              rest.initial_offer_sent_to_creators
            end
            column("Writer Confirmed?") { |rest| rest.writer_confirmed }
            column("Photographer Confirmed?") { |rest| rest.photographer_confirmed }
            column("Final datetime confirmed with restaurant") do |rest|
              rest.scheduled_review_date_and_time.present?
            end
          end
        end
      end
    end
    columns do
      column do
        panel "(INACTIVE) Accepted and needing 3 date options" do
          table_for Restaurant.brooklyn.has_three_options.accepted.inactive_review_dates do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Accepted at") { |rest| rest.accepted_at }
            column("Initial Offer Sent to Creators?") do |rest|
              rest.initial_offer_sent_to_creators
            end
            column("Writer Confirmed?") { |rest| rest.writer_confirmed }
            column("Photographer Confirmed?") { |rest| rest.photographer_confirmed }
            column("Final datetime confirmed with restaurant") do |rest|
              rest.scheduled_review_date_and_time.present?
            end
          end
        end
      end
    end
  end
end
