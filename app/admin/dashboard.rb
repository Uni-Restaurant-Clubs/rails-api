ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Daily Page Views' do
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
