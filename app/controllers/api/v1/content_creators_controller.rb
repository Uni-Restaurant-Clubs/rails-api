class Api::V1::ContentCreatorsController < Api::V1::ApiApplicationController
  before_action :check_for_api_user

  def show
    creator = ContentCreator.find_by(public_unique_username: params[:id])
    if !creator
      json = { error: true, message: "No review for restaurant" }.to_json
      render json: json, status: 404
    else
      render json: creator, status: 200, serializer: ContentCreatorSerializer
    end
  end

  def submit_application
  code = Recaptcha.get_code(params["recaptchaToken"])


  error = false
  status = 200
  if !code["success"]
    error = "Oops there was an issue and we are working on resolving it."
    status = 500
    Airbrake.notify("Recaptcha did not work for contact form", {
      error: code["error-codes"],
      email: params["email"],
      text: params["text"],
      name: params["name"],
      current_user_email: current_user&.email
    })
  elsif code["score"] < 0.5
    error = "Oops there was an issue and we are working on resolving it."
    status = 401
    Airbrake.notify("Recaptcha code less than 0.5 for contact form", {
      recaptcha_score: code["score"],
      email: params["email"],
      text: params["text"],
      name: params["name"],
      current_user_email: current_user&.email
    })
  elsif !params["email"]&.present? || !params["text"]&.present? || !params["name"]&.present?
    error = ["Name, Email Address and Email Text must be added"]
    status = 400

  elsif EmailValidator.invalid?(params["email"]&.strip, mode: :strict)
    error = "Please enter a valid email address"
    status = 400
  end

  if error
    json = { error: true, message: error }.to_json
    render json: json, status: status
  else
    email_data = {
      name: params["name"],
      email: params["email"]&.strip,
      text: params["text"],
      current_user_email: current_user&.email
    }
    AdminMailer.with(email_data).new_contact_form_submission_email.deliver_later
    render json: {}, status: 200
  end

  end

end
