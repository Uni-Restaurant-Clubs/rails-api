class ApplicationController < ActionController::Base

  def set_admin_timezone
    Time.zone = 'Eastern Time (US & Canada)'
  end

  def access_denied(exception)
    redirect_to admin_dashboard_path, alert: exception.message
  end
end
