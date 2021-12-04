class ChartData

  # daily page views
  def self.daily_page_views

    page_view_sum_by_day = LogEvent.page_views.grouped_by_day.map do |day|
      [day[0], day[1].count]
    end

    [
      { name: "Page views per day", data: page_view_sum_by_day }
    ]

  end
end

