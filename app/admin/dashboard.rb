ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t('active_admin.dashboard') } do
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
        panel "Instagram post must be posted for these restaurants today" do
          two_days_ago = TimeHelpers.now - 2.days
          table_for Review.where.not(review_is_up_email_sent_at: nil)
                    .where(promotion_intro_email_sent: false)
                    .where('review_is_up_email_sent_at < ?', two_days_ago) do

            column("Name") { |rev| link_to(rev.restaurant.name, admin_restaurant_path(rev.restaurant.id)) }
          end
        end
      end
    end
    columns do
      column do
        panel 'Unique Daily User Visits' do
          line_chart ChartData.unique_user_page_views_by_day
        end
      end
    end
    columns do
      column do
        panel 'Total Daily Page Views' do
          #line_chart ChartData.daily_page_views
          line_chart LogEvent.page_views.group_by_day(:created_at).count
        end
      end
    end
    columns do
      column do
        panel 'Daily Page Views per Page' do
          line_chart ChartData.daily_page_views_by_page
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
