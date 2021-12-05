class ChartData

  def self.unique_user_page_views_by_day
    LogEvent.page_views.unique_grouped_by_day
  end

  # daily page views
  def self.daily_page_views

    page_view_sum_by_day = LogEvent.page_views.grouped_by_day.map do |day|
      [day[0], day[1].count]
    end

    [
      { name: "Page views per day", data: page_view_sum_by_day }
    ]

  end

  def self.daily_page_views_by_page

    data = []
    page_view_sum_by_day = LogEvent.page_views.grouped_by_label.map do |label|
      data << {
        name: label[0],
        data: LogEvent.where(label: label[0]).grouped_by_day.map { |day| [day[0], day[1].count] }
      }
    end

    return  data

  end

end

