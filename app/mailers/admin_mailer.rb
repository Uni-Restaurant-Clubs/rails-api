class AdminMailer < ApplicationMailer

  default to: "hello@unirestaurantclub.com"

  def new_contact_form_submission_email
    @name = params[:name]
    @email = params[:email]
    @text = params[:text]
    @current_user_email = params[:current_user_email]

    mail subject: "New Contact Form Submission"
  end
end
