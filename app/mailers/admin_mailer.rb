class AdminMailer < ApplicationMailer

  default to: "hello@unirestaurantclub.com"

  def new_contact_form_submission_email
    @name = params[:name]
    @email = params[:email]
    @text = params[:text]
    @current_user_email = params[:current_user_email]

    mail subject: "New Contact Form Submission"
  end

  # a creator just confirmed that a review happened
  def just_reviewed_email_true
    @confirmation = params[:confirmation]
    @creators_html = TextContent.find_by(name: "creators just reviewed email")
    @restaurant_html = TextContent.find_by(name: "restaurant just reviewed email")
    @restaurant = @confirmation.restaurant
    @response = @confirmation.response
    @creator = @confirmation.creator

    mail subject: "A review just happened!"
  end

  # a creator just confirmed that a review DID NOThappen
  # we need to follow up to see what happened
  def just_reviewed_email_false
    @confirmation = params[:confirmation]

    mail subject: "UH OH a review did NOT happen!"
  end
end
