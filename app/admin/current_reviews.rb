ActiveAdmin.register_page "Reviews in progress" do
  menu priority: 2, label: "Reviews in progress"

  content title: "Reviews In Progress" do
    columns do
      column do
        panel "TODAY'S REVIEWS!" do
          table_for Restaurant.brooklyn.scheduled_today do
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
                link_to(rest.photographer.name, admin_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_creator_path(rest.writer))
              end
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Tomorrow's Reviews" do
          table_for Restaurant.brooklyn.scheduled_tomorrow do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Time") do |rest|
              rest.scheduled_review_date_and_time
            end
            column("photographer") do |rest|
              if rest.photographer
                link_to(rest.photographer.name, admin_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_creator_path(rest.writer))
              end
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Newly Accepted" do
          table_for Restaurant.brooklyn.accepted do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Accepted at") { |rest| rest.accepted_at }
            column("Initial Offer Sent to Creators?") do |rest|
              rest.initial_offer_sent_to_creators
            end
            column("Writer Confirmed?") { |rest| rest.writer_confirmed }
            column("Photographer Confirmed?") { |rest| rest.writer_confirmed }
            column("Final datetime confirmed with restaurant") do |rest|
              rest.scheduled_review_date_and_time.present?
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Scheduled" do
          table_for Restaurant.brooklyn.scheduled_but_not_for_today_or_tomorrow do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Scheduled datetime") do |rest|
              rest.scheduled_review_date_and_time
            end
            column("photographer") do |rest|
              if rest.photographer
                link_to(rest.photographer.name, admin_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_creator_path(rest.writer))
              end
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Recently Reviewed" do
          table_for Restaurant.brooklyn.reviewed_without_content do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Reviewed at") do |rest|
              rest.scheduled_review_date_and_time
            end
            column("photographer") do |rest|
              if rest.photographer
                link_to(rest.photographer.name, admin_creator_path(rest.photographer))
              end
            end
            column("writer") do |rest|
              if rest.writer
                link_to(rest.writer.name, admin_creator_path(rest.writer))
              end
            end
            column("Photos handed in?") do |rest|
              rest.photographers_handed_in_photos
            end
            column("Article handed in?") do |rest|
              rest.writer_handed_in_article
            end
          end
        end
      end
    end
  end
end
