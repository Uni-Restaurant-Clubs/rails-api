if Rails.env != "production"
  SanitizeEmail::Config.configure do |config|
    config[:sanitized_to] =         ENV["SANITIZE_EMAIL"]
    config[:sanitized_cc] =         ENV["SANITIZE_EMAIL"]
    config[:sanitized_bcc] =        ENV["SANITIZE_EMAIL"]
    # run/call whatever logic should turn sanitize_email on and off in this Proc:
    config[:activation_proc] =      Proc.new { %w(development test staging).include?(Rails.env) }
    config[:use_actual_email_prepended_to_subject] = true         # or false
    config[:use_actual_environment_prepended_to_subject] = true   # or false
    config[:use_actual_email_as_sanitized_user_name] = true       # or false
  end
end
