ActiveAdmin.register_page "Promotion Stages" do
  menu priority: 4, label: "Promotion Stages"

  content title: "Promotion Stages" do
    columns do
      column do
        panel "Need to send review is up email" do
          table_for PromotionInfo.where(restaurant_status: :need_to_send_review_is_up_email) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
      column do
        panel "Need to post to instagram" do
          table_for PromotionInfo.where(restaurant_status: :need_to_send_promo_intro_email) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
      column do
        panel "Need to send promo intro email" do
          table_for PromotionInfo.where(restaurant_status: :need_to_send_promo_intro_email) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
    end
    columns do
      column do
        panel "Sent promotional intro email and waiting for reply" do
          table_for PromotionInfo.where(restaurant_status: :sent_promotional_intro_email) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
      column do
        panel "Interested and need to get ready" do
          table_for PromotionInfo.where(restaurant_status: :interested) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
      column do
        panel "Ready to be featured" do
          table_for PromotionInfo.where(restaurant_status: :ready_to_be_featured) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
    end
    columns do
      column do
        panel "Being featured" do
          table_for PromotionInfo.where(restaurant_status: :being_featured) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
      column do
        panel "Previously Featured" do
          table_for PromotionInfo.where(restaurant_status: :previously_featured) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
      column do
        panel "Not interested" do
          table_for PromotionInfo.where(restaurant_status: :not_interested) do
            column("Name") { |pi| link_to(pi.restaurant.name, admin_promotion_info_path(pi)) }
          end
        end
      end
    end
  end
end
