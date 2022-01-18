ActiveAdmin.register_page "scheduled reviews" do
  menu priority: 3, label: "Scheduled Reviews"
  content title: "Scheduled Reviews" do
    columns do
      column do
        panel "TODAY'S REVIEWS!", class: "today-reviews" do
          table_for Restaurant.brooklyn.review_scheduled.scheduled_today do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Time") do |rest|
              rest.scheduled_review_date_and_time
            end
            column("Confirmed with restaurant?") do |rest|
              rest.confirmed_with_restaurant_day_of_review
            end
            column("Confirmed with writer?") do |rest|
              rest.confirmed_with_writer_day_of_review
            end
            column("Confirmed with photographer?") do |rest|
              rest.confirmed_with_photographer_day_of_review
            end
            column("photographer") do |rest|
              if rest.photographer
                link_to(rest.photographer.name, admin_content_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_content_creator_path(rest.writer))
              end
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Tomorrow's Reviews", class: "tomorrow-reviews"  do
          table_for Restaurant.brooklyn.review_scheduled.scheduled_tomorrow do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column :confirmed_with_restaurant_three_days_before
            column :confirmed_with_creators_day_before
            column("Time") do |rest|
              rest.scheduled_review_date_and_time
            end
            column("photographer") do |rest|
              if rest.photographer
                link_to(rest.photographer.name, admin_content_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_content_creator_path(rest.writer))
              end
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Reviews in 2 days", class: "reviews-in-three-days" do
          table_for Restaurant.brooklyn.review_scheduled.scheduled_in_two_days do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column :confirmed_with_restaurant_three_days_before
            column("Time") do |rest|
              rest.scheduled_review_date_and_time
            end
            column("photographer") do |rest|
              if rest.photographer
                link_to(rest.photographer.name, admin_content_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_content_creator_path(rest.writer))
              end
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Scheduled (but not for next 3 days)" do
          table_for Restaurant.brooklyn.scheduled_but_not_for_next_three_days do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Scheduled datetime") do |rest|
              rest.scheduled_review_date_and_time
            end
            column("photographer") do |rest|
              if rest.photographer
                link_to(rest.photographer.name, admin_content_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_content_creator_path(rest.writer))
              end
            end
          end
        end
      end
    end
  end
end
