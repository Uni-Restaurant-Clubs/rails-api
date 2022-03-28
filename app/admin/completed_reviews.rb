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
        panel "Completed Reviews Needing to create Promotion Info" do
          table_for Restaurant.has_completed_reviews_needing_promotion_info do
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
            column("Promotion Info") do |restaurant|
              promotion_info = restaurant.promotion_info
              if !promotion_info
                button_to "Create a Promotion Info for this restaurant",
                  create_promotion_info_admin_restaurant_path(restaurant.id),
                  action: :post,
                  :data => {:confirm => 'Are you sure you want to create a promotion info for this restaurant?'}
              else
                link_to "Promotion Info", admin_promotion_info_path(restaurant.promotion_info&.id)
              end
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Completed Reviews and Promotion Info created" do
          table_for Restaurant.has_completed_reviews_and_promotion_info_created do
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
            column("Promotion Info") do |restaurant|
              promotion_info = restaurant.promotion_info
              if !promotion_info
                button_to "Create a Promotion Info for this restaurant",
                  create_promotion_info_admin_restaurant_path(restaurant.id),
                  action: :post,
                  :data => {:confirm => 'Are you sure you want to create a promotion info for this restaurant?'}
              else
                link_to "Promotion Info", admin_promotion_info_path(restaurant.promotion_info&.id)
              end
            end
          end
        end
      end
    end
=begin
    # used with the automated sending "review is up system"
    columns do
      column do
        panel "Completed Reviews Needing to Send Review is Up Email" do
          table_for Restaurant.brooklyn.reviewed_with_content.review_is_up_email_not_sent do
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
    columns do
      column do
        panel "Completed Reviews and Review is Up Email Sent" do
          table_for Restaurant.brooklyn.reviewed_with_content.review_is_up_email_sent do
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
=end
  end
end
