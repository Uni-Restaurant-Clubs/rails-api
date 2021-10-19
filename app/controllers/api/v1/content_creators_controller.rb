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
    data = application_params

    error = false
    airbrake_error = nil
    status = 200
    if !code["success"]
      error = "Oops there was an issue and we are working on resolving it."
      airbrake_issue = "Recaptcha did not work for contact form"

    elsif code["score"] < 0.5
      error = "Oops there was an issue and we are working on resolving it."
      airbrake_issue = "Recaptcha code less than 0.5 for contact form"

    elsif !data[:email] || !data[:first_name] || !data[:last_name]
      error = ["Name, Email Address and Email Text must be added"]
      airbrake_issue = "Info for required fields missing"

    elsif EmailValidator.invalid?(data[:email]&.strip, mode: :strict)
      error = "Please enter a valid email address"
      airbrake_issue = "Email not valid"

    elsif ContentCreator.find_by(email: data[:email])
      error = "A creator with this email already exists"
      airbrake_issue = error

    elsif current_user && ContentCreator.find_by(email: current_user.email)
      error = "The email of your account is already associated with a creator"
      airbrake_issue = error
    end

    if error
      status = 400
      Airbrake.notify(airbrake_error, {
        recaptcha: code,
        data: data,
      })
      json = { error: true, message: error }.to_json
      render json: json, status: status
    else
      #create content creator with status of applied
      data[:status] = "applied"
      data[:email] = current_user&.email if current_user
      creator = ContentCreator.new(data)
      if creator.save!
        #AdminMailer.with(data: data).new_contact_form_submission_email.deliver_later
        render json: {}, status: 200
      else
        Airbrake.notify("could not create creator", {
          data: data,
          errors: creator.errors.full_messages
        })
        json = { error: true,
                 message: "Oops something went wrong. Please try again soon." }.to_json
        render json: json, status: 400
      end
    end

  end

  private

    def application_params
      params.require(:creator).permit(:firstName, :lastName, :email, :recaptchaToken)
            .to_h.deep_transform_keys!(&:underscore)
    end

end
