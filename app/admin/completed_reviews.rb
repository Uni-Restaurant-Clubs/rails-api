ActiveAdmin.register_page "Completed Reviews" do
  menu priority: 4, label: "Completed Reviews"
  content title: "Completed Reviews" do
    columns do
      column do
        panel "Reviewed and Needing Content" do
          table_for Restaurant.brooklyn.reviewed_without_content do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Reviewed at") do |rest|
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
            column("Photos handed in?") do |rest|
              rest.photographer_handed_in_photos
            end
            column("Article handed in?") do |rest|
              rest.writer_handed_in_article
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Confirming if restaurants were reviewed or not" do
          table_for Restaurant.brooklyn.confirming_review_happened do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
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
        panel "Completed Reviewed" do
          table_for Restaurant.brooklyn.reviewed_with_content do
            column("Name") { |rest| link_to(rest.name, admin_restaurant_path(rest)) }
            column("Reviewed at") do |rest|
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
            column("Review") do |rest|
              if rest.reviews.any?
                link_to("Review", admin_review_path(rest.reviews.first))
              end
            end
          end
        end
      end
    end
  end
end
